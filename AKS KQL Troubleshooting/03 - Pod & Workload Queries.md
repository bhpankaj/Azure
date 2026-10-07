# Pod & Workload KQL Queries

> Queries for troubleshooting pod failures: CrashLoopBackOff, OOMKilled, ImagePullBackOff, restarts, and scheduling issues.

## Pod Status & Health

### Pods Not in Running State
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus != "Running"
| project TimeGenerated, Namespace, Name, PodStatus, ContainerStatus, ContainerRestartCount
| order by TimeGenerated desc
```

### Pods in Pending State
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus == "Pending"
| project TimeGenerated, Namespace, Name, PodStatus, ContainerStatus
| order by TimeGenerated desc
```

### Pods in Failed State
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus == "Failed"
| project TimeGenerated, Namespace, Name, PodStatus, ContainerStatusReason
| order by TimeGenerated desc
```

### Pod Status Distribution
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| summarize PodCount = count() by PodStatus, Namespace
| order by PodCount desc
```

### Pod Count by Namespace
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| summarize PodCount = count() by Namespace
| order by PodCount desc
```

## CrashLoopBackOff

### Pods in CrashLoopBackOff (Last 1h)
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus == "Failed" or ContainerStatusReason == "CrashLoopBackOff"
| project TimeGenerated, Namespace, Name, PodStatus, ContainerStatusReason
| order by TimeGenerated desc
```

### Pods in CrashLoopBackOff (Last 24h)
```kql
KubePodInventory
| where TimeGenerated > ago(1d)
| where ContainerStatusReason == "CrashLoopBackOff"
| project Name, Namespace, ContainerStatusReason
| order by TimeGenerated desc
```

### CrashLoopBackOff by Namespace
```kql
KubePodInventory
| where TimeGenerated > ago(24h)
| where ContainerStatusReason == "CrashLoopBackOff"
| summarize CrashCount = count() by Namespace, Name
| order by CrashCount desc
```

### CrashLoopBackOff with Restart Count
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where ContainerStatusReason == "CrashLoopBackOff"
| project TimeGenerated, Namespace, Name, ContainerRestartCount, PodStatus
| order by ContainerRestartCount desc
```

## OOMKilled

### OOMKilled Containers (Last 24h)
```kql
KubePodInventory
| where TimeGenerated > ago(24h)
| where ContainerLastStatus contains "OOMKilled"
| project TimeGenerated, Namespace, Name, ContainerName
| summarize OOMCount = count() by Namespace, Name
| order by OOMCount desc
```

### OOMKilled with Details
```kql
KubePodInventory
| where TimeGenerated > ago(24h)
| where PodStatus != "Running"
| extend ContainerLastStatusJSON = parse_json(ContainerLastStatus)
| extend FinishedAt = todatetime(ContainerLastStatusJSON.finishedAt)
| where ContainerLastStatusJSON.reason == "OOMKilled"
| distinct PodUid, ControllerName, ContainerLastStatus, FinishedAt
| order by FinishedAt asc
```

### OOMKilled Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "OOMKilling" or Reason == "OOMKilled"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

### Memory Usage Before OOMKill
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SContainer"
| where CounterName == "memoryWorkingSetBytes"
| where InstanceName contains "<pod-name>"
| summarize max(CounterValue) by bin(TimeGenerated, 1m)
| extend MemoryMB = round(max_CounterValue / 1024 / 1024, 2)
| render timechart
```

## ImagePullBackOff

### Pods in ImagePullBackOff (Last 4h)
```kql
KubePodInventory
| where TimeGenerated > ago(4h)
| where ContainerStatusReason == "ImagePullBackOff"
| project Name, Namespace, ContainerStatusReason
| order by TimeGenerated desc
```

### ImagePullBackOff Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "Failed" and Message contains "image" and Message contains "pull"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

### ErrImagePull Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "ErrImagePull"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

### ACR Login Failures (401)
```kql
ContainerRegistryLoginEvents
| where TimeGenerated > ago(1d)
| where ResultDescription contains "401"
| sort by TimeGenerated asc
```

## Pod Restarts

### Pods with High Restart Count
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodRestartCount > 0
| summarize MaxRestarts = max(PodRestartCount), arg_max(TimeGenerated, *) by Name, Namespace
| where MaxRestarts > 3
| project Name, Namespace, MaxRestarts, PodStatus, ContainerStatus
| order by MaxRestarts desc
```

### Pods Restarted in Last Hour
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where RestartCount > 5
| join kind=leftouter (
    KubeEvents
    | where TimeGenerated > ago(1h)
    | where Reason in ("Failed", "FailedScheduling", "Unhealthy")
    | summarize EventCount = count() by Name
) on Name
| project TimeGenerated, Name, Namespace, RestartCount, Computer, EventCount
| order by RestartCount desc
```

### Restart Count by Namespace
```kql
KubePodInventory
| where TimeGenerated > ago(24h)
| where RestartCount > 0
| summarize TotalRestarts = sum(RestartCount) by Namespace
| order by TotalRestarts desc
```

## Scheduling Issues

