# Alerting & Proactive Monitoring

> KQL queries for setting up proactive alerts and monitoring AKS cluster health. These queries can be used as the basis for Azure Monitor log alerts.

## Node Health Alerts

### Alert: Node Not Ready
```kql
// Alert when any node is not in Ready state
KubeNodeInventory
| where TimeGenerated > ago(5m)
| summarize arg_max(TimeGenerated, Status) by Computer
| where Status !contains "Ready" and Status !contains "VMEventScheduled"
| project Computer, Status, TimeGenerated
```

### Alert: Node Memory Pressure
```kql
// Alert when node has MemoryPressure
KubeNodeInventory
| where TimeGenerated > ago(5m)
| where Status contains "MemoryPressure"
| project Computer, Status, TimeGenerated
```

### Alert: Node Disk Pressure
```kql
// Alert when node has DiskPressure
KubeNodeInventory
| where TimeGenerated > ago(5m)
| where Status contains "DiskPressure"
| project Computer, Status, TimeGenerated
```

### Alert: Node CPU Usage High (>90%)
```kql
// Alert when node CPU usage exceeds 90%
Perf
| where TimeGenerated > ago(5m)
| where ObjectName == "K8SNode"
| where CounterName == "cpuUsageNanoCores"
| summarize AvgCPU = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| extend CPUPercent = round(100.0 * AvgCPU / 1000000000, 2)
| where CPUPercent > 90
| project Computer, CPUPercent, TimeGenerated
```

### Alert: Node Memory Usage High (>90%)
```kql
// Alert when node memory usage exceeds 90%
Perf
| where TimeGenerated > ago(5m)
| where ObjectName == "K8SNode"
| where CounterName == "memoryRssBytes"
| summarize AvgMemory = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| extend MemoryGB = round(AvgMemory / 1024 / 1024 / 1024, 2)
| where MemoryGB > 12
| project Computer, MemoryGB, TimeGenerated
```

### Alert: Node Disk Usage High (>85%)
```kql
// Alert when node disk usage exceeds 85%
Perf
| where TimeGenerated > ago(5m)
| where ObjectName == "K8SNode"
| where CounterName in ("diskUsedBytes", "diskTotalBytes")
| summarize AvgValue = avg(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| evaluate pivot(CounterName, sum(AvgValue))
| extend UsagePercent = round(100.0 * diskUsedBytes / diskTotalBytes, 2)
| where UsagePercent > 85
| project Computer, UsagePercent, TimeGenerated
```

## Pod Health Alerts

### Alert: Pod CrashLoopBackOff
```kql
// Alert when any pod enters CrashLoopBackOff
KubePodInventory
| where TimeGenerated > ago(5m)
| where ContainerStatusReason == "CrashLoopBackOff"
| project Name, Namespace, ContainerStatusReason, TimeGenerated
```

### Alert: Pod OOMKilled
```kql
// Alert when any pod is OOMKilled
KubePodInventory
| where TimeGenerated > ago(5m)
| where ContainerLastStatus contains "OOMKilled"
| project Name, Namespace, ContainerLastStatus, TimeGenerated
```

### Alert: Pod Restart Count High
```kql
// Alert when pod restart count exceeds threshold
KubePodInventory
| where TimeGenerated > ago(1h)
| where RestartCount > 5
| project Name, Namespace, RestartCount, TimeGenerated
```

### Alert: Pod Not Running
```kql
// Alert when any pod is not in Running state
KubePodInventory
| where TimeGenerated > ago(5m)
| where PodStatus != "Running"
| project Name, Namespace, PodStatus, TimeGenerated
```

### Alert: Pod Pending for Too Long
```kql
// Alert when pod has been Pending for more than 5 minutes
KubePodInventory
| where TimeGenerated > ago(5m)
| where PodStatus == "Pending"
| project Name, Namespace, PodStatus, TimeGenerated
```

### Alert: Deployment Replica Mismatch
```kql
// Alert when deployment has fewer running replicas than desired
KubePodInventory
| where TimeGenerated > ago(5m)
| where ControllerKind == "Deployment"
| summarize RunningReplicas = countif(PodStatus == "Running"), TotalPods = count() by ControllerName, Namespace
| where RunningReplicas < TotalPods
| project Namespace, ControllerName, RunningReplicas, TotalPods
```

