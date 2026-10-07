# Cross-Cutting & Correlation Queries

> KQL queries that correlate data across multiple tables and categories for comprehensive AKS troubleshooting.

## Timeline Correlation

### Full Cluster Timeline (Events + Logs + Metrics)
```kql
// Correlate events, logs, and metrics on a timeline
let Events = KubeEvents
| where TimeGenerated > ago(24h)
| where KubeEventType == "Warning"
| project TimeGenerated, Source = "Event", Detail = Reason, Entity = Name, Namespace;
let PodIssues = KubePodInventory
| where TimeGenerated > ago(24h)
| where PodStatus != "Running"
| project TimeGenerated, Source = "Pod", Detail = PodStatus, Entity = Name, Namespace;
let NodeIssues = KubeNodeInventory
| where TimeGenerated > ago(24h)
| where Status !contains "Ready"
| project TimeGenerated, Source = "Node", Detail = Status, Entity = Computer, Namespace = "";
let CPUErrors = AzureDiagnostics
| where TimeGenerated > ago(24h)
| where ResourceType == "MANAGEDCLUSTERS"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, Source = "ControlPlane", Detail = Category, Entity = "", Namespace = "";
union Events, PodIssues, NodeIssues, CPUErrors
| order by TimeGenerated desc
| take 100
```

### Incident Timeline (All Sources)
```kql
// Build a complete incident timeline
let PodEvents = KubeEvents
| where TimeGenerated > ago(24h)
| where KubeEventType == "Warning"
| project TimeGenerated, Category = "Event", Description = strcat(Reason, ": ", Message), Entity = strcat(Namespace, "/", Name);
let PodStatus = KubePodInventory
| where TimeGenerated > ago(24h)
| where PodStatus != "Running"
| project TimeGenerated, Category = "PodStatus", Description = strcat(PodStatus, " - ", ContainerStatusReason), Entity = strcat(Namespace, "/", Name);
let NodeStatus = KubeNodeInventory
| where TimeGenerated > ago(24h)
| where Status !contains "Ready"
| project TimeGenerated, Category = "NodeStatus", Description = Status, Entity = Computer;
let ControlPlane = AzureDiagnostics
| where TimeGenerated > ago(24h)
| where ResourceType == "MANAGEDCLUSTERS"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, Category = "ControlPlane", Description = Category, Entity = "";
let ContainerErrors = ContainerLogV2
| where TimeGenerated > ago(24h)
| where LogEntry contains "error" or LogEntry contains "Error"
| project TimeGenerated, Category = "ContainerLog", Description = LogEntry, Entity = strcat(Namespace, "/", PodName);
union PodEvents, PodStatus, NodeStatus, ControlPlane, ContainerErrors
| order by TimeGenerated desc
| take 200
```

## Multi-Table Joins

### Pod Status with Events and Logs
```kql
// Comprehensive pod troubleshooting view
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus != "Running"
| join kind=leftouter (
    KubeEvents
    | where TimeGenerated > ago(1h)
    | where KubeEventType == "Warning"
    | summarize Events = make_list(strcat(Reason, ": ", Message)) by Name, Namespace
) on Name, Namespace
| join kind=leftouter (
    ContainerLogV2
    | where TimeGenerated > ago(1h)
    | where LogEntry contains "error" or LogEntry contains "Error"
    | summarize RecentErrors = take_any(LogEntry) by PodName
) on $left.Name == $right.PodName
| project TimeGenerated, Namespace, Name, PodStatus, ContainerStatusReason, Events, RecentErrors
| order by TimeGenerated desc
```

### Node Status with Pods and Events
```kql
// Node health with running pods and events
KubeNodeInventory
| where TimeGenerated > ago(1h)
| summarize arg_max(TimeGenerated, *) by Computer
| join kind=leftouter (
    KubePodInventory
    | where TimeGenerated > ago(1h)
    | summarize PodCount = count(), RunningPods = countif(PodStatus == "Running"), FailedPods = countif(PodStatus == "Failed") by Computer
) on Computer
| join kind=leftouter (
    KubeEvents
    | where TimeGenerated > ago(1h)
    | where ObjectKind == "Node"
    | summarize NodeEvents = count() by Name
) on $left.Computer == $right.Name
| project TimeGenerated, Computer, Status, PodCount, RunningPods, FailedPods, NodeEvents
| order by Computer asc
```

