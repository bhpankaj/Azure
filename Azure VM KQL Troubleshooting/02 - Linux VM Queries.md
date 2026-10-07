# Linux VM KQL Queries

> KQL queries for troubleshooting Azure Linux VMs: syslog, services, performance, and Linux-specific issues.

## Syslog Queries

### All Syslog Errors (Last 24h)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| project TimeGenerated, Computer, Facility, SeverityLevel, SyslogMessage
| order by TimeGenerated desc
| take 100
```

### All Syslog Warnings (Last 24h)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("warning", "err", "crit", "alert", "emerg")
| project TimeGenerated, Computer, Facility, SeverityLevel, SyslogMessage
| order by TimeGenerated desc
| take 100
```

### Syslog by Severity
```kql
Syslog
| where TimeGenerated > ago(24h)
| summarize Count = count() by SeverityLevel, Facility
| order by Count desc
```

### Syslog by Facility
```kql
Syslog
| where TimeGenerated > ago(24h)
| summarize Count = count() by Facility, SeverityLevel
| order by Count desc
```

### Syslog Error Timeline
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| summarize Count = count() by bin(TimeGenerated, 1h), Facility
| render timechart
```

### Syslog Messages by Computer
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| summarize Count = count() by Computer, Facility
| order by Count desc
```

## Kernel & Boot Issues

### Kernel Errors (kern facility)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where Facility == "kern"
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### OOM Killer Events
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "Out of memory" or SyslogMessage contains "oom-killer" or SyslogMessage contains "OOM"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

### Kernel Panics
```kql
Syslog
| where TimeGenerated > ago(7d)
| where SyslogMessage contains "panic" or SyslogMessage contains "Panic" or SyslogMessage contains "kernel panic"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

### Failed Boot Attempts
```kql
Syslog
| where TimeGenerated > ago(7d)
| where SyslogMessage contains "failed" and SyslogMessage contains "boot"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

### systemd Boot Errors
```kql
Syslog
| where TimeGenerated > ago(7d)
| where SyslogMessage contains "systemd" and SyslogMessage contains "failed"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

## Service Issues

### systemd Service Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "Failed to start" or SyslogMessage contains "failed with result"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### Service Start Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "start" and SyslogMessage contains "failed"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Service Stop Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "stop" and SyslogMessage contains "failed"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Failed Services from Service Map
```kql
VMService
| where TimeGenerated > ago(1h)
| where Status != "Running"
| project TimeGenerated, Computer, ServiceName, Status, DisplayName
| order by TimeGenerated desc
```

### All Service-Related Syslog
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "service" or SyslogMessage contains "Service"
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| project TimeGenerated, Computer, Facility, SyslogMessage
| order by TimeGenerated desc
| take 50
```

## Authentication & Security

### SSH Failed Login Attempts
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "Failed password" or SyslogMessage contains "authentication failure"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### SSH Successful Logins
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "Accepted password" or SyslogMessage contains "Accepted publickey"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### SSH Brute Force Detection
```kql
Syslog
| where TimeGenerated > ago(1h)
| where SyslogMessage contains "Failed password"
| summarize FailedAttempts = count() by Computer, bin(TimeGenerated, 5m)
| where FailedAttempts > 10
| order by FailedAttempts desc
```

### sudo Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "sudo" and SyslogMessage contains "failed"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Authentication Failures (auth facility)
```kql
Syslog
| where TimeGenerated > ago(24h)
| where Facility in ("auth", "authpriv")
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### Account Lockouts
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "lock" or SyslogMessage contains "Lock"
| where Facility in ("auth", "authpriv")
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

## Disk & Filesystem Issues

### Disk Full Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "No space left on device" or SyslogMessage contains "disk full"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

### Filesystem Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "EXT4-fs error" or SyslogMessage contains "XFS error" or SyslogMessage contains "filesystem error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Disk I/O Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "I/O error" or SyslogMessage contains "io error" or SyslogMessage contains "Buffer I/O error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### SMART Disk Errors
```kql
Syslog
| where TimeGenerated > ago(7d)
| where SyslogMessage contains "SMART" or SyslogMessage contains "smart"
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

### Mount Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "mount" and SyslogMessage contains "failed"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

## Network Issues

### Network Interface Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "network" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Network Link Down
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "link down" or SyslogMessage contains "Link is Down" or SyslogMessage contains "NIC Link is Down"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

### DHCP Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "DHCP" and SyslogMessage contains "failed"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
```

### DNS Resolution Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "DNS" and SyslogMessage contains "fail" or SyslogMessage contains "resolve" and SyslogMessage contains "fail"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Firewall (iptables/nftables) Blocks
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "iptables" or SyslogMessage contains "nftables" or SyslogMessage contains "firewalld"
| where SyslogMessage contains "DROP" or SyslogMessage contains "REJECT" or SyslogMessage contains "block"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

## Performance (Linux)

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

## Web Server (Nginx/Apache)

### Nginx Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "nginx" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### Nginx 5xx Responses
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "nginx" and SyslogMessage contains " 5"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Apache Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "apache" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

## Database (MySQL/PostgreSQL)

### MySQL Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "mysql" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### PostgreSQL Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "postgres" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### Database Connection Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "connection" and SyslogMessage contains "refused"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

## Container Runtime (Docker/containerd)

### Docker Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "docker" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### Containerd Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "containerd" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

### Container Crash Events
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "container" and SyslogMessage contains "died" or SyslogMessage contains "killed" or SyslogMessage contains "OOM"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

## Cron & Scheduled Tasks

### Cron Job Failures
```kql
Syslog
| where TimeGenerated > ago(24h)
| where Facility == "cron"
| where SeverityLevel in ("err", "crit", "alert", "emerg")
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### Cron Job Output
```kql
Syslog
| where TimeGenerated > ago(24h)
| where Facility == "cron"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 50
```

## Package Management

### apt/dpkg Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "apt" and SyslogMessage contains "error" or SyslogMessage contains "dpkg" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```

### yum/dnf Errors
```kql
Syslog
| where TimeGenerated > ago(24h)
| where SyslogMessage contains "yum" and SyslogMessage contains "error" or SyslogMessage contains "dnf" and SyslogMessage contains "error"
| project TimeGenerated, Computer, SyslogMessage
| order by TimeGenerated desc
| take 30
```
