# AKS KQL Troubleshooting Index

> Comprehensive Kusto Query Language (KQL) reference for troubleshooting Azure Kubernetes Service (AKS) cluster platform issues.

## Prerequisites

Before running any queries, ensure:
1. **Diagnostic settings** are enabled on the AKS cluster (Portal > AKS > Monitoring > Diagnostic settings)
2. **Container Insights** is enabled for the cluster
3. Logs are routed to a **Log Analytics workspace**
4. You have **Reader** or **Contributor** access to the workspace

### Enable All Control Plane Logs (Azure CLI)
```bash
az monitor diagnostic-settings create \
  --name aks-diagnostics \
  --resource $AKS_RESOURCE_ID \
  --workspace $WORKSPACE_RESOURCE_ID \
  --logs '[
    {"category": "kube-apiserver", "enabled": true},
    {"category": "kube-audit", "enabled": true},
    {"category": "kube-audit-admin", "enabled": true},
    {"category": "kube-controller-manager", "enabled": true},
    {"category": "kube-scheduler", "enabled": true},
    {"category": "cluster-autoscaler", "enabled": true},
    {"category": "cloud-controller-manager", "enabled": true},
    {"category": "guard", "enabled": true},
    {"category": "csi-azuredisk-controller", "enabled": true},
    {"category": "csi-azurefile-controller", "enabled": true},
    {"category": "csi-snapshot-controller", "enabled": true}
  ]' \
  --export-to-resource-specific true
```

## Log Categories Reference

| Category | What It Captures |
|----------|-----------------|
| `kube-apiserver` | API server operational activity (not request-level; use kube-audit for that) |
| `kube-audit` | All API requests — full audit trail of every action in the cluster |
| `kube-audit-admin` | Admin-level audit events (RBAC changes, cluster modifications) |
| `kube-controller-manager` | Controller reconciliation loops, resource creation/deletion |
| `kube-scheduler` | Scheduling decisions, pod placement failures |
| `cluster-autoscaler` | Auto-scaling decisions, scale-up/scale-down events |
| `cloud-controller-manager` | Azure resource provisioning (load balancers, disks, routes) |
| `guard` | Azure AD authentication/authorization webhook logs |
| `csi-azuredisk-controller` | Azure Disk CSI driver operations |
| `csi-azurefile-controller` | Azure File CSI driver operations |
| `csi-snapshot-controller` | Volume snapshot operations |

## Key Log Analytics Tables

| Table | Data Source |
|-------|------------|
| `AzureDiagnostics` | All resource logs (Azure diagnostics mode) |
| `AKSControlPlane` | Control plane logs (resource-specific mode) |
| `KubePodInventory` | Pod inventory and status |
| `KubeNodeInventory` | Node inventory and status |
| `KubeEvents` | Kubernetes events |
| `ContainerLogV2` | Container stdout/stderr logs |
| `ContainerInventory` | Container inventory |
| `ContainerImageInventory` | Image inventory |
| `Perf` | Performance counters (CPU, memory, disk, network) |
| `InsightsMetrics` | Container Insights metrics |
| `ContainerNetworkLogs` | Network flow logs (ACNS/Cilium) |
| `ContainerRegistryLoginEvents` | ACR login events |

## Notes Map

- [[01 - Control Plane Queries]] — kube-apiserver, kube-audit, kube-scheduler, kube-controller-manager
- [[02 - Node & Infrastructure Queries]] — Node health, resource pressure, disk issues
- [[03 - Pod & Workload Queries]] — CrashLoopBackOff, OOMKilled, ImagePullBackOff, restarts
- [[04 - Networking & DNS Queries]] — ContainerNetworkLogs, DNS failures, ingress, policies
- [[05 - Storage & CSI Queries]] — CSI drivers, PV/PVC issues, disk attach problems
- [[06 - Auth & RBAC Queries]] — guard, Entra ID, authentication failures, RBAC changes
- [[07 - Container Log Queries]] — Application logs, error searching, log analysis
- [[08 - Alerting & Proactive Monitoring]] — Alert rules, proactive detection queries
- [[09 - Cross-Cutting & Correlation Queries]] — Multi-table joins, timeline correlation

## Quick Diagnostic Flow

```
1. Check cluster health → KubeNodeInventory (any NotReady?)
2. Check pod status → KubePodInventory (any failed/crashing?)
3. Check events → KubeEvents (warnings/errors?)
4. Check control plane → AzureDiagnostics by Category
5. Check logs → ContainerLogV2 for application errors
6. Check networking → ContainerNetworkLogs for connectivity
7. Check auth → guard + kube-audit-admin for access issues
```
