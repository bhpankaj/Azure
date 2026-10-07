# Container Log KQL Queries

> Queries for troubleshooting application and container logs: error searching, log analysis, and pattern detection in ContainerLogV2.

## Basic Log Queries

### All Container Logs (Last 1h)
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 100
```

### Container Logs by Pod
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where PodName contains "<pod-name>"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
```

### Container Logs by Namespace
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where Namespace == "<namespace>"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
```

### Container Logs by Container Name
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where ContainerName == "<container-name>"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
```

## Error Searching

### Logs Containing "error"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error" or LogEntry contains "ERROR"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs Containing "exception"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "Exception" or LogEntry contains "exception"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs Containing "fatal"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "fatal" or LogEntry contains "Fatal" or LogEntry contains "FATAL"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs Containing "panic"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "panic" or LogEntry contains "Panic"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs Containing "OOM" or "OutOfMemory"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "OOM" or LogEntry contains "OutOfMemory" or LogEntry contains "out of memory"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs Containing "timeout" or "timed out"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "timeout" or LogEntry contains "timed out" or LogEntry contains "Timeout"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs Containing "refused" or "connection refused"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "refused" or LogEntry contains "Refused"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs Containing "unreachable" or "no route to host"
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "unreachable" or LogEntry contains "no route to host" or LogEntry contains "Unreachable"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

## Error Aggregation

### Error Count by Pod
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error" or LogEntry contains "ERROR"
| summarize ErrorCount = count() by PodName, Namespace
| order by ErrorCount desc
```

### Error Count by Container
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error" or LogEntry contains "ERROR"
| summarize ErrorCount = count() by ContainerName, PodName, Namespace
| order by ErrorCount desc
```

### Error Count by Namespace
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error" or LogEntry contains "ERROR"
| summarize ErrorCount = count() by Namespace
| order by ErrorCount desc
```

### Error Timeline
```kql
ContainerLogV2
| where TimeGenerated > ago(24h)
| where LogEntry contains "error" or LogEntry contains "Error" or LogEntry contains "ERROR"
| summarize ErrorCount = count() by bin(TimeGenerated, 1h), PodName
| render timechart
```

### Error Count by Hour
```kql
ContainerLogV2
| where TimeGenerated > ago(24h)
| where LogEntry contains "error" or LogEntry contains "Error" or LogEntry contains "ERROR"
| summarize ErrorCount = count() by bin(TimeGenerated, 1h)
| render timechart
```

## JSON Log Parsing

### Parse JSON Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| extend log_entry = parse_json(LogEntry)
| project TimeGenerated, PodName, ContainerName, log_entry
| take 50
```

### Filter by JSON Field
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| extend log_entry = parse_json(LogEntry)
| where log_entry.level == "error" or log_entry.level == "ERROR" or log_entry.level == "fatal"
| project TimeGenerated, PodName, ContainerName, log_entry
| order by TimeGenerated desc
| take 50
```

### Filter by JSON Host Field
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| extend log_entry = parse_json(LogEntry)
| where log_entry.host contains "register"
| where log_entry.environment == "production"
| project TimeGenerated, PodName, ContainerName, log_entry
| order by TimeGenerated desc
```

### Extract JSON Fields
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| extend log_entry = parse_json(LogEntry)
| extend level = tostring(log_entry.level)
| extend message = tostring(log_entry.message)
| extend logger = tostring(log_entry.logger)
| project TimeGenerated, PodName, ContainerName, level, message, logger
| order by TimeGenerated desc
| take 50
```

### JSON Logs by Level
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| extend log_entry = parse_json(LogEntry)
| extend level = tostring(log_entry.level)
| summarize Count = count() by level, bin(TimeGenerated, 1h)
| render timechart
```

## Log Pattern Analysis

### Top Error Messages
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error"
| extend ErrorMessage = extract(@"Error[:\s]+(.+?)(?:\n|$)", 1, LogEntry)
| summarize Count = count() by ErrorMessage
| order by Count desc
| take 20
```

### Logs with Stack Traces
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "at " and LogEntry contains "(" and LogEntry contains ")"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 30
```

### Logs with HTTP Status Codes
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "HTTP" or LogEntry contains "status" or LogEntry contains "Status"
| extend StatusCode = extract(@"status[:\s]+(\d{3})", 1, LogEntry, typeof(int))
| where StatusCode >= 400
| project TimeGenerated, PodName, ContainerName, StatusCode, LogEntry
| order by TimeGenerated desc
| take 50
```

### Logs with SQL/Database Errors
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "SQL" or LogEntry contains "database" or LogEntry contains "Database" or LogEntry contains "connection"
| where LogEntry contains "error" or LogEntry contains "failed" or LogEntry contains "refused"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

## Cross-Table Log Correlation

### Container Logs Joined with Pod Inventory
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error"
| join kind=inner (
    KubePodInventory
    | where TimeGenerated > ago(1h)
) on ContainerName
| project TimeGenerated, LogEntry, PodName, Namespace, PodStatus, ContainerRestartCount
| order by TimeGenerated desc
| take 50
```

### Container Logs Joined with Events
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error"
| join kind=leftouter (
    KubeEvents
    | where TimeGenerated > ago(1h)
    | where KubeEventType == "Warning"
    | project Name, Namespace, Reason, Message
) on PodName
| project TimeGenerated, PodName, Namespace, LogEntry, Reason, Message
| order by TimeGenerated desc
| take 50
```

### Container Logs Joined with Node Inventory
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "error" or LogEntry contains "Error"
| join kind=inner (
    KubeNodeInventory
    | where TimeGenerated > ago(1h)
) on Computer
| project TimeGenerated, PodName, ContainerName, LogEntry, Computer, Status
| order by TimeGenerated desc
| take 50
```

## Log Volume Analysis

### Log Volume by Pod
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| summarize LogCount = count() by PodName, Namespace
| order by LogCount desc
| take 20
```

### Log Volume by Container
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| summarize LogCount = count() by ContainerName, PodName
| order by LogCount desc
| take 20
```

### Log Volume Over Time
```kql
ContainerLogV2
| where TimeGenerated > ago(24h)
| summarize LogCount = count() by bin(TimeGenerated, 1h)
| render timechart
```

### Log Volume by Namespace
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| summarize LogCount = count() by Namespace
| order by LogCount desc
```

### Top Noisy Pods (High Log Volume)
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| summarize LogCount = count() by PodName, Namespace
| where LogCount > 1000
| order by LogCount desc
| take 20
```

## Specific Error Patterns

### Crash-Related Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "crash" or LogEntry contains "Crash" or LogEntry contains "fatal" or LogEntry contains "panic"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Memory-Related Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "memory" or LogEntry contains "Memory" or LogEntry contains "OOM" or LogEntry contains "heap"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Network-Related Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "connection" or LogEntry contains "Connection" or LogEntry contains "network" or LogEntry contains "Network" or LogEntry contains "timeout" or LogEntry contains "refused"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Disk/Storage-Related Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "disk" or LogEntry contains "Disk" or LogEntry contains "storage" or LogEntry contains "Storage" or LogEntry contains "no space" or LogEntry contains "quota"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Certificate/TLS-Related Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogEntry contains "certificate" or LogEntry contains "Certificate" or LogEntry contains "TLS" or LogEntry contains "SSL" or LogEntry contains "cert"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```
