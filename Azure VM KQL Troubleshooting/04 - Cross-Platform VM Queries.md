# Cross-Platform VM KQL Queries

> KQL queries that work across both Windows and Linux VMs: heartbeat, agent health, common performance counters, network, and security.

## Heartbeat & Availability

### All VMs Reporting Heartbeat
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType, _ResourceId
| order by LastHeartbeat desc
```

### VMs Not Reporting Heartbeat (Last 5 min)
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType, _ResourceId
| where LastHeartbeat < ago(5m)
| project Computer, LastHeartbeat, OSType, _ResourceId
| order by LastHeartbeat asc
```

### VMs Not Reporting Heartbeat (Last 10 min)
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType, _ResourceId
| where LastHeartbeat < ago(10m)
| project Computer, LastHeartbeat, OSType, _ResourceId
| order by LastHeartbeat asc
```

### VMs Not Reporting Heartbeat (Last 30 min)
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType, _ResourceId
| where LastHeartbeat < ago(30m)
| project Computer, LastHeartbeat, OSType, _ResourceId
| order by LastHeartbeat asc
```

### Heartbeat Count by VM (Last 24h)
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| summarize HeartbeatCount = count() by Computer, OSType
| order by HeartbeatCount asc
```

### Heartbeat Timeline by VM
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| summarize HeartbeatCount = count() by bin(TimeGenerated, 1h), Computer
| render timechart
```

### VMs by OS Type
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType
| summarize VMCount = count() by OSType
| order by VMCount desc
```

### VMs by Resource Group
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, ResourceGroup = extract(@"resourceGroups/([^/]+)/", 1, _ResourceId)
| summarize VMCount = count() by ResourceGroup
| order by VMCount desc
```

### VMs by Agent Version
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, Version, OSType
| summarize VMCount = count() by Version, OSType
| order by Version desc
```

### VMs by Location
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, Location = tostring(_ResourceId)
| summarize VMCount = count() by Location
| order by VMCount desc
```

## Agent Health

### Agent Version Distribution
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, Version, OSType
| summarize VMCount = count() by Version, OSType
| order by Version desc
```

### VMs with Outdated Agent
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, Version, OSType
| where Version < "1.0.0.0"
| project Computer, Version, OSType, LastHeartbeat
| order by Version asc
```

### VMs with Agent Not Reporting
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, Version, OSType
| where LastHeartbeat < ago(1h)
| project Computer, Version, OSType, LastHeartbeat
| order by LastHeartbeat asc
```

### Agent Health Summary
```kql
Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated), AgentVersion = take_any(Version), OSType = take_any(OSType) by Computer
| extend AgentStatus = iff(LastHeartbeat > ago(5m), "Healthy", iff(LastHeartbeat > ago(30m), "Warning", "Critical"))
| summarize VMCount = count() by AgentStatus, OSType
| order by AgentStatus asc
```

## Common Performance Counters

### CPU Usage by VM (All VMs)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue), MaxCPU = max(CounterValue) by Computer, bin(TimeGenerated, 5m)
| order by AvgCPU desc
```

### CPU Usage Timechart (All VMs)
```kql
Perf
| where TimeGenerated > ago(6h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
| render timechart
```

