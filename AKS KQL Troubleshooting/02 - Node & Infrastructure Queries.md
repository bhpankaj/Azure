# Node & Infrastructure KQL Queries

> Queries for troubleshooting AKS node health, resource pressure, disk issues, and infrastructure problems.

## Node Health & Status

### Nodes Not in Ready State
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| where Status !contains "Ready" and Status !contains "VMEventScheduled"
| where isnotempty(Status)
| project TimeGenerated, ClusterName, Computer, Status
| order by TimeGenerated desc
```

### Node Conditions (MemoryPressure, DiskPressure, etc.)
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| where Status contains "MemoryPressure" or Status contains "DiskPressure" or Status contains "PIDPressure" or Status contains "NetworkUnavailable"
| project TimeGenerated, ClusterName, Computer, Status
| order by TimeGenerated desc
```

### Node Status Timeline
```kql
KubeNodeInventory
| where TimeGenerated > ago(24h)
| summarize StatusChanges = count() by Computer, Status, bin(TimeGenerated, 1h)
| order by TimeGenerated desc
```

### Node Readiness Flapping
```kql
KubeNodeInventory
| where TimeGenerated > ago(24h)
| summarize StatusChanges = countif(Status !contains "Ready") by Computer, bin(TimeGenerated, 1h)
| where StatusChanges > 3
| order by StatusChanges desc
```

### All Nodes with Current Status
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| summarize arg_max(TimeGenerated, *) by Computer
| project TimeGenerated, ClusterName, Computer, Status, NodePool = tostring(Tags["nodePool"])
| order by Computer asc
```

## Node Resource Utilization

### CPU Utilization per Node
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName == "cpuUsageNanoCores"
| summarize AvgCPU = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| extend CPUPercent = round(100.0 * AvgCPU / 1000000000, 2)
| order by TimeGenerated desc
```

### CPU Utilization Timechart
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName == "cpuUsageNanoCores"
| summarize AvgCPU = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| extend CPUPercent = round(100.0 * AvgCPU / 1000000000, 2)
| render timechart
```

### Memory Usage per Node
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName == "memoryRssBytes"
| summarize AvgMemory = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| extend MemoryGB = round(AvgMemory / 1024 / 1024 / 1024, 2)
| order by TimeGenerated desc
```

### Memory Usage Timechart
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName == "memoryRssBytes"
| summarize AvgMemory = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| extend MemoryGB = round(AvgMemory / 1024 / 1024 / 1024, 2)
| render timechart
```

### Node Memory Pressure Detection
```kql
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Name == "memoryRssBytes" and ObjectName == "K8SNode"
| extend UsedGB = Val / (1024*1024*1024)
| summarize AvgMemGB = avg(UsedGB) by NodeName = Tags["hostName"], bin(TimeGenerated, 5m)
| where AvgMemGB > 12
| order by AvgMemGB desc
```

### Node Disk Usage
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName in ("diskUsedBytes", "diskTotalBytes")
| summarize AvgValue = avg(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| evaluate pivot(CounterName, sum(AvgValue))
| extend UsedGB = round(diskUsedBytes / 1024 / 1024 / 1024, 2)
| extend TotalGB = round(diskTotalBytes / 1024 / 1024 / 1024, 2)
| extend UsagePercent = round(100.0 * diskUsedBytes / diskTotalBytes, 2)
| project Computer, UsedGB, TotalGB, UsagePercent
| order by UsagePercent desc
```

### Node Network Usage
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName in ("networkRxBytes", "networkTxBytes")
| summarize AvgValue = avg(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| evaluate pivot(CounterName, sum(AvgValue))
| extend RxMB = round(networkRxBytes / 1024 / 1024, 2)
| extend TxMB = round(networkTxBytes / 1024 / 1024, 2)
| project Computer, RxMB, TxMB
| order by TimeGenerated desc
```

## Node Inventory & Discovery

### All Nodes in Cluster
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| distinct ClusterName, Computer, Status
| order by Computer asc
```

### Node Count by Status
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| summarize NodeCount = count() by Status, ClusterName
| order by NodeCount desc
```

### Node Pool Distribution
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| extend NodePool = tostring(Tags["nodePool"])
| summarize NodeCount = count() by NodePool, ClusterName
| order by NodeCount desc
```

### Nodes by Kubernetes Version
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| extend K8sVersion = tostring(Tags["kubernetesVersion"])
| summarize NodeCount = count() by K8sVersion, ClusterName
| order by K8sVersion desc
```

## Node Events & Conditions

### Warning Events on Nodes
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where KubeEventType == "Warning"
| where ObjectKind == "Node"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
| take 50
```

### Node NotReady Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "NodeNotReady" or Reason == "NodeReady"
| project TimeGenerated, Name, Reason, Message
| order by TimeGenerated desc
```

### Node Pressure Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason in ("NodeHasInsufficientMemory", "NodeHasDiskPressure", "NodeHasInsufficientPID")
| project TimeGenerated, Name, Reason, Message
| order by TimeGenerated desc
```

### All Node-Related Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where ObjectKind == "Node"
| project TimeGenerated, Name, Namespace, Reason, Message, KubeEventType
| order by TimeGenerated desc
| take 100
```

## Kubelet Issues

### Kubelet Pod Startup Latency
```kql
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Name == "kubelet_pod_start_duration_seconds"
| extend LatencyMs = Val * 1000
| summarize AvgLatency = avg(LatencyMs) by NodeName = Tags["hostName"], bin(TimeGenerated, 5m)
| where AvgLatency > 1000
| order by AvgLatency desc
```

### Kubelet Errors in Container Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where PodName contains "kubelet" or ContainerName contains "kubelet"
| where LogEntry contains "error" or LogEntry contains "failed"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

## VMSS/VMAS Issues

### VMSS Instance Health
```kql
KubeNodeInventory
| where TimeGenerated > ago(1h)
| extend VMSS = tostring(Tags["vmss"])
| where isnotempty(VMSS)
| summarize NodeCount = count() by VMSS, Status
| order by VMSS asc
```

### Nodes with VMEventScheduled (Maintenance)
```kql
KubeNodeInventory
| where TimeGenerated > ago(24h)
| where Status contains "VMEventScheduled"
| project TimeGenerated, Computer, Status
| order by TimeGenerated desc
```
