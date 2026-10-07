# Networking & DNS KQL Queries

> Queries for troubleshooting AKS networking: DNS failures, ingress issues, network policies, CNI problems, and container network logs.

## Prerequisites for ContainerNetworkLogs

Container network logs require:
1. **Advanced Container Networking Services (ACNS)** enabled on the cluster
2. At least one `ContainerNetworkLog` CRD applied
3. Log Analytics workspace configured

### Enable ACNS
```bash
az aks update -g $RG -n $CLUSTER --enable-acns
```

### Apply ContainerNetworkLog CRD
```yaml
apiVersion: acn.azure.com/v1alpha1
kind: ContainerNetworkLog
metadata:
  name: all-traffic
spec:
  filter:
    namespace: "*"
```

## DNS Troubleshooting

### DNS Error Patterns
```kql
ContainerNetworkLogs
| where TimeGenerated between (datetime(<start-time>) .. datetime(<end-time>))
| extend L4 = parse_json(Layer4), L7 = parse_json(Layer7)
| where L4.UDP.destination_port == 53
| where Reply == true
| extend SrcWorkload = tostring(SourceWorkloads[0].name),
        DstWorkload = tostring(DestinationWorkloads[0].name),
        DnsRcode = tostring(L7.dns.rcode)
| where DnsRcode != "NOERROR"
| summarize ResponseCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount)
    by SourceNamespace, SrcWorkload, DestinationNamespace, DstWorkload, DnsRcode, Verdict
| order by ResponseCount desc
```

### DNS Queries by Verdict
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4), L7 = parse_json(Layer7)
| where L4.UDP.destination_port == 53
| extend DnsRcode = tostring(L7.dns.rcode)
| summarize Count = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by DnsRcode, Verdict
| order by Count desc
```

### DNS Queries by Source Workload
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4)
| where L4.UDP.destination_port == 53
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend SrcNamespace = tostring(SourceWorkloads[0].namespace)
| summarize QueryCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by SrcNamespace, SrcWorkload
| order by QueryCount desc
```

### DNS Resolution Failures (NXDOMAIN)
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4), L7 = parse_json(Layer7)
| where L4.UDP.destination_port == 53
| where L7.dns.rcode == "NXERROR" or L7.dns.rcode == "NXDOMAIN"
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend QueryName = tostring(L7.dns.query)
| project TimeGenerated, SrcWorkload, QueryName, L7.dns.rcode, Verdict
| order by TimeGenerated desc
```

### DNS Requests Missing Response
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4)
| where L4.UDP.destination_port == 53
| where Reply == false
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| summarize MissingResponseCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by SrcWorkload, DstWorkload
| where MissingResponseCount > 0
| order by MissingResponseCount desc
```

## Network Policy & Verdicts

### Dropped Flows by Verdict
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| where Verdict != "FORWARDED"
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| summarize DropCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by Verdict, SrcWorkload, DstWorkload
| order by DropCount desc
```

### Dropped Flows by Source
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| where Verdict == "DROPPED"
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend SrcNamespace = tostring(SourceWorkloads[0].namespace)
| summarize DropCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by SrcNamespace, SrcWorkload
| order by DropCount desc
```

### Dropped Flows by Destination
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| where Verdict == "DROPPED"
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| extend DstNamespace = tostring(DestinationWorkloads[0].namespace)
| summarize DropCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by DstNamespace, DstWorkload
| order by DropCount desc
```

### All Non-Forwarded Flows
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| where Verdict != "FORWARDED"
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| extend L4 = parse_json(Layer4)
| extend Port = tostring(L4.TCP.destination_port)
| project TimeGenerated, SrcWorkload, DstWorkload, Port, Verdict
| order by TimeGenerated desc
| take 100
```

## Connectivity Troubleshooting

### Connection Failures (TCP RST)
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4)
| where L4.TCP.flags contains "RST"
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| project TimeGenerated, SrcWorkload, DstWorkload, L4.TCP.flags, Verdict
| order by TimeGenerated desc
| take 50
```

### Connection Timeouts
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4)
| where L4.TCP.flags contains "SYN" and Verdict == "DROPPED"
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| project TimeGenerated, SrcWorkload, DstWorkload, Verdict
| order by TimeGenerated desc
| take 50
```