### Memory Usage by VM (All VMs)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue), MaxMemory = max(CounterValue) by Computer, bin(TimeGenerated, 5m)
| order by AvgMemory desc
```

### Memory Usage Timechart (All VMs)
```kql
Perf
| where TimeGenerated > ago(6h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
| render timechart
```

### Disk Space by VM (All VMs)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "LogicalDisk"
| where CounterName == "% Free Space"
| where InstanceName == "_Total"
| summarize AvgFree = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvgFree < 20
| order by AvgFree asc
```

### Disk Queue Length by VM (All VMs)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "PhysicalDisk"
| where CounterName == "Avg. Disk Queue Length"
| where InstanceName == "_Total"
| summarize AvgQueue = avg(CounterValue), MaxQueue = max(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvgQueue > 2
| order by AvgQueue desc
```

### Network Usage by VM (All VMs)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName == "Bytes Total/sec"
| summarize AvgBytes = avg(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 5m)
| extend AvgMbps = round(AvgBytes * 8 / 1000000, 2)
| order by AvgMbps desc
```

### Network Errors by VM (All VMs)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName in ("Packets Received Errors", "Packets Outbound Errors")
| where CounterValue > 0
| summarize ErrorCount = sum(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| order by ErrorCount desc
```

### Top 10 VMs by CPU Usage
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by Computer
| order by AvgCPU desc
| take 10
```

### Top 10 VMs by Memory Usage
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by Computer
| order by AvgMemory desc
| take 10
```

### Top 10 VMs by Disk Usage
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "LogicalDisk"
| where CounterName == "% Free Space"
| where InstanceName == "_Total"
| summarize AvgFree = avg(CounterValue) by Computer
| order by AvgFree asc
| take 10
```

### Top 10 VMs by Network Usage
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName == "Bytes Total/sec"
| summarize AvgBytes = avg(CounterValue) by Computer
| extend AvgMbps = round(AvgBytes * 8 / 1000000, 2)
| order by AvgMbps desc
| take 10
```

## VM Insights Metrics

### CPU Utilization (InsightsMetrics)
```kql
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Origin == "vm.azm.ms" and Namespace == "Processor" and Name == "UtilizationPercentage"
| extend cpu = tostring(todynamic(Tags)["vm.azm.ms/totalCpus"])
| summarize CPU_Percentage = avg(Val) by Computer, cpu, _ResourceId
| project Computer, Total_vCPUs = cpu, CPU_Percentage
| order by CPU_Percentage desc
```

### Memory Utilization (InsightsMetrics)
```kql
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Origin == "vm.azm.ms" and Namespace == "Memory" and Name == "AvailableMB"
| extend TotalMemory = tostring(todynamic(Tags)["vm.azm.ms/memorySizeMB"])
| extend UsedMemory = todouble(TotalMemory) - Val
| extend MemoryPercent = round(100.0 * UsedMemory / todouble(TotalMemory), 2)
| summarize AvgMemoryPercent = avg(MemoryPercent) by Computer, bin(TimeGenerated, 5m)
| order by AvgMemoryPercent desc
```

### Disk IOPS (InsightsMetrics)
```kql
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Origin == "vm.azm.ms" and Namespace == "LogicalDisk" and Name in ("ReadIOPS", "WriteIOPS")
| summarize AvgIOPS = avg(Val) by Computer, Name, bin(TimeGenerated, 5m)
| order by AvgIOPS desc
```

### Disk Throughput (InsightsMetrics)
```kql
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Origin == "vm.azm.ms" and Namespace == "LogicalDisk" and Name in ("ReadBytesPerSecond", "WriteBytesPerSecond")
| summarize AvgThroughput = avg(Val) by Computer, Name, bin(TimeGenerated, 5m)
| extend ThroughputMBps = round(AvgThroughput / 1024 / 1024, 2)
| order by ThroughputMBps desc
```

### Network Throughput (InsightsMetrics)
```kql
InsightsMetrics
| where TimeGenerated > ago(1h)
| where Origin == "vm.azm.ms" and Namespace == "Network" and Name in ("ReadBytesPerSecond", "WriteBytesPerSecond")
| summarize AvgThroughput = avg(Val) by Computer, Name, bin(TimeGenerated, 5m)
| extend ThroughputMbps = round(AvgThroughput * 8 / 1000000, 2)
| order by ThroughputMbps desc
```

## Network Connectivity

### VM Network Connections
```kql
VMConnection
| where TimeGenerated > ago(1h)
| project TimeGenerated, Computer, SourceIP, DestinationIP, DestinationPort, Protocol, State
| order by TimeGenerated desc
| take 100
```

### VMs with Active Connections
```kql
VMConnection
| where TimeGenerated > ago(1h)
| summarize ConnectionCount = count() by Computer, DestinationIP, DestinationPort
| order by ConnectionCount desc
| take 20
```

### VMs with Failed Connections
```kql
VMConnection
| where TimeGenerated > ago(1h)
| where State == "Closed" or State == "Reset"
| summarize FailedCount = count() by Computer, DestinationIP, DestinationPort
| order by FailedCount desc
| take 20
```

### VMs with Listening Ports
```kql
VMBoundPort
| where TimeGenerated > ago(1h)
| project TimeGenerated, Computer, Port, Protocol, LocalAddress, ProcessName
| order by Computer asc
```

### VMs with Open Ports
```kql
VMBoundPort
| where TimeGenerated > ago(1h)
| summarize PortCount = count() by Computer, Port, Protocol
| order by PortCount desc
| take 20
```

## Service Map

### VM Services
```kql
VMService
| where TimeGenerated > ago(1h)
| project TimeGenerated, Computer, ServiceName, Status, DisplayName, StartType
| order by Computer asc
```

### VMs with Stopped Services
```kql
VMService
| where TimeGenerated > ago(1h)
| where Status != "Running"
| project TimeGenerated, Computer, ServiceName, Status, DisplayName
| order by Computer asc
```

### VMs with Auto-Start Services Not Running
```kql
VMService
| where TimeGenerated > ago(1h)
| where StartType == "Auto" and Status != "Running"
| project TimeGenerated, Computer, ServiceName, Status, DisplayName
| order by Computer asc
```

### VM Processes
```kql
VMProcess
| where TimeGenerated > ago(1h)
| project TimeGenerated, Computer, ProcessName, ExecutableName, CommandLine, WorkingSet, Cpu
| order by Computer asc
```

### VMs with High CPU Processes
```kql
VMProcess
| where TimeGenerated > ago(1h)
| where Cpu > 50
| project TimeGenerated, Computer, ProcessName, Cpu, WorkingSet
| order by Cpu desc
| take 20
```

### VMs with High Memory Processes
```kql
VMProcess
| where TimeGenerated > ago(1h)
| where WorkingSet > 1000000000
| project TimeGenerated, Computer, ProcessName, WorkingSet, Cpu
| extend MemoryMB = round(WorkingSet / 1024 / 1024, 2)
| order by MemoryMB desc
| take 20
```

## Azure Activity Log

### VM Operations (Last 7d)
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VM" or OperationName contains "Virtual Machine"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
| take 100
```

### VM Start/Stop Operations
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VM" or OperationName contains "Virtual Machine"
| where OperationName contains "start" or OperationName contains "stop" or OperationName contains "restart" or OperationName contains "deallocate"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller
| order by TimeGenerated desc
```

### VM Failed Operations
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VM" or OperationName contains "Virtual Machine"
| where Status == "Failed"
| project TimeGenerated, OperationName, ResourceGroup, Resource, Status, Caller, ErrorMessage
| order by TimeGenerated desc
```

### VM Operations by Caller
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VM" or OperationName contains "Virtual Machine"
| summarize OperationCount = count() by Caller, OperationName
| order by OperationCount desc
| take 20
```

### VM Operations by Status
```kql
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationName contains "VM" or OperationName contains "Virtual Machine"
| summarize OperationCount = count() by Status, OperationName
| order by OperationCount desc
```

## Security

### VMs with Failed Logins (Windows)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID == 4625
| summarize FailedLogins = count() by Computer
| order by FailedLogins desc
| take 20
```

### VMs with Failed Logins (Linux)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "Failed password" or SyslogMessage contains "authentication failure"
| summarize FailedLogins = count() by Computer
| order by FailedLogins desc
| take 20
```

### VMs with Firewall Blocks (Linux)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "iptables" or SyslogMessage contains "nftables" or SyslogMessage contains "firewalld"
| where SyslogMessage contains "DROP" or SyslogMessage contains "REJECT" or SyslogMessage contains "block"
| summarize BlockCount = count() by Computer
| order by BlockCount desc
| take 20
```

### VMs with Critical Events (Windows)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Critical"
| summarize CriticalCount = count() by Computer
| order by CriticalCount desc
| take 20
```

### VMs with Critical Syslog (Linux)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("crit", "alert", "emerg")
| summarize CriticalCount = count() by Computer
| order by CriticalCount desc
| take 20
```

## Cross-Platform Correlation

### VM Health Summary (All VMs)
```kql
let HeartbeatHealth = Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType
| extend HeartbeatStatus = iff(LastHeartbeat > ago(5m), "Healthy", iff(LastHeartbeat > ago(30m), "Warning", "Critical"));
let CPUHealth = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by Computer
| extend CPUStatus = iff(AvgCPU > 90, "Critical", iff(AvgCPU > 80, "Warning", "Healthy"));
let MemoryHealth = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by Computer
| extend MemoryStatus = iff(AvgMemory > 90, "Critical", iff(AvgMemory > 80, "Warning", "Healthy"));
HeartbeatHealth
| join kind=leftouter CPUHealth on Computer
| join kind=leftouter MemoryHealth on Computer
| project Computer, OSType, HeartbeatStatus, AvgCPU, CPUStatus, AvgMemory, MemoryStatus
| order by HeartbeatStatus asc, AvgCPU desc
```

### VM Performance Summary (All VMs)
```kql
let CPU = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue), MaxCPU = max(CounterValue) by Computer;
let Memory = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue), MaxMemory = max(CounterValue) by Computer;
let Disk = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "LogicalDisk"
| where CounterName == "% Free Space"
| where InstanceName == "_Total"
| summarize AvgFree = avg(CounterValue) by Computer;
let Network = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName == "Bytes Total/sec"
| summarize AvgMbps = round(avg(CounterValue) * 8 / 1000000, 2) by Computer;
CPU
| join kind=leftouter Memory on Computer
| join kind=leftouter Disk on Computer
| join kind=leftouter Network on Computer
| project Computer, AvgCPU, MaxCPU, AvgMemory, MaxMemory, AvgFree, AvgMbps
| order by AvgCPU desc
```

### VM Availability Timeline
```kql
Heartbeat
| where TimeGenerated > ago(24h)
| summarize HeartbeatCount = count() by bin(TimeGenerated, 30m), Computer, _ResourceId
| extend alive = iff(heartbeatCount > 0, true, false)
| sort by TimeGenerated asc
| render timechart
```

### VM Error Summary (Windows + Linux)
```kql
let WindowsErrors = Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Error"
| summarize WindowsErrorCount = count() by Computer;
let LinuxErrors = Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| summarize LinuxErrorCount = count() by Computer;
WindowsErrors
| join kind=leftouter LinuxErrors on Computer
| extend TotalErrors = coalesce(WindowsErrorCount, 0) + coalesce(LinuxErrorCount, 0)
| project Computer, WindowsErrorCount, LinuxErrorCount, TotalErrors
| order by TotalErrors desc
```

### VM Resource Usage with Heartbeat
```kql
let HB = Heartbeat
| where TimeGenerated > ago(1h)
| summarize LastHeartbeat = max(TimeGenerated) by Computer, OSType;
let CPU = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by Computer;
let Mem = Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by Computer;
HB
| join kind=leftouter CPU on Computer
| join kind=leftouter Mem on Computer
| project Computer, OSType, LastHeartbeat, AvgCPU, AvgMemory
| order by AvgCPU desc
```