### Alert: StatefulSet Replica Mismatch
```kql
// Alert when statefulset has fewer running replicas than desired
KubePodInventory
| where TimeGenerated > ago(5m)
| where ControllerKind == "StatefulSet"
| summarize RunningReplicas = countif(PodStatus == "Running"), TotalPods = count() by ControllerName, Namespace
| where RunningReplicas < TotalPods
| project Namespace, ControllerName, RunningReplicas, TotalPods
```

## Control Plane Alerts

### Alert: API Server 5xx Errors
```kql
// Alert when API server returns 5xx errors
AzureDiagnostics
| where Category == "kube-apiserver"
| where TimeGenerated > ago(5m)
| where log_s contains "resp=5" or log_s contains "\"code\":5"
| summarize ErrorCount = count() by bin(TimeGenerated, 5m)
| where ErrorCount > 0
```

### Alert: API Server High Latency
```kql
// Alert when API server latency exceeds threshold
AzureDiagnostics
| where Category == "kube-apiserver"
| where TimeGenerated > ago(5m)
| where log_s contains "latency" or log_s contains "duration"
| extend latency_ms = extract("\"latency_ms\":(\\d+)", 1, log_s, typeof(long))
| where latency_ms > 1000
| summarize HighLatencyCount = count() by bin(TimeGenerated, 5m)
| where HighLatencyCount > 0
```

### Alert: Scheduling Failures
```kql
// Alert when scheduling failures occur
AzureDiagnostics
| where Category == "kube-scheduler"
| where TimeGenerated > ago(5m)
| where log_s contains "FailedScheduling" or log_s contains "unable to schedule"
| summarize FailureCount = count() by bin(TimeGenerated, 5m)
| where FailureCount > 0
```

### Alert: Authentication Failures
```kql
// Alert when authentication failures occur
AzureDiagnostics
| where Category == "kube-audit-admin"
| where TimeGenerated > ago(5m)
| where log_s contains "\"code\":403" or log_s contains "\"code\":401"
| summarize AuthFailureCount = count() by bin(TimeGenerated, 5m)
| where AuthFailureCount > 0
```

### Alert: guard Errors
```kql
// Alert when guard (Azure AD auth) errors occur
AzureDiagnostics
| where Category == "guard"
| where TimeGenerated > ago(5m)
| where log_s contains "error" or log_s contains "failed"
| summarize ErrorCount = count() by bin(TimeGenerated, 5m)
| where ErrorCount > 0
```

## Networking Alerts

### Alert: DNS Resolution Failures
```kql
// Alert when DNS resolution failures occur
ContainerNetworkLogs
| where TimeGenerated > ago(5m)
| extend L4 = parse_json(Layer4), L7 = parse_json(Layer7)
| where L4.UDP.destination_port == 53
| where L7.dns.rcode != "NOERROR"
| summarize DnsErrorCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by bin(TimeGenerated, 5m)
| where DnsErrorCount > 0
```

### Alert: High Drop Rate
```kql
// Alert when network drop rate is high
ContainerNetworkLogs
| where TimeGenerated > ago(5m)
| where Verdict == "DROPPED"
| summarize DropCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by bin(TimeGenerated, 5m)
| where DropCount > 100
```

### Alert: HTTP 5xx Responses
```kql
// Alert when HTTP 5xx responses occur
ContainerNetworkLogs
| where TimeGenerated > ago(5m)
| extend L7 = parse_json(Layer7)
| where isnotempty(L7.HTTP)
| where L7.HTTP.status_code >= 500
| summarize ErrorCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by bin(TimeGenerated, 5m)
| where ErrorCount > 0
```

## Storage Alerts

### Alert: CSI Driver Errors
```kql
// Alert when CSI driver errors occur
AzureDiagnostics
| where Category startswith "csi-"
| where TimeGenerated > ago(5m)
| where log_s contains "error" or log_s contains "failed"
| summarize ErrorCount = count() by Category, bin(TimeGenerated, 5m)
| where ErrorCount > 0
```

