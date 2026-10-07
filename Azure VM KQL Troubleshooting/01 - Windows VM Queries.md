# Windows VM KQL Queries

> KQL queries for troubleshooting Azure Windows VMs: event logs, services, performance, and Windows-specific issues.

## Windows Event Logs

### All Error Events (Last 24h)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventLog, EventID, Source, Message
| order by TimeGenerated desc
| take 100
```

### All Warning Events (Last 24h)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Warning"
| project TimeGenerated, Computer, EventLog, EventID, Source, Message
| order by TimeGenerated desc
| take 100
```

### Critical Events (Last 24h)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Critical"
| project TimeGenerated, Computer, EventLog, EventID, Source, Message
| order by TimeGenerated desc
```

### System Log Errors
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "System"
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventID, Source, Message
| order by TimeGenerated desc
| take 50
```

### Application Log Errors
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventID, Source, Message
| order by TimeGenerated desc
| take 50
```

### Security Log Errors
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventID, Source, Message
| order by TimeGenerated desc
| take 50
```

### Events by Event ID
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName in ("Error", "Warning")
| summarize Count = count() by EventLog, EventID, Source
| order by Count desc
| take 20
```

### Events by Source
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName in ("Error", "Warning")
| summarize Count = count() by Source, EventLog
| order by Count desc
| take 20
```

### Error Events Timeline
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLevelName == "Error"
| summarize Count = count() by bin(TimeGenerated, 1h), EventLog
| render timechart
```

## Windows Service Issues

### Service Control Manager Errors (Event ID 7031)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "System"
| where EventID == 7031
| where Source == "Service Control Manager"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### Service Start Failures (Event ID 7000)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "System"
| where EventID == 7000
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### Service Stop Failures (Event ID 7034)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "System"
| where EventID == 7034
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### Service Timeout (Event ID 7009)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "System"
| where EventID == 7009
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### All Service Control Manager Events
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "System"
| where Source == "Service Control Manager"
| project TimeGenerated, Computer, EventID, EventLevelName, Message
| order by TimeGenerated desc
| take 50
```

### Failed Services from Service Map
```kql
VMService
| where TimeGenerated > ago(1h)
| where Status != "Running"
| project TimeGenerated, Computer, ServiceName, Status, DisplayName
| order by TimeGenerated desc
```

## Windows Update Issues

### Windows Update Errors
```kql
Event
| where TimeGenerated > ago(7d)
| where EventLog == "System"
| where Source == "Microsoft-Windows-WindowsUpdateClient"
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventID, Message
| order by TimeGenerated desc
| take 50
```

### Windows Update Installation Failures
```kql
Event
| where TimeGenerated > ago(7d)
| where EventLog == "System"
| where EventID in (20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34)
| where Source == "Microsoft-Windows-WindowsUpdateClient"
| project TimeGenerated, Computer, EventID, Message
| order by TimeGenerated desc
```

### Windows Update Warnings
```kql
Event
| where TimeGenerated > ago(7d)
| where EventLog == "System"
| where Source == "Microsoft-Windows-WindowsUpdateClient"
| where EventLevelName == "Warning"
| project TimeGenerated, Computer, EventID, Message
| order by TimeGenerated desc
| take 30
```

## BSOD / Crash Issues

### BugCheck Events (Event ID 1001)
```kql
Event
| where TimeGenerated > ago(30d)
| where EventLog == "System"
| where EventID == 1001
| where Source == "Microsoft-Windows-WER-SystemErrorReporting"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### Unexpected Shutdown (Event ID 6008)
```kql
Event
| where TimeGenerated > ago(30d)
| where EventLog == "System"
| where EventID == 6008
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### Kernel Power Critical (Event ID 41)
```kql
Event
| where TimeGenerated > ago(30d)
| where EventLog == "System"
| where EventID == 41
| where Source == "Microsoft-Windows-Kernel-Power"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### System Crash Events
```kql
Event
| where TimeGenerated > ago(30d)
| where EventLog == "System"
| where EventID in (41, 1001, 6008, 6005, 6006)
| project TimeGenerated, Computer, EventID, Source, EventLevelName, Message
| order by TimeGenerated desc
```

## Login & Authentication

### Failed Login Attempts (Event ID 4625)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID == 4625
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
| take 50
```

### Successful Logins (Event ID 4624)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID == 4624
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
| take 50
```

### Account Lockout (Event ID 4740)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID == 4740
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### RDP Login Failures (Event ID 4625, Type 10)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID == 4625
| where Message contains "Logon Type:\t10" or Message contains "Logon Type: 10"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
| take 30
```

## Performance (Windows)

