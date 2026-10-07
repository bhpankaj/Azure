# VMSS KQL Queries

> KQL queries for troubleshooting Azure Virtual Machine Scale Sets (VMSS): instance health, autoscaling, rolling upgrades, and scale set-specific issues.

## VMSS Instance Discovery

### All VMSS Instances (from Heartbeat)
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| where ResourceType == "virtualmachinescaleset"
| summarize LastHeartbeat = max(TimeGenerated) by Computer, _ResourceId, ResourceGroup = extract(@"resourceGroups/([^/]+)/", 1, _ResourceId)
| order by Computer asc
```

### VMSS Instance Count
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| where ResourceType == "virtualmachinescaleset"
| summarize InstanceCount = dcount(Computer) by ResourceGroup = extract(@"resourceGroups/([^/]+)/", 1, _ResourceId), VMSSName = extract(@"virtualMachineScaleSets/([^/]+)", 1, _ResourceId)
| order by InstanceCount desc
```

### VMSS Instances by Resource Group
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| where ResourceType == "virtualmachinescaleset"
| summarize InstanceCount = dcount(Computer) by ResourceGroup = extract(@"resourceGroups/([^/]+)/", 1, _ResourceId)
| order by InstanceCount desc
```

### VMSS Instance List
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| where ResourceType == "virtualmachinescaleset"
| distinct Computer, _ResourceId, OSType
| order by Computer asc
```

## VMSS Instance Health

### VMSS Instances Not Reporting Heartbeat
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize LastHeartbeat = max(TimeGenerated) by Computer, _ResourceId
| where LastHeartbeat < ago(10m)
| project Computer, LastHeartbeat, _ResourceId
| order by LastHeartbeat asc
```

### VMSS Instances with Agent Issues
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| where ResourceType == "virtualmachinescaleset"
| summarize LastHeartbeat = max(TimeGenerated), AgentVersion = take_any(Version) by Computer, _ResourceId
| where LastHeartbeat < ago(5m)
| project Computer, LastHeartbeat, AgentVersion, _ResourceId
| order by LastHeartbeat asc
```

### VMSS Instance Heartbeat Timeline
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize HeartbeatCount = count() by bin(TimeGenerated, 5m), Computer
| render timechart
```

### VMSS Instance Availability
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize HeartbeatCount = count() by bin(TimeGenerated, 1h), Computer
| extend Available = iff(HeartbeatCount > 0, true, false)
| order by TimeGenerated desc
```

## VMSS Performance (Per Instance)