### Alert: Volume Mount Failures
```kql
// Alert when volume mount failures occur
KubeEvents
| where TimeGenerated > ago(5m)
| where Reason == "FailedMount"
| summarize FailureCount = count() by bin(TimeGenerated, 5m)
| where FailureCount > 0
```

### Alert: Disk Provisioning Failures
```kql
// Alert when disk provisioning failures occur
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where TimeGenerated > ago(5m)
| where log_s contains "disk" or log_s contains "Disk"
| where log_s contains "error" or log_s contains "failed"
| summarize FailureCount = count() by bin(TimeGenerated, 5m)
| where FailureCount > 0
```

## Autoscaler Alerts

### Alert: Autoscaler Scale-Up Failures
```kql
// Alert when autoscaler fails to scale up
AzureDiagnostics
| where Category == "cluster-autoscaler"
| where TimeGenerated > ago(5m)
| where log_s contains "ScaleUp" or log_s contains "scale up"
| where log_s contains "error" or log_s contains "failed" or log_s contains "cannot"
| summarize FailureCount = count() by bin(TimeGenerated, 5m)
| where FailureCount > 0
```

### Alert: Autoscaler Not Scaling Down
```kql
// Alert when autoscaler is not scaling down
AzureDiagnostics
| where Category == "cluster-autoscaler"
| where TimeGenerated > ago(5m)
| where log_s contains "ScaleDown" or log_s contains "cannot be removed"
| summarize Count = count() by bin(TimeGenerated, 5m)
| where Count > 0
```

## Log Volume Alerts

### Alert: High Error Log Volume
```kql
// Alert when error log volume is high
ContainerLogV2
| where TimeGenerated > ago(5m)
| where LogEntry contains "error" or LogEntry contains "Error" or LogEntry contains "ERROR"
| summarize ErrorCount = count() by bin(TimeGenerated, 5m)
| where ErrorCount > 100
```

### Alert: Log Volume Spike
```kql
// Alert when log volume spikes
ContainerLogV2
| where TimeGenerated > ago(5m)
| summarize LogCount = count() by bin(TimeGenerated, 5m)
| where LogCount > 10000
```

## Composite Health Queries

### Cluster Health Summary
```kql
// Overall cluster health summary
let NodeHealth = KubeNodeInventory
| where TimeGenerated > ago(5m)
| summarize NotReadyNodes = countif(Status !contains "Ready") by ClusterName;
let PodHealth = KubePodInventory
| where TimeGenerated > ago(5m)
| summarize FailedPods = countif(PodStatus == "Failed"), PendingPods = countif(PodStatus == "Pending"), CrashLoopingPods = countif(ContainerStatusReason == "CrashLoopBackOff") by ClusterName;
let EventHealth = KubeEvents
| where TimeGenerated > ago(5m)
| where KubeEventType == "Warning"
| summarize WarningEvents = count() by ClusterName;
NodeHealth
| join kind=leftouter PodHealth on ClusterName
| join kind=leftouter EventHealth on ClusterName
| project ClusterName, NotReadyNodes, FailedPods, PendingPods, CrashLoopingPods, WarningEvents
```

### Namespace Health Summary
```kql
// Health summary by namespace
let PodHealth = KubePodInventory
| where TimeGenerated > ago(5m)
| summarize TotalPods = count(), RunningPods = countif(PodStatus == "Running"), FailedPods = countif(PodStatus == "Failed"), PendingPods = countif(PodStatus == "Pending") by Namespace;
let EventHealth = KubeEvents
| where TimeGenerated > ago(5m)
| where KubeEventType == "Warning"
| summarize WarningEvents = count() by Namespace;
PodHealth
| join kind=leftouter EventHealth on Namespace
| project Namespace, TotalPods, RunningPods, FailedPods, PendingPods, WarningEvents
| order by FailedPods desc
```

### Node Pool Health Summary
```kql
// Health summary by node pool
KubeNodeInventory
| where TimeGenerated > ago(5m)
| extend NodePool = tostring(Tags["nodePool"])
| summarize TotalNodes = count(), ReadyNodes = countif(Status contains "Ready"), NotReadyNodes = countif(Status !contains "Ready") by NodePool
| extend HealthPercent = round(100.0 * ReadyNodes / TotalNodes, 2)
| order by HealthPercent asc
```
