# AKS Cluster Upgrade: 1.34.x → 1.35.6 — Management Brief

Created: 2026-10-28
Source: /run/media/black/dbfa0647-b941-4878-ab09-c84ba0c6879c/Azure/AKS
Target Cluster: AKS (managed Kubernetes)
Upgrade Path: Kubernetes 1.34.x → 1.35.6 (AKS supported version)
Environment: Windows PowerShell + Azure CLI (azcli)

---

## 1. Executive Summary

| Field | Value |
|---|---|
| **Current Version** | Kubernetes 1.34.x (AKS managed) |
| **Target Version** | Kubernetes 1.35.6 |
| **Upgrade Type** | In-place AKS cluster upgrade (control plane + node pools) |
| **Methodology** | PowerShell (Az.Aks module) + kubectl (Windows) |
| **Backup Strategy** | Separate YAML exports per resource type: Deployments, PodDisruptionBudgets, ReplicaSets, PersistentVolumes, PersistentVolumeClaims, Ingress |
| **Deprecated APIs Audited** | flowcontrol.apiserver.k8s.io/v1beta3 (removed 1.32), autoscaling/v2beta2, Endpoints (deprecated in 1.35), ServiceAccount token auto-mount behavior changed |
| **Rollback Plan** | Restore from exported YAML backups; etcd snapshot via az aks backup (AKS built-in) |
| **Risk Level** | MEDIUM — one minor version jump; no version skip; deprecated APIs handled |

---

## 2. Business Justification

- **Security**: Kubernetes 1.35.6 includes security patches not available in 1.34.x.
- **Feature Access**: 1.35 introduces stricter PodDisruptionBudget behavior, scheduling readiness gates, workload identity improvements, and Cilium datapath options.
- **Compliance**: Running deprecated Kubernetes versions violates organizational policy; 1.34.x approaches end-of-support window.
- **Operational Continuity**: All workloads backed up as discrete YAML files before any mutation; rollback time < 15 minutes.

---

## 3. Deprecated API Impact for 1.35.6

See: `Deprecated_APIs_1.35.md` (same folder) for full details.

Key items verified before upgrade:

| Deprecated / Changed API               | Status in 1.35.6                                   | Migration Action Required                              |
| -------------------------------------- | -------------------------------------------------- | ------------------------------------------------------ |
| `flowcontrol.apiserver.k8s.io/v1beta3` | **REMOVED** (1.32)                                 | Migrate to `v1`                                        |
| `autoscaling/v2beta2`                  | **REMOVED** (1.26/1.29)                            | Migrate to `autoscaling/v2`                            |
| `Endpoints` (core/v1)                  | **Deprecated** (1.35) — returns warnings           | Migrate clients to `EndpointSlices`                    |
| ServiceAccount token auto-mount        | **Behavior changed** (1.35)                        | Explicit `automountServiceAccountToken: true` required |
| `kube-proxy` IPVS mode                 | **Deprecated** (1.35) — removal in 1.36            | Confirm `nftables` or `iptables` mode                  |
| Kubelet `--pod-infra-container-image`  | **Flag removed** (1.35)                            | Remove from custom AMI/kubelet config                  |
| cgroup v1 support                      | **Deprecated** (1.35) — kubelet refuses by default | Confirm nodes use cgroup v2                            |

---

## 4. Pre-Upgrade Checklist (Management-Visible)

- [ ] Deprecated API audit completed (`kubectl deprecations --k8s-version=1.35`)
- [ ] All Deployments backed up (`backup_deployments.yaml`)
- [ ] All PodDisruptionBudgets backed up (`backup_pdb.yaml`)
- [ ] All ReplicaSets backed up (`backup_replicaset.yaml`)
- [ ] All PersistentVolumes backed up (`backup_pv.yaml`)
- [ ] All PersistentVolumeClaims backed up (`backup_pvc.yaml`)
- [ ] All Ingress resources backed up (`backup_ingress.yaml`)
- [ ] AKS upgrade profile inspected (`Get-AzAksUpgradeProfile`)
- [ ] Node pool versions verified (system and user pools must be upgraded in sequence)
- [ ] Cluster autoscaler, operators (cert-manager, Prometheus, Istio if present) updated to 1.35-compatible versions
- [ ] Maintenance window scheduled; stakeholders notified

---

## 5. Upgrade Timeline (Stepwise)

| Phase | Duration | Action | Owner |
|---|---|---|---|
| P0 — Audit | 30 min | Run deprecated-API checks; export manifests; inspect upgrade profile | DevOps / Platform |
| P1 — Backup | 30 min | Execute `Backup_Commands_PowerShell.md`; verify YAML output per resource | DevOps / Platform |
| P2 — Upgrade Control Plane | 20 min | `az aks upgrade --kubernetes-version 1.35.6 --control-plane-only` or `Start-AzAksClusterUpgrade` equivalent | DevOps |
| P3 — Upgrade System Node Pool | 30–60 min | Upgrade system node pool(s) to 1.35.6 | DevOps |
| P4 — Upgrade User Node Pools | 30–60 min per pool | Upgrade user pools sequentially; drain nodes before upgrade | DevOps |
| P5 — Post-Upgrade Validation | 30 min | Verify pods running; check deprecated API warnings; run health checks | QA / DevOps |
| P6 — Management Sign-Off | 15 min | Confirm all services healthy; document final state | Management / DevOps |

---

## 6. Rollback Plan

1. **Soft rollback**: Apply backed-up YAML files (`kubectl apply -f backup_*.yaml`) to restore previous workload configurations.
2. **Cluster rollback**: AKS does not support downgrading Kubernetes versions in-place. If the upgrade fails severely, restore the previous AKS snapshot (if AKS backup add-on enabled) or recreate node pools at previous image version using `New-AzAksNodePool`.
3. **Data rollback**: PersistentVolume backups (snapshots/volume backups) restored via storage-level recovery; not covered by YAML export (metadata only).

---

## 7. Documents in This Folder

| File | Purpose |
|---|---|
| `Upgrade_1.34_to_1.35.6_Management.md` | This file — management brief |
| `AKS_Upgrade_1.34_to_1.35.6_Plan.md` | Technical stepwise upgrade plan |
| `Backup_Commands_PowerShell.md` | All PowerShell backup/export commands |
| `Deprecated_APIs_1.35.md` | Full deprecated API reference |
| `Upgrade_Stepwise_Commands.md` | Executable command sequence (azcli + kubectl) |
| `backup_*.yaml` (6 files) | Actual exported YAML backups per resource type (generated by commands in `Backup_Commands_PowerShell.md`) |

---

## 8. Commands Used (PowerShell + azcli)

```powershell
# Authentication
Connect-AzAccount
# or
az login

# Get cluster info
Get-AzAksCluster -ResourceGroupName "<RG>" -Name "<Cluster>"
# or
az aks show --resource-group <RG> --name <Cluster>

# Get upgrade profile (critical)
Get-AzAksUpgradeProfile -ResourceGroupName "<RG>" -Name "<Cluster>"

# Upgrade control plane only (safe first step)
# PowerShell equivalent handled via az aks upgrade in practice:
az aks upgrade --resource-group <RG> --name <Cluster> --kubernetes-version 1.35.6 --control-plane-only --yes
```

---

## 9. Contacts / Escalation

- Primary: Platform / DevOps Engineer (PowerShell + azcli ownership)
- Escalation: Cloud Architecture Lead (deprecated API risk assessment)
- Stakeholders: Product / Engineering Management (timeline approval)