### Control Plane Errors with Pod Impact
```kql
// Correlate control plane errors with pod failures
let CPUErrors = AzureDiagnostics
| where TimeGenerated > ago(1h)
| where ResourceType == "MANAGEDCLUSTERS"
| where log_s contains "error" or log_s contains "failed"
| summarize CPUErrorCount = count() by Category, bin(TimeGenerated, 5m);
let PodFailures = KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus != "Running"
| summarize PodFailureCount = count() by bin(TimeGenerated, 5m);
CPUErrors
| join kind=leftouter PodFailures on TimeGenerated
| project TimeGenerated, Category, CPUErrorCount, PodFailureCount
| order by TimeGenerated desc
```

### Container Logs with Pod and Node Info
```kql
// Container logs enriched with pod and node information
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error"
| join kind=inner (
    KubePodInventory
    | where TimeGenerated > ago(1h)
) on ContainerName
| join kind=leftouter (
    KubeNodeInventory
    | where TimeGenerated > ago(1h)
) on Computer
| project TimeGenerated, PodName, Namespace, ContainerName, LogEntry, PodStatus, Computer, Status
| order by TimeGenerated desc
| take 50
```

## Resource Correlation

### Resource Usage with Pod Status
```kql
// Correlate resource usage with pod status
KubePodInventory
| where TimeGenerated > ago(1h)
| join kind=inner (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SContainer"
    | where CounterName in ("cpuUsageNanoCores", "memoryWorkingSetBytes")
    | summarize AvgValue = avg(CounterValue) by CounterName, InstanceName
    | evaluate pivot(CounterName, sum(AvgValue))
) on $left.Name == $right.InstanceName
| extend CPUPercent = round(100.0 * cpuUsageNanoCores / 1000000000, 2)
| extend MemoryMB = round(memoryWorkingSetBytes / 1024 / 1024, 2)
| project TimeGenerated, Namespace, Name, PodStatus, CPUPercent, MemoryMB
| order by MemoryMB desc
```

### Node Resource Usage with Pod Count
```kql
// Node resource utilization with pod count
KubeNodeInventory
| where TimeGenerated > ago(1h)
| summarize arg_max(TimeGenerated, *) by Computer
| join kind=leftouter (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SNode"
    | where CounterName in ("cpuUsageNanoCores", "memoryRssBytes")
    | summarize AvgValue = avg(CounterValue) by CounterName, Computer
    | evaluate pivot(CounterName, sum(AvgValue))
) on Computer
| join kind=leftouter (
    KubePodInventory
    | where TimeGenerated > ago(1h)
    | summarize PodCount = count() by Computer
) on Computer
| extend CPUPercent = round(100.0 * cpuUsageNanoCores / 1000000000, 2)
| extend MemoryGB = round(memoryRssBytes / 1024 / 1024 / 1024, 2)
| project Computer, Status, CPUPercent, MemoryGB, PodCount
| order by CPUPercent desc
```

## Change Correlation

### Recent Changes with Impact
```kql
// Correlate recent changes with cluster health
let RecentChanges = AzureDiagnostics
| where Category == "kube-audit"
| where TimeGenerated > ago(1h)
| extend event = parse_json(log_s)
| where event.verb in ("create", "delete", "update", "patch")
| extend User = tostring(event.user.username)
| extend Resource = tostring(event.objectRef.resource)
| extend Name = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| project TimeGenerated, ChangeType = event.verb, User, Resource, Name, Namespace;
let CurrentHealth = KubePodInventory
| where TimeGenerated > ago(5m)
| where PodStatus != "Running"
| project TimeGenerated, Entity = Name, Namespace, HealthStatus = PodStatus;
RecentChanges
| join kind=leftouter CurrentHealth on Namespace
| project TimeGenerated, ChangeType, User, Resource, Name, Namespace, HealthStatus
| order by TimeGenerated desc
| take 100
```