### CPU Usage High (>90%)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| where CounterValue > 90
| summarize AvgCPU = avg(CounterValue), MaxCPU = max(CounterValue) by bin(TimeGenerated, 5m), Computer
| order by TimeGenerated desc
```

### CPU Usage Timechart
```kql
Perf
| where TimeGenerated > ago(6h)
| where ObjectName == "Processor"
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by bin(TimeGenerated, 5m), Computer
| render timechart
```

### Memory Usage High (>90%)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "% Committed Bytes In Use"
| where CounterValue > 90
| summarize AvgMemory = avg(CounterValue), MaxMemory = max(CounterValue) by bin(TimeGenerated, 5m), Computer
| order by TimeGenerated desc
```

### Available Memory Low (<1GB)
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Memory"
| where CounterName == "Available MBytes"
| summarize AvailableMB = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvailableMB < 1024
| order by AvailableMB asc
```

### Disk Space Low (<10% Free)
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

### Disk Queue Length High
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "PhysicalDisk"
| where CounterName == "Avg. Disk Queue Length"
| where InstanceName == "_Total"
| where CounterValue > 2
| summarize AvgQueue = avg(CounterValue), MaxQueue = max(CounterValue) by bin(TimeGenerated, 5m), Computer
| order by TimeGenerated desc
```

### Disk Latency High
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "PhysicalDisk"
| where CounterName in ("Avg. Disk sec/Read", "Avg. Disk sec/Write")
| where InstanceName == "_Total"
| summarize AvgLatency = avg(CounterValue * 1000) by Computer, CounterName, bin(TimeGenerated, 5m)
| where AvgLatency > 50
| order by AvgLatency desc
```

### Network Usage High
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName == "Bytes Total/sec"
| summarize AvgBytes = avg(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 5m)
| extend AvgMbps = round(AvgBytes * 8 / 1000000, 2)
| where AvgMbps > 100
| order by AvgMbps desc
```

### Network Errors
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Network Interface"
| where CounterName in ("Packets Received Errors", "Packets Outbound Errors")
| where CounterValue > 0
| summarize ErrorCount = sum(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| order by ErrorCount desc
```

## Process & Application

### Top CPU Processes
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Process"
| where CounterName == "% Processor Time"
| where InstanceName != "_Total" and InstanceName != "Idle"
| summarize AvgCPU = avg(CounterValue) by Computer, InstanceName
| order by AvgCPU desc
| take 20
```

### Top Memory Processes
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Process"
| where CounterName == "Working Set - Private"
| where InstanceName != "_Total"
| summarize AvgMemory = avg(CounterValue) by Computer, InstanceName
| extend MemoryMB = round(AvgMemory / 1024 / 1024, 2)
| order by MemoryMB desc
| take 20
```

### Process Count by Name
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "Process"
| where CounterName == "ID Process"
| where InstanceName != "_Total"
| summarize ProcessCount = count() by Computer, InstanceName
| order by ProcessCount desc
| take 20
```

### Processes from Service Map
```kql
VMProcess
| where TimeGenerated > ago(1h)
| project TimeGenerated, Computer, ProcessName, ExecutableName, CommandLine, WorkingSet, Cpu
| order by Computer asc
```

## Windows Firewall

### Firewall Block Events
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID == 5156
| where Message contains "block"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
| take 30
```

### Firewall Rule Changes
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Security"
| where EventID in (2004, 2005, 2006, 2007, 2008, 2009, 2010)
| project TimeGenerated, Computer, EventID, Message
| order by TimeGenerated desc
```

## IIS / Web Server

### IIS Errors
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where Source contains "IIS"
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventID, Source, Message
| order by TimeGenerated desc
| take 50
```

### IIS HTTP Errors (5xx)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where Source contains "IIS"
| where Message contains "500" or Message contains "502" or Message contains "503"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
| take 30
```

## SQL Server on Windows VM

### SQL Server Errors
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where Source contains "MSSQL"
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventID, Source, Message
| order by TimeGenerated desc
| take 50
```

### SQL Server Performance
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "SQLServer:General Statistics"
| where CounterName in ("User Connections", "Processes blocked")
| summarize AvgValue = avg(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| order by TimeGenerated desc
```

### SQL Server Buffer Cache Hit Ratio
```kql
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "SQLServer:Buffer Manager"
| where CounterName == "Buffer cache hit ratio"
| summarize AvgHitRatio = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvgHitRatio < 90
| order by AvgHitRatio asc
```

## .NET Application Errors

### .NET Runtime Errors
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where Source == ".NET Runtime"
| where EventLevelName == "Error"
| project TimeGenerated, Computer, EventID, Message
| order by TimeGenerated desc
| take 50
```

### .NET Assembly Loading Errors
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where Source == ".NET Runtime"
| where Message contains "Could not load file or assembly"
| project TimeGenerated, Computer, Message
| order by TimeGenerated desc
```

### Application Crashes (Event ID 1000)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where EventID == 1000
| project TimeGenerated, Computer, Source, Message
| order by TimeGenerated desc
| take 50
```

### Application Hangs (Event ID 1002)
```kql
Event
| where TimeGenerated > ago(24h)
| where EventLog == "Application"
| where EventID == 1002
| project TimeGenerated, Computer, Source, Message
| order by TimeGenerated desc
```
