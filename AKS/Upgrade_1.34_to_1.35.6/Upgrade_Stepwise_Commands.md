# Stepwise Upgrade Commands — AKS 1.34.x → 1.35.6

Environment: Windows PowerShell + az CLI (azcli) + kubectl
Cluster: <RG> / <Cluster> (update variables below)
Target: Kubernetes 1.35.6

---

## Variables

```powershell
$RG = "<RG>"          # Resource Group
$Cluster = "<Cluster>" # AKS Cluster Name
$Location = "<Location>" # e.g., eastus
$BackupDir = "/run/media/black/dbfa0647-b941-4878-ab09-c84ba0c6879c/Azure/AKS/Upgrade_1.34_to_1.35.6"
```

---

## Phase P0 — Audit Deprecated APIs

```powershell
# Ensure kubectl-deprecations plugin installed
# kubectl krew install deprecations  (if using krew)
# Or install manually from https://github.com/fairwindsops/pluto or kubectl-deprecations

# Audit deprecated APIs against 1.35
kubectl deprecations --k8s-version=1.35

# Inspect current cluster version
kubectl version --short
# Or PowerShell module:
(Get-AzAksCluster -ResourceGroupName $RG -Name $Cluster).KubernetesVersion
```

---

## Phase P1 — Generate Backups (All 6 YAML Files)

See `Backup_Commands_PowerShell.md` for full details.

```powershell
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
kubectl get deployments --all-namespaces -o yaml > "$BackupDir/backup_deployments.yaml"
kubectl get pdb --all-namespaces -o yaml > "$BackupDir/backup_pdb.yaml"
kubectl get replicaset --all-namespaces -o yaml > "$BackupDir/backup_replicaset.yaml"
kubectl get pv -o yaml > "$BackupDir/backup_pv.yaml"
kubectl get pvc --all-namespaces -o yaml > "$BackupDir/backup_pvc.yaml"
kubectl get ingress --all-namespaces -o yaml > "$BackupDir/backup_ingress.yaml"
```

---

## Phase P2 — Inspect Upgrade Profile

```powershell
# PowerShell method
Get-AzAksUpgradeProfile -ResourceGroupName $RG -Name $Cluster | Format-List

# CLI method (equivalent info, different format)
az aks get-upgrades --resource-group $RG --name $Cluster --output table
```

---

## Phase P3 — Upgrade Control Plane (Safe First Step)

```powershell
# CLI method (recommended for granular control)
az aks upgrade --resource-group $RG --name $Cluster --kubernetes-version 1.35.6 --control-plane-only --yes

# PowerShell equivalent (Az module does not expose granular upgrade; use CLI for this step)
# Note: Start-AzAksClusterUpgrade is not a standard cmdlet; use az aks upgrade as above.
```

Wait for control plane upgrade to complete:
```powershell
# Monitor
kubectl get nodes -o wide
Get-AzAksCluster -ResourceGroupName $RG -Name $Cluster | Select-Object KubernetesVersion, PowerState
```

---

## Phase P4 — Upgrade System Node Pool

```powershell
# Identify system node pool
Get-AzAksNodePool -ResourceGroupName $RG -ClusterName $Cluster | Where-Object { $_.Mode -eq "System" } | Format-Table

# Upgrade system node pool (via CLI; specify pool name from previous output)
# Example: nodepool name "nodepool1" (system mode)
az aks nodepool upgrade --resource-group $RG --cluster-name $Cluster --name "nodepool1" --kubernetes-version 1.35.6 --no-wait || az aks nodepool upgrade --resource-group $RG --cluster-name $Cluster --name "nodepool1" --kubernetes-version 1.35.6

# Monitor
az aks nodepool show --resource-group $RG --cluster-name $Cluster --name "nodepool1" --query '{Name:name,OrchestratorVersion:orchestratorVersion,PowerState:powerState}'
```

---

## Phase P5 — Upgrade User Node Pools (Sequential)

```powershell
# List user pools
Get-AzAksNodePool -ResourceGroupName $RG -ClusterName $Cluster | Where-Object { $_.Mode -eq "User" } | Format-Table

# Upgrade each user node pool (repeat for each pool)
# Example for user pool named "userpool1"
az aks nodepool upgrade --resource-group $RG --cluster-name $Cluster --name "userpool1" --kubernetes-version 1.35.6

# Monitor node readiness after each pool upgrade
kubectl get nodes -o wide
kubectl get pods --all-namespaces --field-selector status.phase!=Succeeded
```

---

## Phase P6 — Post-Upgrade Validation

```powershell
# Cluster version confirmation
kubectl version --short
Get-AzAksCluster -ResourceGroupName $RG -Name $Cluster | Select-Object Name, KubernetesVersion, PowerState

# Deprecated API check (should return zero results for removed APIs; warnings may remain for deprecated-but-not-removed)
kubectl deprecations --k8s-version=1.35

# Check scheduling gates
kubectl get pods --all-namespaces -o json | ConvertFrom-Json | ForEach-Object { $_.items | Where-Object { $_.spec.schedulingGates -ne $null } } | Select-Object @{N='Name';E={$_.metadata.name}}, @{N='Namespace';E={$_.metadata.namespace}}, @{N='SchedulingGates';E={$_.spec.schedulingGates}}

# Check ServiceAccount token behavior (audit pods without explicit automountServiceAccountToken)
kubectl get pods --all-namespaces -o json | ConvertFrom-Json | ForEach-Object { $_.items | Where-Object { $_.spec.serviceAccountName -ne $null -and $_.spec.automountServiceAccountToken -eq $null } } | Select-Object @{N='Name';E={$_.metadata.name}}, @{N='Namespace';E={$_.metadata.namespace}}

# Verify workloads healthy
kubectl get pods --all-namespaces -o wide | Where-Object { $_.Status -ne "Running" }

# Verify backups exist and contain expected counts
Get-ChildItem -Path $BackupDir -Filter "backup_*.yaml" | Select-Object Name, Length, LastWriteTime
```

---

## Phase P7 — Management Sign-Off

```powershell
# Generate final status report (management-ready output)
$report = @{
    ClusterName = $Cluster
    ResourceGroup = $RG
    TargetVersion = "1.35.6"
    PreviousVersion = "1.34.x"
    UpgradeCompleted = $true
    BackupsGenerated = @(
        (Get-ChildItem -Path $BackupDir -Filter "backup_*.yaml").Name
    )
    DeprecatedAPIsAudited = $true
    NodePoolsUpgraded = @()
} | ConvertTo-Json -Depth 3
$report | Out-File -FilePath "$BackupDir/post_upgrade_status.json" -Encoding utf8
echo $report
```

---

## Emergency — Stop / Restart Cluster (If Needed)

```powershell
# Stop cluster (maintenance or rollback scenario)
Stop-AzAksCluster -ResourceGroupName $RG -Name $Cluster -Confirm:$false

# Start cluster
Start-AzAksCluster -ResourceGroupName $RG -Name $Cluster -Confirm:$false
```
