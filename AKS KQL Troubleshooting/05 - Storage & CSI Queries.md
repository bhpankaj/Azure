# Storage & CSI KQL Queries

> Queries for troubleshooting AKS storage issues: CSI drivers, PV/PVC problems, disk attach failures, and volume snapshot issues.

## CSI Driver Logs

### All CSI Azure Disk Controller Logs
```kql
AzureDiagnostics
| where Category == "csi-azuredisk-controller"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### CSI Azure Disk Controller Errors
```kql
AzureDiagnostics
| where Category == "csi-azuredisk-controller"
| where log_s contains "error" or log_s contains "failed" or log_s contains "Error"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### CSI Azure File Controller Logs
```kql
AzureDiagnostics
| where Category == "csi-azurefile-controller"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### CSI Azure File Controller Errors
```kql
AzureDiagnostics
| where Category == "csi-azurefile-controller"
| where log_s contains "error" or log_s contains "failed" or log_s contains "Error"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### CSI Snapshot Controller Logs
```kql
AzureDiagnostics
| where Category == "csi-snapshot-controller"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### CSI Snapshot Controller Errors
```kql
AzureDiagnostics
| where Category == "csi-snapshot-controller"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

## PV/PVC Issues

### FailedMount Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "FailedMount"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
| take 50
```

### FailedAttachVolume Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "FailedAttachVolume"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
| take 50
```

### Volume Mount Errors by Pod
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason in ("FailedMount", "FailedAttachVolume", "VolumeMountFailed")
| summarize Count = count() by Namespace, Name, Reason
| order by Count desc
```

### Volume Attachment Failures
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Message contains "attach" or Message contains "Attach"
| where KubeEventType == "Warning"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
| take 50
```

## Disk Provisioning Issues

### Disk Provisioning Errors in Cloud Controller
```kql
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where log_s contains "disk" or log_s contains "Disk"
| where log_s contains "error" or log_s contains "failed" or log_s contains "Failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

### Disk Attach/Detach Operations
```kql
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where log_s contains "attach" or log_s contains "detach" or log_s contains "Attach" or log_s contains "Detach"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

### Disk Operation Failures by Disk Name
```kql
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where log_s contains "disk" or log_s contains "Disk"
| where log_s contains "error" or log_s contains "failed"
| extend diskName = extract("\"diskName\":\"([^\"]+)\"", 1, log_s)
| summarize FailureCount = count() by diskName, bin(TimeGenerated, 1h)
| order by FailureCount desc
```

## Volume Snapshot Issues

### Snapshot Creation Failures
```kql
AzureDiagnostics
| where Category == "csi-snapshot-controller"
| where log_s contains "snapshot" or log_s contains "Snapshot"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

### Snapshot Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason contains "Snapshot" or Message contains "snapshot"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

## Storage Performance

### Disk I/O Performance
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName in ("diskReadBytes", "diskWriteBytes", "diskReadOps", "diskWriteOps")
| summarize AvgValue = avg(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| evaluate pivot(CounterName, sum(AvgValue))
| order by TimeGenerated desc
```

### Disk Latency
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName contains "diskLatency" or CounterName contains "DiskLatency"
| summarize AvgLatency = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvgLatency > 100
| order by AvgLatency desc
```

### Disk Queue Depth
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName contains "diskQueue" or CounterName contains "DiskQueue"
| summarize AvgQueue = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvgQueue > 10
| order by AvgQueue desc
```

## PVC Status from Events

### PVC Binding Failures
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason == "FailedBinding" or Reason == "ProvisioningFailed"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

### PVC Provisioning Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason in ("Provisioning", "ProvisioningFailed", "ProvisioningSucceeded")
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

### Storage Class Issues
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Message contains "storageclass" or Message contains "StorageClass" or Message contains "storage class"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

## Cross-Cutting Storage Queries

### All Storage-Related Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Reason in ("FailedMount", "FailedAttachVolume", "FailedDetachVolume", "VolumeMountFailed", "FailedBinding", "ProvisioningFailed", "ProvisioningSucceeded")
| project TimeGenerated, Name, Namespace, Reason, Message, KubeEventType
| order by TimeGenerated desc
| take 100
```

### All CSI Driver Errors (All Categories)
```kql
AzureDiagnostics
| where Category startswith "csi-"
| where TimeGenerated >= ago(1h)
| where log_s contains "error" or log_s contains "failed" or log_s contains "Error" or log_s contains "Failed"
| summarize ErrorCount = count() by Category, bin(TimeGenerated, 5m)
| order by ErrorCount desc
```

### CSI Driver Error Timeline
```kql
AzureDiagnostics
| where Category startswith "csi-"
| where TimeGenerated >= ago(24h)
| where log_s contains "error" or log_s contains "failed"
| summarize Count = count() by Category, bin(TimeGenerated, 1h)
| render timechart
```