### Deployment Changes with Pod Restarts
```kql
// Correlate deployment changes with pod restarts
let DeployChanges = AzureDiagnostics
| where Category == "kube-audit"
| where TimeGenerated > ago(24h)
| extend event = parse_json(log_s)
| where event.objectRef.resource == "deployments"
| where event.verb in ("create", "update", "patch")
| extend User = tostring(event.user.username)
| extend DeploymentName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| project TimeGenerated, ChangeType = event.verb, User, DeploymentName, Namespace;
let PodRestarts = KubePodInventory
| where TimeGenerated > ago(24h)
| where RestartCount > 0
| where ControllerKind == "Deployment"
| summarize TotalRestarts = sum(RestartCount) by ControllerName, Namespace;
DeployChanges
| join kind=leftouter PodRestarts on $left.DeploymentName == $right.ControllerName, Namespace
| project TimeGenerated, ChangeType, User, DeploymentName, Namespace, TotalRestarts
| order by TimeGenerated desc
```

## Capacity & Planning

### Cluster Capacity Overview
```kql
// Cluster capacity and utilization overview
let NodeCapacity = KubeNodeInventory
| where TimeGenerated > ago(1h)
| summarize arg_max(TimeGenerated, *) by Computer
| join kind=leftouter (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SNode"
    | where CounterName in ("cpuUsageNanoCores", "memoryRssBytes")
    | summarize AvgValue = avg(CounterValue) by CounterName, Computer
    | evaluate pivot(CounterName, sum(AvgValue))
) on Computer
| extend CPUPercent = round(100.0 * cpuUsageNanoCores / 1000000000, 2)
| extend MemoryGB = round(memoryRssBytes / 1024 / 1024 / 1024, 2)
| summarize TotalNodes = count(), AvgCPU = avg(CPUPercent), AvgMemoryGB = avg(MemoryGB) by ClusterName;
let PodCapacity = KubePodInventory
| where TimeGenerated > ago(1h)
| summarize TotalPods = count(), RunningPods = countif(PodStatus == "Running"), FailedPods = countif(PodStatus == "Failed") by ClusterName;
NodeCapacity
| join kind=leftouter PodCapacity on ClusterName
| project ClusterName, TotalNodes, AvgCPU, AvgMemoryGB, TotalPods, RunningPods, FailedPods
```

### Namespace Resource Usage
```kql
// Resource usage by namespace
KubePodInventory
| where TimeGenerated > ago(1h)
| join kind=inner (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SContainer"
    | where CounterName in ("cpuUsageNanoCores", "memoryWorkingSetBytes")
    | summarize AvgValue = avg(CounterValue) by CounterName, InstanceName
    | evaluate pivot(CounterName, sum(AvgValue))
) on $left.Name == $right.InstanceName
| extend CPUPercent = round(100.0 * cpuUsageNanoCores / 1000000000, 2)
| extend MemoryMB = round(memoryWorkingSetBytes / 1024 / 1024, 2)
| summarize PodCount = count(), AvgCPU = avg(CPUPercent), TotalMemoryMB = sum(MemoryMB) by Namespace
| order by TotalMemoryMB desc
```

### Node Pool Utilization
```kql
// Node pool utilization overview
KubeNodeInventory
| where TimeGenerated > ago(1h)
| extend NodePool = tostring(Tags["nodePool"])
| summarize arg_max(TimeGenerated, *) by Computer
| join kind=leftouter (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SNode"
    | where CounterName in ("cpuUsageNanoCores", "memoryRssBytes")
    | summarize AvgValue = avg(CounterValue) by CounterName, Computer
    | evaluate pivot(CounterName, sum(AvgValue))
) on Computer
| extend CPUPercent = round(100.0 * cpuUsageNanoCores / 1000000000, 2)
| extend MemoryGB = round(memoryRssBytes / 1024 / 1024 / 1024, 2)
| summarize TotalNodes = count(), AvgCPU = avg(CPUPercent), AvgMemoryGB = avg(MemoryGB) by NodePool
| order by AvgCPU desc
```

## Security Correlation

### Auth Failures with Pod Impact
```kql
// Correlate authentication failures with pod issues
let AuthFailures = AzureDiagnostics
| where Category in ("kube-audit-admin", "guard")
| where TimeGenerated > ago(1h)
| where log_s contains "401" or log_s contains "403" or log_s contains "unauthorized"
| summarize AuthFailureCount = count() by bin(TimeGenerated, 5m);
let PodIssues = KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus != "Running"
| summarize PodIssueCount = count() by bin(TimeGenerated, 5m);
AuthFailures
| join kind=leftouter PodIssues on TimeGenerated
| project TimeGenerated, AuthFailureCount, PodIssueCount
| order by TimeGenerated desc
```

