# AKS Upgrade Plan — Technical — 1.34.x → 1.35.6

Location: /run/media/black/dbfa0647-b941-4878-ab09-c84ba0c6879c/Azure/AKS/Upgrade_1.34_to_1.35.6/
Related: Management Brief (AKS_Upgrade_1.34_to_1.35.6_Management.md), Backup Commands (Backup_Commands_PowerShell.md), Deprecated APIs (Deprecated_APIs_1.35.md)

---

## 1. Upgrade Sequence

1. P0 — Audit deprecated APIs (`Deprecated_APIs_1.35.md`)
2. P1 — Backup all resource types (`Backup_Commands_PowerShell.md` → 6 YAML files)
3. P2 — Inspect upgrade profile (`Upgrade_Stepwise_Commands.md` Phase P2)
4. P3 — Upgrade control plane (`Upgrade_Stepwise_Commands.md` Phase P3)
5. P4 — Upgrade system node pool (`Upgrade_Stepwise_Commands.md` Phase P4)
6. P5 — Upgrade user node pools sequentially (`Upgrade_Stepwise_Commands.md` Phase P5)
7. P6 — Post-upgrade validation (`Upgrade_Stepwise_Commands.md` Phase P6)
8. P7 — Management sign-off (`Upgrade_Stepwise_Commands.md` Phase P7)

---

## 2. Resource Backup Coverage

| Resource Type | YAML File | Command Source | Covers Namespace | Data Backup?
|---|---|---|---|---|
| Deployments | backup_deployments.yaml | `kubectl get deployments --all-namespaces -o yaml` | All namespaces | No (metadata only) |
| PodDisruptionBudgets | backup_pdb.yaml | `kubectl get pdb --all-namespaces -o yaml` | All namespaces | No |
| ReplicaSets | backup_replicaset.yaml | `kubectl get replicaset --all-namespaces -o yaml` | All namespaces | No |
| PersistentVolumes | backup_pv.yaml | `kubectl get pv -o yaml` | Cluster-scoped | No (metadata only) |
| PersistentVolumeClaims | backup_pvc.yaml | `kubectl get pvc --all-namespaces -o yaml` | All namespaces | No (metadata only) |
| Ingress | backup_ingress.yaml | `kubectl get ingress --all-namespaces -o yaml` | All namespaces | No |

Note: Data in PersistentVolumes requires storage-level backup (Azure Disk Snapshot, AKS backup add-on, or storage replication). YAML backups restore resource definitions only.

---

## 3. Upgrade Constraints

- **No version skip**: AKS requires upgrading one minor version at a time (1.34 → 1.35). Going directly to 1.36 is blocked.
- **Control plane first**: Upgrade control plane separately (`--control-plane-only` via `az aks upgrade`) to validate control plane stability before node pools.
- **Node pool sequence**: System node pool must be upgraded before user node pools (AKS manages system components on system pools).
- **Drain nodes**: AKS handles node draining automatically during node pool upgrade, but verify no pods are blocked by PDB constraints.
- **Maintenance window**: Schedule during low-traffic period; node pool upgrades can take 30–60 minutes per pool depending on node count and image pull time.

---

## 4. Deprecated API Migration (Before Upgrade)

Reference `Deprecated_APIs_1.35.md`. Critical items:

- Any `flowcontrol.apiserver.k8s.io/v1beta3` manifests → `v1`
- Any `autoscaling/v2beta2` HPA manifests → `autoscaling/v2`
- Any scripts reading `core/v1 Endpoints` → migrate to `EndpointSlices`
- Any pods missing `automountServiceAccountToken` that rely on implicit tokens → add `automountServiceAccountToken: true`
- Any custom node images / kubelet configs using `--pod-infra-container-image` → remove flag
- Confirm kube-proxy is not using `ipvs` mode
- Confirm nodes run cgroup v2

---

## 5. Post-Upgrade Validation Criteria

- [ ] Cluster reports Kubernetes version 1.35.6 (`kubectl version --short`)
- [ ] All nodes report 1.35.6 (`kubectl get nodes -o wide`)
- [ ] No pods in `Error`, `CrashLoopBackOff`, or `ImagePullBackOff` (`kubectl get pods --all-namespaces`)
- [ ] Deprecated API audit (`kubectl deprecations --k8s-version=1.35`) returns zero removed-API errors
- [ ] ServiceAccount token behavior verified for pods requiring implicit tokens
- [ ] Scheduling gates audited (no unexpected gates blocking pods)
- [ ] All 6 YAML backup files present and validated (`python -c yaml.safe_load_all`)
- [ ] Management brief (`AKS_Upgrade_1.34_to_1.35.6_Management.md`) updated with final status