### Inter-Namespace Traffic
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend SrcNamespace = tostring(SourceWorkloads[0].namespace)
| extend DstNamespace = tostring(DestinationWorkloads[0].namespace)
| where SrcNamespace != DstNamespace
| summarize FlowCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by SrcNamespace, DstNamespace, Verdict
| order by FlowCount desc
```

### Traffic to Specific Pod/Service
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| where DstWorkload contains "<service-name>"
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend L4 = parse_json(Layer4)
| extend Port = tostring(L4.TCP.destination_port)
| project TimeGenerated, SrcWorkload, DstWorkload, Port, Verdict
| order by TimeGenerated desc
```

## Ingress Troubleshooting

### Ingress Controller Pod Status
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where Namespace == "ingress-nginx" or Name contains "ingress"
| project TimeGenerated, Namespace, Name, PodStatus, ContainerStatus, ContainerRestartCount
| order by TimeGenerated desc
```

### Ingress Controller Errors in Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where PodName contains "ingress" or Namespace contains "ingress"
| where LogEntry contains "error" or LogEntry contains "failed"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### Ingress Controller Warning Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Namespace contains "ingress" or Name contains "ingress"
| where KubeEventType == "Warning"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

## Network Flow Analysis

### Top Talkers by Flow Count
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| summarize TotalFlows = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by SrcWorkload, DstWorkload
| order by TotalFlows desc
| take 20
```

### Traffic by Protocol
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4)
| extend Protocol = iff(isnotempty(L4.TCP), "TCP", iff(isnotempty(L4.UDP), "UDP", "Other"))
| summarize FlowCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by Protocol, bin(TimeGenerated, 5m)
| render timechart
```

### Traffic by Port
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L4 = parse_json(Layer4)
| extend Port = tostring(L4.TCP.destination_port)
| summarize FlowCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by Port
| order by FlowCount desc
| take 20
```

### Traffic Over Time
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| summarize TotalFlows = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by bin(TimeGenerated, 5m), Verdict
| render timechart
```

### HTTP Status Codes
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L7 = parse_json(Layer7)
| where isnotempty(L7.HTTP)
| extend StatusCode = tostring(L7.HTTP.status_code)
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| summarize Count = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by StatusCode, SrcWorkload, DstWorkload
| order by Count desc
```

### HTTP 5xx Responses
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend L7 = parse_json(Layer7)
| where isnotempty(L7.HTTP)
| where L7.HTTP.status_code >= 500
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| extend DstWorkload = tostring(DestinationWorkloads[0].name)
| project TimeGenerated, SrcWorkload, DstWorkload, L7.HTTP.status_code, L7.HTTP.method, L7.HTTP.path
| order by TimeGenerated desc
| take 50
```

## CoreDNS Troubleshooting

### CoreDNS Pod Status
```kql
KubePodInventory
| where TimeGenerated > ago(1h)
| where Name contains "coredns" or Name contains "kube-dns"
| project TimeGenerated, Namespace, Name, PodStatus, ContainerStatus, ContainerRestartCount
| order by TimeGenerated desc
```

### CoreDNS Errors in Logs
```kql
ContainerLogV2
| where TimeGenerated > ago(1h)
| where PodName contains "coredns" or PodName contains "kube-dns"
| where LogEntry contains "error" or LogEntry contains "failed" or LogEntry contains "timeout"
| project TimeGenerated, PodName, ContainerName, LogEntry
| order by TimeGenerated desc
| take 50
```

### CoreDNS Warning Events
```kql
KubeEvents
| where TimeGenerated > ago(24h)
| where Name contains "coredns" or Name contains "kube-dns"
| where KubeEventType == "Warning"
| project TimeGenerated, Name, Namespace, Reason, Message
| order by TimeGenerated desc
```

## NSG/Firewall Issues

### Blocked Flows by Port
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| where Verdict == "DROPPED"
| extend L4 = parse_json(Layer4)
| extend Port = tostring(L4.TCP.destination_port)
| summarize DropCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by Port
| order by DropCount desc
```

### Blocked Flows by Destination IP
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| where Verdict == "DROPPED"
| extend DstIP = tostring(DestinationIP)
| summarize DropCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by DstIP
| order by DropCount desc
| take 20
```

### Egress Traffic to External IPs
```kql
ContainerNetworkLogs
| where TimeGenerated > ago(1h)
| extend DstIP = tostring(DestinationIP)
| where DstIP !startswith "10." and DstIP !startswith "172." and DstIP !startswith "192.168."
| extend SrcWorkload = tostring(SourceWorkloads[0].name)
| summarize FlowCount = sum(IngressFlowCount + EgressFlowCount + UnknownDirectionFlowCount) by SrcWorkload, DstIP, Verdict
| order by FlowCount desc
```
