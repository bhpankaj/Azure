# Backup Commands — PowerShell + azcli

Target: AKS Cluster (1.34.x → 1.35.6)
Environment: Windows PowerShell (Az module + kubectl) + Azure CLI (az)
Output: Separate YAML file per resource category
Location: /run/media/black/dbfa0647-b941-4878-ab09-c84ba0c6879c/Azure/AKS/Upgrade_1.34_to_1.35.6/

---

## Prerequisites

```powershell
# Connect to Azure
Connect-AzAccount
# Or via CLI:
# az login

# Import AKS credentials (get kubeconfig)
Import-AzAksCredential -ResourceGroupName "<RG>" -Name "<Cluster>"
# Or via CLI:
# az aks get-credentials --resource-group <RG> --name <Cluster> --overwrite-existing

# Verify kubectl connectivity
kubectl cluster-info
```

---

## 1. Deployments — `backup_deployments.yaml`

```powershell
# PowerShell (kubectl)
kubectl get deployments --all-namespaces -o yaml | Out-File -FilePath "backup_deployments.yaml" -Encoding utf8

# CLI equivalent (same command, executed in PowerShell)
kubectl get deployments --all-namespaces -o yaml > "backup_deployments.yaml"
```

---

## 2. PodDisruptionBudgets — `backup_pdb.yaml`

```powershell
kubectl get pdb --all-namespaces -o yaml | Out-File -FilePath "backup_pdb.yaml" -Encoding utf8
```

---

## 3. ReplicaSets — `backup_replicaset.yaml`

```powershell
kubectl get replicaset --all-namespaces -o yaml | Out-File -FilePath "backup_replicaset.yaml" -Encoding utf8
```

---

## 4. PersistentVolumes — `backup_pv.yaml`

```powershell
kubectl get pv -o yaml | Out-File -FilePath "backup_pv.yaml" -Encoding utf8
```

---

## 5. PersistentVolumeClaims — `backup_pvc.yaml`

```powershell
kubectl get pvc --all-namespaces -o yaml | Out-File -FilePath "backup_pvc.yaml" -Encoding utf8
```

---

## 6. Ingress — `backup_ingress.yaml`

```powershell
kubectl get ingress --all-namespaces -o yaml | Out-File -FilePath "backup_ingress.yaml" -Encoding utf8
```

---

## 7. Complete One-Liner (Generate All Backups)

```powershell
# Create backup folder (if not already present)
$backupDir = "/run/media/black/dbfa0647-b941-4878-ab09-c84ba0c6879c/Azure/AKS/Upgrade_1.34_to_1.35.6"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Generate all 6 YAML files
kubectl get deployments --all-namespaces -o yaml > "$backupDir/backup_deployments.yaml"
kubectl get pdb --all-namespaces -o yaml > "$backupDir/backup_pdb.yaml"
kubectl get replicaset --all-namespaces -o yaml > "$backupDir/backup_replicaset.yaml"
kubectl get pv -o yaml > "$backupDir/backup_pv.yaml"
kubectl get pvc --all-namespaces -o yaml > "$backupDir/backup_pvc.yaml"
kubectl get ingress --all-namespaces -o yaml > "$backupDir/backup_ingress.yaml"

# Verify file creation
Get-ChildItem -Path $backupDir -Filter "backup_*.yaml" | Select-Object Name, Length, LastWriteTime
```

---

## 8. Verify Backup Integrity (Post-Backup Check)

```powershell
# Count resources backed up per file
Get-Content -Path "$backupDir/backup_deployments.yaml" | Select-String -Pattern "kind: Deployment" | Measure-Object -Line
Get-Content -Path "$backupDir/backup_pdb.yaml"     | Select-String -Pattern "kind: PodDisruptionBudget" | Measure-Object -Line
Get-Content -Path "$backupDir/backup_replicaset.yaml" | Select-String -Pattern "kind: ReplicaSet" | Measure-Object -Line
Get-Content -Path "$backupDir/backup_pv.yaml"        | Select-String -Pattern "kind: PersistentVolume" | Measure-Object -Line
Get-Content -Path "$backupDir/backup_pvc.yaml"      | Select-String -Pattern "kind: PersistentVolumeClaim" | Measure-Object -Line
Get-Content -Path "$backupDir/backup_ingress.yaml" | Select-String -Pattern "kind: Ingress" | Measure-Object -Line

# Check YAML syntactic validity using Python (if python3/yaml installed) — PowerShell equivalent command
python3 -c "
import yaml
files = ['backup_deployments.yaml','backup_pdb.yaml','backup_replicaset.yaml','backup_pv.yaml','backup_pvc.yaml','backup_ingress.yaml']
for fn in files:
    try:
        docs = list(yaml.safe_load_all(open(fn, 'r')))
        print(f'{fn}: {len(docs)} doc(s) OK')
    except Exception as e:
        print(f'{fn}: ERROR - {e}')
"
```

---

## 9. Restore From Backup (Emergency Rollback)

```powershell
# Restore deployments
kubectl apply -f "$backupDir/backup_deployments.yaml"
# Restore PDBs
kubectl apply -f "$backupDir/backup_pdb.yaml"
# Restore ReplicaSets
kubectl apply -f "$backupDir/backup_replicaset.yaml"
# Restore PV metadata (data must be restored separately at storage layer)
kubectl apply -f "$backupDir/backup_pv.yaml"
# Restore PVC metadata (volume data restored via storage snapshot / backup)
kubectl apply -f "$backupDir/backup_pvc.yaml"
# Restore Ingress
kubectl apply -f "$backupDir/backup_ingress.yaml"
```

---

## Notes

- These backups capture **resource definitions (metadata)**, not **data** inside PersistentVolumes. Data backup is handled separately (AKS disk snapshots, Azure Backup, storage-level replication).
- For management reporting, the file count and size are logged in the Verification section above.
- All commands are executable in Windows PowerShell with `kubectl` in PATH (`Install-AzAksCliTool` or manual kubectl download).