### Secret Access with Pod Restarts
```kql
// Correlate secret access with pod restarts
let SecretAccess = AzureDiagnostics
| where Category == "kube-audit"
| where TimeGenerated > ago(24h)
| extend event = parse_json(log_s)
| where event.objectRef.resource == "secrets"
| extend User = tostring(event.user.username)
| extend SecretName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| project TimeGenerated, User, SecretName, Namespace;
let PodRestarts = KubePodInventory
| where TimeGenerated > ago(24h)
| where RestartCount > 0
| summarize TotalRestarts = sum(RestartCount) by Namespace;
SecretAccess
| join kind=leftouter PodRestarts on Namespace
| project TimeGenerated, User, SecretName, Namespace, TotalRestarts
| order by TimeGenerated desc
```

## Upgrade & Version Correlation

### Version Mismatch Detection
```kql
// Detect version mismatches between nodes
KubeNodeInventory
| where TimeGenerated > ago(1h)
| extend K8sVersion = tostring(Tags["kubernetesVersion"])
| extend NodePool = tostring(Tags["nodePool"])
| summarize NodeCount = count() by K8sVersion, NodePool
| order by NodePool asc, K8sVersion asc
```

### Nodes Running Older Versions
```kql
// Find nodes running older Kubernetes versions
KubeNodeInventory
| where TimeGenerated > ago(1h)
| extend K8sVersion = tostring(Tags["kubernetesVersion"])
| extend NodePool = tostring(Tags["nodePool"])
| summarize arg_max(TimeGenerated, *) by Computer
| extend ClusterVersion = tostring(Tags["clusterVersion"])
| where K8sVersion != ClusterVersion
| project Computer, NodePool, K8sVersion, ClusterVersion
| order by NodePool asc
```

### Upgrade-Related Events
```kql
// Find upgrade-related events
KubeEvents
| where TimeGenerated > ago(7d)
| where Reason contains "Upgrade" or Reason contains "upgrade" or Message contains "upgrade" or Message contains "Upgrade"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
| take 50
```

## Cost & Efficiency

### Idle Resource Detection
```kql
// Detect idle/underutilized resources
KubePodInventory
| where TimeGenerated > ago(1h)
| join kind=inner (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SContainer"
    | where CounterName == "cpuUsageNanoCores"
    | summarize AvgCPU = avg(CounterValue) by InstanceName
) on $left.Name == $right.InstanceName
| extend CPUPercent = round(100.0 * AvgCPU / 1000000000, 2)
| where CPUPercent < 5
| project TimeGenerated, Namespace, Name, CPUPercent
| order by CPUPercent asc
| take 20
```

### Over-Provisioned Pods
```kql
// Find over-provisioned pods (high requests, low usage)
KubePodInventory
| where TimeGenerated > ago(1h)
| join kind=inner (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SContainer"
    | where CounterName in ("cpuUsageNanoCores", "cpuLimitNanoCores")
    | summarize AvgValue = avg(CounterValue) by CounterName, InstanceName
    | evaluate pivot(CounterName, sum(AvgValue))
) on $left.Name == $right.InstanceName
| extend CPUUsagePercent = round(100.0 * cpuUsageNanoCores / cpuLimitNanoCores, 2)
| where CPUUsagePercent < 10
| project TimeGenerated, Namespace, Name, CPUUsagePercent
| order by CPUUsagePercent asc
| take 20
```

### Namespace Cost Efficiency
```kql
// Namespace cost efficiency (resource usage vs pod count)
KubePodInventory
| where TimeGenerated > ago(1h)
| join kind=inner (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SContainer"
    | where CounterName in ("cpuUsageNanoCores", "memoryWorkingSetBytes")
    | summarize AvgValue = avg(CounterValue) by CounterName, InstanceName
    | evaluate pivot(CounterName, sum(AvgValue))
) on $left.Name == $right.InstanceName
| extend CPUPercent = round(100.0 * cpuUsageNanoCores / 1000000000, 2)
| extend MemoryMB = round(memoryWorkingSetBytes / 1024 / 1024, 2)
| summarize PodCount = count(), AvgCPU = avg(CPUPercent), AvgMemoryMB = avg(MemoryMB) by Namespace
| extend EfficiencyScore = round(AvgCPU / PodCount, 2)
| order by EfficiencyScore asc
```