### FailedScheduling Events
```kql
KubeEvents
| where TimeGenerated > ago(1h)
| where Reason == "FailedScheduling"
| project TimeGenerated, Name, Namespace, Message
| order by TimeGenerated desc
```

### FailedScheduling by Reason
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "FailedScheduling"
| summarize Count = count() by Namespace, Message
| order by Count desc
```

### Unschedulable Pods
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus == "Pending"
| join kind=leftouter (
    KubeEvents
    | where TimeGenerated > ago(1h)
    | where Reason == "FailedScheduling"
    | project Name, Namespace, Message
) on Name
| project TimeGenerated, Namespace, Name, PodStatus, Message
| order by TimeGenerated desc
```

## Pod Events

### All Warning Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where KubeEventType == "Warning"
| summarize Count = count() by Namespace, Reason
| order by Count desc
```

### All Error Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where KubeEventType == "Error"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

### Pod Failure Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason in ("Failed", "FailedScheduling", "Unhealthy", "FailedCreatePodSandBox", "FailedMount")
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
| take 100
```

### Events by Reason
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| summarize Count = count() by Reason, KubeEventType
| order by Count desc
```

## Container Inventory

### All Containers by Image
```kql
ContainerInventory
| where TimeGenerated > ago(1h)
| distinct Image, ImageTag, Running
| order by Image asc
```

### Containers by State
```kql
ContainerInventory
| where TimeGenerated > ago(1h)
| summarize Count = count() by ContainerState
| order by Count desc
```

### Terminated Containers
```kql
ContainerInventory
| where ContainerState == "Terminated"
| project Computer, Name, Image, ImageTag, ContainerState, CreatedTime, StartedTime, FinishedTime
| order by FinishedTime desc
```

### Container Lifecycle Info
```kql
ContainerInventory
| project Computer, Name, Image, ImageTag, ContainerState, CreatedTime, StartedTime, FinishedTime
| order by CreatedTime desc
```

## Deployment/Controller Health

### Deployment Replica Mismatch
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where ControllerKind == "Deployment"
| summarize DesiredReplicas = countif(PodStatus == "Running"), TotalPods = count() by ControllerName, Namespace
| extend RunningReplicas = DesiredReplicas
| where RunningReplicas < TotalPods
| project Namespace, ControllerName, RunningReplicas, TotalPods
| order by TotalPods desc
```

### StatefulSet Replica Mismatch
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where ControllerKind == "StatefulSet"
| summarize RunningPods = countif(PodStatus == "Running"), TotalPods = count() by ControllerName, Namespace
| where RunningPods < TotalPods
| project Namespace, ControllerName, RunningPods, TotalPods
```

### DaemonSet Pod Status
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where ControllerKind == "DaemonSet"
| summarize RunningPods = countif(PodStatus == "Running"), TotalPods = count() by ControllerName, Namespace
| project Namespace, ControllerName, RunningPods, TotalPods
| order by Namespace asc
```

### Job Completion Status
```kql
KubePodInventory
| where TimeGenerated > ago(24h)
| where ControllerKind == "Job"
| summarize Succeeded = countif(PodStatus == "Succeeded"), Failed = countif(PodStatus == "Failed"), Running = countif(PodStatus == "Running") by ControllerName, Namespace
| order by Failed desc
```

## Container Resource Usage

### Top Memory-Consuming Containers
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| join kind=inner (
    Perf
    | where TimeGenerated > ago(1h)
    | where ObjectName == "K8SContainer"
    | where CounterName == "memoryWorkingSetBytes"
    | summarize AvgMemory = avg(CounterValue) by Name, Computer, Namespace
) on Computer
| extend MemoryMB = round(AvgMemory / 1024 / 1024, 2)
| where MemoryMB > 500
| order by MemoryMB desc
| take 20
```

### Top CPU-Consuming Containers
```kql
Perf
| where TimeGenerated > ago(30m)
| where ObjectName == "K8SContainer"
| where CounterName == "cpuUsageNanoCores"
| summarize AvgCPU = avg(CounterValue) by InstanceName, bin(TimeGenerated, 5m)
| extend CPUPercent = round(100.0 * AvgCPU / 1000000000, 2)
| where CPUPercent > 80
| order by CPUPercent desc
```

### CPU Throttling by Container
```kql
Perf
| where TimeGenerated > ago(2h)
| where ObjectName == "K8SContainer"
| where CounterName == "cpuThrottledTime"
| summarize ThrottledTime = sum(CounterValue) by bin(TimeGenerated, 5m), Namespace = extract(@"namespace_name:([^,]+)", 1, InstanceName)
| where Namespace != ""
| order by TimeGenerated desc
```

### Container CPU Usage as Percentage of Limit
```kql
Perf
| where TimeGenerated > ago(30m)
| where ObjectName == "K8SContainer"
| where CounterName == "cpuLimitNanoCores" or CounterName == "cpuUsageNanoCores"
| summarize AvgValue = avg(CounterValue) by CounterName, InstanceName
| evaluate pivot(CounterName, sum(AvgValue))
| extend CPUPercent = round(100.0 * cpuUsageNanoCores / cpuLimitNanoCores, 1)
| where CPUPercent > 80
| order by CPUPercent desc
```