### CPU Usage by VMSS Instance
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue), MaxCPU = max(CounterValue) by Computer, bin(TimeGenerated, 5m)
| order by AvgCPU desc
```

### CPU Usage Timechart by Instance
```kql
Perf
| where TimeGenerated > ago(6h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
| render timechart
```

### Memory Usage by VMSS Instance
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue), MaxMemory = max(CounterValue) by Computer, bin(TimeGenerated, 5m)
| order by AvgMemory desc
```

### Disk Usage by VMSS Instance
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "LogicalDisk"
| where CounterName == "% Free Space"
| where InstanceName == "_Total"
| summarize AvgFree = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvgFree < 10
| order by AvgFree asc
```

### Network Usage by VMSS Instance
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName == "Bytes Total/sec"
| summarize AvgBytes = avg(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 5m)
| extend AvgMbps = round(AvgBytes * 8 / 1000000, 2)
| order by AvgMbps desc
```

### Top CPU-Consuming VMSS Instances
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by Computer
| order by AvgCPU desc
| take 20
```

### Top Memory-Consuming VMSS Instances
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by Computer
| order by AvgMemory desc
| take 20
```

## VMSS Autoscaling

### VMSS Instance Count Over Time
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize InstanceCount = dcount(Computer) by bin(TimeGenerated, 5m), VMSSName = extract(@"virtualMachineScaleSets/([^/]+)", 1, _ResourceId)
| render timechart
```

### VMSS Scale Events (Instance Count Changes)
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize InstanceCount = dcount(Computer) by bin(TimeGenerated, 5m), VMSSName = extract(@"virtualMachineScaleSets/([^/]+)", 1, _ResourceId)
| extend PrevInstanceCount = prev(InstanceCount)
| where InstanceCount != PrevInstanceCount
| project TimeGenerated, VMSSName, InstanceCount, PrevInstanceCount, Delta = InstanceCount - PrevInstanceCount
| order by TimeGenerated desc
```

### VMSS Instances Added/Removed
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize InstanceCount = dcount(Computer) by bin(TimeGenerated, 5m), Computer
| extend PrevInstanceCount = prev(InstanceCount)
| where InstanceCount != PrevInstanceCount
| project TimeGenerated, Computer, InstanceCount, PrevInstanceCount, Delta = InstanceCount - PrevInstanceCount
| order by TimeGenerated desc
```

## VMSS Rolling Upgrades

### VMSS Upgrade-Related Events
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VMSS" or OperationName contains "VirtualMachineScaleSet"
| where OperationName contains "upgrade" or OperationName contains "Upgrade" or OperationName contains "update" or OperationName contains "Update"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
```

### VMSS Instance Health During Upgrade
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize LastHeartbeat = max(TimeGenerated) by Computer, _ResourceId
| where LastHeartbeat < ago(10m)
| project Computer, LastHeartbeat, _ResourceId
| order by LastHeartbeat asc
```

### VMSS Instance Reimage Events
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VMSS" or OperationName contains "VirtualMachineScaleSet"
| where OperationName contains "reimage" or OperationName contains "Reimage" or OperationName contains "redeploy" or OperationName contains "Redeploy"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
```

## VMSS Instance Events

### VMSS Instance Errors (Windows)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Error"
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, EventLog, EventID, Source, Message
| order by TimeGenerated desc
| take 50
```

### VMSS Instance Errors (Linux)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, Facility, SeverityLevel, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### VMSS Instance Warnings (Windows)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Warning"
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, EventLog, EventID, Source, Message
| order by TimeGenerated desc
| take 50
```

### VMSS Instance Warnings (Linux)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("warning", "err", "crit", "alert", "emerg")
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, Facility, SeverityLevel, SyslogMessage
| order by TimeGenerated desc
| take 50
```

## VMSS Load Balancer Health

### VMSS Instances Behind Load Balancer
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| where ResourceType == "virtualmachinescaleset"
| summarize LastHeartbeat = max(TimeGenerated) by Computer, _ResourceId
| where LastHeartbeat > ago(5m)
| project Computer, LastHeartbeat, _ResourceId
| order by Computer asc
```

### VMSS Instances Not Behind Load Balancer
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| where ResourceType == "virtualmachinescaleset"
| summarize LastHeartbeat = max(TimeGenerated) by Computer, _ResourceId
| where LastHeartbeat < ago(10m)
| project Computer, LastHeartbeat, _ResourceId
| order by LastHeartbeat asc
```

## VMSS Capacity & Utilization

### VMSS Capacity Overview
```kql
let InstanceCount = Heartbeat
| where TimeGenerated > ago(1h)
| where ResourceType == "virtualmachinescaleset"
| summarize InstanceCount = dcount(Computer) by VMSSName = extract(@"virtualMachineScaleSets/([^/]+)", 1, _ResourceId);
let AvgCPU = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by Computer;
let AvgMemory = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by Computer;
InstanceCount
| join kind=leftouter AvgCPU on $left.Computer == $right.Computer
| join kind=leftouter AvgMemory on $left.Computer == $right.Computer
| project VMSSName, InstanceCount, AvgCPU, AvgMemory
| order by InstanceCount desc
```

### VMSS Instance Utilization Summary
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue), MaxCPU = max(CounterValue), MinCPU = min(CounterValue) by Computer
| order by AvgCPU desc
```

### VMSS Memory Utilization Summary
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue), MaxMemory = max(CounterValue), MinMemory = min(CounterValue) by Computer
| order by AvgMemory desc
```

## VMSS Maintenance & Operations

### VMSS Maintenance Events
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VMSS" or OperationName contains "VirtualMachineScaleSet"
| where OperationName contains "maintenance" or OperationName contains "Maintenance" or OperationName contains "patch" or OperationName contains "Patch"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
```

### VMSS Instance Restarts
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VMSS" or OperationName contains "VirtualMachineScaleSet"
| where OperationName contains "restart" or OperationName contains "Restart" or OperationName contains "reboot" or OperationName contains "Reboot"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
```

### VMSS Instance Deallocations
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VMSS" or OperationName contains "VirtualMachineScaleSet"
| where OperationName contains "deallocate" or OperationName contains "Deallocate" or OperationName contains "stop" or OperationName contains "Stop"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
```

### VMSS Instance Allocations
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VMSS" or OperationName contains "VirtualMachineScaleSet"
| where OperationName contains "start" or OperationName contains "Start" or OperationName contains "allocate" or OperationName contains "Allocate"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
```

## VMSS Networking

### VMSS Instance Network Connections
```kql
VMConnection
| where TimeGenerated > ago(1h)
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, SourceIP, DestinationIP, DestinationPort, Protocol, State
| order by TimeGenerated desc
| take 100
```

### VMSS Instance Network Errors
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName in ("Packets Received Errors", "Packets Outbound Errors")
| where CounterValue > 0
| where Computer contains "vmss" or Computer contains "VMSS"
| summarize ErrorCount = sum(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| order by ErrorCount desc
```

## VMSS Security

### VMSS Instance Failed Logins (Windows)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID == 4625
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
| take 50
```

### VMSS Instance Failed Logins (Linux)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "Failed password" or SyslogMessage contains "authentication failure"
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### VMSS Instance Firewall Blocks (Linux)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "iptables" or SyslogMessage contains "nftables" or SyslogMessage contains "firewalld"
| where SyslogMessage contains "DROP" or SyslogMessage contains "REJECT" or SyslogMessage contains "block"
| where Computer contains "vmss" or Computer contains "VMSS"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```
