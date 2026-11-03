# Deprecated APIs — Kubernetes 1.34 → 1.35.6 Upgrade

Reference: Kubernetes v1.35 Deprecation Guide (https://v1-35.docs.kubernetes.io/docs/reference/using-api/deprecation-guide)
Context: AKS upgrade from 1.34.x to 1.35.6 via PowerShell / azcli (Windows)

---

## 1. APIs Fully Removed Before or In 1.35

### 1.1 flowcontrol.apiserver.k8s.io/v1beta3
- Status: REMOVED in Kubernetes v1.32
- Impact: Any FlowSchema or PriorityLevelConfiguration using v1beta3 will fail to apply/read.
- Migration:
  BEFORE: apiVersion: flowcontrol.apiserver.k8s.io/v1beta3 / AFTER: apiVersion: flowcontrol.apiserver.k8s.io/v1
- Notable change: PriorityLevelConfiguration spec.limited.nominalConcurrencyShares only defaults to 30 when unspecified; explicit value of 0 is NOT changed to 30.

### 1.2 autoscaling/v2beta2
- Status: REMOVED (deprecated since 1.23, removed in 1.26/1.29 cycle)
- Migration: Use autoscaling/v2 (HorizontalPodAutoscaler)

---

## 2. APIs Deprecated (Still Served but Warning in 1.35)

### 2.1 core/v1 Endpoints
- Status: Officially deprecated in Kubernetes 1.35; returns deprecation warnings when accessed.
- Migration target: discovery.k8s.io/v1 EndpointSlices (kind: EndpointSlice)
- Migration action: Update clients to read EndpointSlice instead of Endpoints; update manifests referencing Endpoints to EndpointSlices.

### 2.2 kube-proxy IPVS Mode
- Status: Deprecated in 1.35; removal planned in 1.36.
- Migration action: Confirm kube-proxy is configured for nftables (default) or iptables, not ipvs.
- AKS context: AKS uses kube-proxy in nftables or iptables mode by default; verify via daemonset config.

---

## 3. Behavior Changes (Not API Removal, But Breaking)

### 3.1 ServiceAccount Token Auto-Mount Removed by Default
- Status: In Kubernetes 1.35, pods no longer receive an implicit ServiceAccount token unless explicitly requested.
- Breakage: Pods relying on implicit SA tokens for Kubernetes API access will receive 403 errors.
- Fix: Add to Pod spec: automountServiceAccountToken: true
- Audit command (PowerShell):
```powershell
kubectl get pods --all-namespaces -o json | ConvertFrom-Json | ForEach-Object {
    $_.items | Where-Object { $_.spec.serviceAccountName -ne $null -and $_.spec.automountServiceAccountToken -eq $null } |
    Select-Object @{N='Namespace';E={$_.metadata.namespace}}, @{N='Name';E={$_.metadata.name}}
}
```

### 3.2 Scheduling Readiness Gates
- Status: Pods can now have scheduling gates (spec.schedulingGates); third-party controllers may inject them unexpectedly.
- Audit command (PowerShell):
```powershell
kubectl get pods --all-namespaces -o json | ConvertFrom-Json | ForEach-Object {
    $_.items | Where-Object { $_.spec.schedulingGates -ne $null } |
    Select-Object @{N='Namespace';E={$_.metadata.namespace}}, @{N='Name';E={$_.metadata.name}}, @{N='Gates';E={$_.spec.schedulingGates}}
}
```

---

## 4. Kubelet / Node-Level Changes

### 4.1 --pod-infra-container-image Flag Removed
- Status: Removed in Kubernetes 1.35.
- Impact: Custom AMI / node image configurations that pass this kubelet flag will fail node startup.
- Fix: Remove flag from kubelet configuration (node image build scripts / kubelet systemd service / /etc/default/kubelet if custom).

### 4.2 cgroup v1 Support Deprecated
- Status: Kubernetes 1.35 deprecates cgroup v1; kubelet refuses to start by default on cgroup v1 nodes.
- Fix: Confirm nodes run cgroup v2. PowerShell verification via SSH to node or using node-level diagnostics. Expected: cgroup2fs.
- Audit (PowerShell remote / SSH equivalent): Confirm /sys/fs/cgroup/ filesystem reports cgroup2fs (not cgroup). In AKS this is standard on supported node images for 1.35+.

---

## 5. Pre-Upgrade Audit Commands (PowerShell / azcli + kubectl)

ALTERNATIVE when kubectl-deprecations plugin is NOT available:

Option A — Pluto (install separately: https://github.com/FairwindsOps/pluto):
```powershell
pluto detect-all-in-cluster --target-versions k8s=v1.35
```

Option B — Manual audit — list served API versions and filter deprecated tracks:
```powershell
kubectl get --raw /apis | ConvertFrom-Json | ForEach-Object {
    $groups = $_.groups
    foreach ($g in $groups) {
        $gv = $g.preferredVersion.groupVersion
        $deprecated = @('v1beta3', 'v1beta2', 'v2beta2', 'v1beta1')
        foreach ($d in $deprecated) {
            if ($gv -like "*$d*") {
                Write-Host ("DEPRECATED API FOUND: " + $gv + " - group: " + $g.name)
            }
        }
    }
}
```

Option C — Search live resources by apiVersion directly (no plugin needed):
```powershell
$deprecatedPattern = @("v1beta3", "v2beta2", "v1beta2")
$yaml = kubectl get deployments,replicasets,pods,services,pdb,ingress,pv,pvc,flowschema,prioritylevelconfiguration --all-namespaces -o yaml 2>$null
if ($yaml -match "apiVersion:.*v1beta3|apiVersion:.*v2beta2|apiVersion:.*v1beta2") {
    Write-Host "DEPRECATED apiVersion FOUND in live resources. Inspect above."
} else {
    Write-Host "No deprecated apiVersions (v1beta3, v2beta2, v1beta2) found in live resources."
}
```

Check deprecated Endpoints usage (manual audit — no plugin needed):
```powershell
kubectl get endpoints --all-namespaces -o yaml | Select-String -Pattern "endpoints"
```

Verify kube-proxy mode (indirect: check daemonset config):
```powershell
kubectl get daemonset kube-proxy -n kube-system -o yaml | Select-String -Pattern "mode"
```

Check ServiceAccount token usage in pods (audit for missing automountServiceAccountToken):
```powershell
kubectl get pods --all-namespaces -o json | ConvertFrom-Json | ForEach-Object {
    $_.items | Where-Object { $_.spec.serviceAccountName -ne $null -and $_.spec.automountServiceAccountToken -eq $null }
}
```

Check for scheduling gates:
```powershell
kubectl get pods --all-namespaces -o json | ConvertFrom-Json | ForEach-Object {
    $_.items | Where-Object { $_.spec.schedulingGates -ne $null }
}
```

---

## 6. Migration Checklist

- [ ] flowcontrol.apiserver.k8s.io/v1beta3 -> v1 completed (if any exists)
- [ ] autoscaling/v2beta2 -> autoscaling/v2 completed (if any exists)
- [ ] core/v1 Endpoints usage audited; clients migrated to EndpointSlices (if applicable)
- [ ] automountServiceAccountToken: true added to pods requiring implicit token
- [ ] Kube-proxy IPVS mode removed / switched to nftables/iptables
- [ ] Kubelet --pod-infra-container-image removed from node configuration
- [ ] Nodes confirmed running cgroup v2 (AKS node image confirms for 1.35+)
- [ ] Operators (cert-manager, Prometheus, Istio if present) updated to 1.35-compatible versions
- [ ] Helm charts audited for deprecated API references (pluto detect-all-in-cluster --target-versions k8s=v1.35 or manual PowerShell audit above)

---

## 7. References

- Kubernetes 1.35 Deprecation Guide: https://v1-35.docs.kubernetes.io/docs/reference/using-api/deprecation-guide
- Kubernetes 1.35 Release Notes: https://kubernetes.io/docs/setup/release/notes/
- AKS Kubernetes Version Support: https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions
- Pluto (deprecated API scanner): https://github.com/FairwindsOps/pluto
- kubectl-deprecations plugin: kubectl krew install deprecations (optional; alternatives above work without it)
