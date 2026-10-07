# Azure VM KQL Troubleshooting Index

> Comprehensive Kusto Query Language (KQL) reference for troubleshooting Azure Windows VMs, Linux VMs, and Virtual Machine Scale Sets (VMSS).

## Prerequisites

Before running any queries, ensure:
1. **Azure Monitor Agent (AMA)** is installed on the VM/VMSS instances
2. **Data Collection Rule (DCR)** is configured and associated with the VM/VMSS
3. Logs are routed to a **Log Analytics workspace**
4. You have **Reader** or **Contributor** access to the workspace

### Install Azure Monitor Agent (Azure CLI)
```bash
az vm extension set \
  --publisher Microsoft.Azure.Monitor \
  --name AzureMonitorWindowsAgent \
  --vm-name $VM_NAME \
  --resource-group $RG

# For Linux:
az vm extension set \
  --publisher Microsoft.Azure.Monitor \
  --name AzureMonitorLinuxAgent \
  --vm-name $VM_NAME \
  --resource-group $RG
```

### Create DCR for Windows Event Logs + Perf Counters
```bash
az monitor data-collection rule create \
  --resource-group $RG \
  --name windows-vm-dcr \
  --location eastus \
  --data-flows '[{"streams":["Microsoft-Event","Microsoft-Perf"],"destinations":["myWorkspace"]}]' \
  --data-sources '{
    "eventLogs": [{
      "name": "eventLogsDataSource",
      "streams": ["Microsoft-Event"],
      "xPathQueries": [
        "System!*[System[(Level=1 or Level=2 or Level=3)]]",
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
    }],
    "performanceCounters": [{
      "name": "perfCounterDataSource",
      "streams": ["Microsoft-Perf"],
      "samplingFrequencyInSeconds": 60,
      "counterSpecifiers": [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes",
        "\\Memory\\% Committed Bytes In Use",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\PhysicalDisk(_Total)\\Avg. Disk Queue Length",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
    }]
  }' \
  --destinations '{"logAnalytics":[{"workspaceResourceId":"'$WORKSPACE_ID'","name":"myWorkspace"}]}'
```

### Create DCR for Linux Syslog + Perf Counters
```bash
az monitor data-collection rule create \
  --resource-group $RG \
  --name linux-vm-dcr \
  --location eastus \
  --data-flows '[{"streams":["Microsoft-Syslog","Microsoft-Perf"],"destinations":["myWorkspace"]}]' \
  --data-sources '{
    "syslog": [{
      "name": "syslogDataSource",
      "streams": ["Microsoft-Syslog"],
      "facilityNames": ["auth","authpriv","cron","daemon","kern","mail","syslog","user"],
      "logLevels": ["Warning","Error","Critical","Alert","Emergency"]
    }],
    "performanceCounters": [{
      "name": "perfCounterDataSource",
      "streams": ["Microsoft-Perf"],
      "samplingFrequencyInSeconds": 60,
      "counterSpecifiers": [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes",
        "\\Memory\\% Committed Bytes In Use",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\PhysicalDisk(_Total)\\Avg. Disk Queue Length",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
    }]
  }' \
  --destinations '{"logAnalytics":[{"workspaceResourceId":"'$WORKSPACE_ID'","name":"myWorkspace"}]}'
```

## Key Log Analytics Tables

| Table | Data Source | Description |
|-------|------------|-------------|
| `Heartbeat` | AMA/MMA | VM availability heartbeats (1 per minute) |
| `Perf` | AMA + DCR | Performance counters (CPU, memory, disk, network) |
| `Event` | AMA + DCR | Windows event logs (System, Application, Security) |
| `Syslog` | AMA + DCR | Linux syslog entries |
| `InsightsMetrics` | VM Insights | VM-level metrics (CPU, memory, disk, network) |
| `AzureActivity` | Azure Platform | Azure activity log (operations, maintenance) |
| `AzureDiagnostics` | Azure Platform | Azure diagnostic logs |
| `VMConnection` | Service Map | Network connections to/from VM |
| `VMProcess` | Service Map | Processes running on VM |
| `VMBoundPort` | Service Map | Network ports bound on VM |
| `VMComputer` | Service Map | VM computer inventory |
| `VMService` | Service Map | Services running on VM |

## Notes Map

- [[01 - Windows VM Queries]] — Event logs, services, Windows-specific issues
- [[02 - Linux VM Queries]] — Syslog, services, Linux-specific issues
- [[03 - VMSS Queries]] — Scale set instances, autoscaling, rolling upgrades
- [[04 - Cross-Platform VM Queries]] — Heartbeat, agent health, common perf counters, network, security

## Quick Diagnostic Flow

```
1. Check VM availability → Heartbeat (is it reporting?)
2. Check agent health → Heartbeat (agent version, last heartbeat)
3. Check CPU/memory → Perf (resource utilization)
4. Check disk → Perf (disk space, queue length, latency)
5. Check network → Perf (bytes in/out, errors)
6. Check OS logs → Event (Windows) or Syslog (Linux)
7. Check services → Event/Syslog (service failures)
8. Check connections → VMConnection (network connectivity)
```
