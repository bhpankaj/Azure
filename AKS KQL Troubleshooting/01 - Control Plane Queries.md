# Control Plane KQL Queries

> Queries for troubleshooting AKS control plane components: kube-apiserver, kube-audit, kube-scheduler, kube-controller-manager.

## kube-apiserver

### All API Server Logs (Last 24h)
```kql
AzureDiagnostics
| where Category == "kube-apiserver"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### API Server 5xx Errors
```kql
AzureDiagnostics
| where Category == "kube-apiserver"
| where log_s contains "resp=5" or log_s contains "\"code\":5"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### API Server 4xx Errors (Client Errors)
```kql
AzureDiagnostics
| where Category == "kube-apiserver"
| where log_s contains "resp=4" or log_s contains "\"code\":4"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### API Server Request Latency (Slow Requests)
```kql
AzureDiagnostics
| where Category == "kube-apiserver"
| where log_s contains "latency" or log_s contains "duration"
| extend latency_ms = extract("\"latency_ms\":(\\d+)", 1, log_s, typeof(long))
| where latency_ms > 1000
| project TimeGenerated, log_s, latency_ms
| order by latency_ms desc
| take 30
```

### API Server Errors by Pod
```kql
AzureDiagnostics
| where Category == "kube-apiserver"
| where log_s contains "error" or log_s contains "failed"
| extend pod = extract("\"pod\":\"([^\"]+)\"", 1, log_s)
| summarize ErrorCount = count() by pod, bin(TimeGenerated, 1h)
| order by ErrorCount desc
```

## kube-audit

### All Audit Logs in Time Range
```kql
let starttime = datetime("2025-01-01T00:00:00Z");
let endtime = datetime("2025-01-02T00:00:00Z");
AzureDiagnostics
| where TimeGenerated between(starttime..endtime)
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend HttpMethod = tostring(event.verb)
| extend User = tostring(event.user.username)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, Category, HttpMethod, User, SourceIP, event
| order by TimeGenerated desc
```

### Audit Events by User
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend User = tostring(event.user.username)
| summarize EventCount = count() by User
| order by EventCount desc
```

### Audit Events by HTTP Verb
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend Verb = tostring(event.verb)
| summarize Count = count() by Verb, bin(TimeGenerated, 1h)
| render timechart
```

### Secret Access Events
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "secrets"
| extend User = tostring(event.user.username)
| extend SecretName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| project TimeGenerated, User, SecretName, Namespace, event.verb
| order by TimeGenerated desc
```

### Exec/Command Execution Events
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "pods" and event.objectRef.subresource == "exec"
| extend User = tostring(event.user.username)
| extend PodName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, User, PodName, Namespace, SourceIP
| order by TimeGenerated desc
```

### RBAC/ClusterRoleBinding Changes
```kql
AzureDiagnostics
| where Category == "kube-audit" or Category == "kube-audit-admin"
| extend event = parse_json(log_s)
| where event.objectRef.resource in ("clusterrolebindings", "rolebindings", "clusterroles", "roles")
| extend User = tostring(event.user.username)
| extend Resource = tostring(event.objectRef.resource)
| extend Name = tostring(event.objectRef.name)
| extend Verb = tostring(event.verb)
| project TimeGenerated, User, Resource, Name, Verb
| order by TimeGenerated desc
```

## kube-scheduler

### All Scheduler Logs
```kql
AzureDiagnostics
| where Category == "kube-scheduler"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### Failed Scheduling Events
```kql
AzureDiagnostics
| where Category == "kube-scheduler"
| where log_s contains "FailedScheduling" or log_s contains "unable to schedule"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### Insufficient Resource Events
```kql
AzureDiagnostics
| where Category == "kube-scheduler"
| where log_s contains "Insufficient" or log_s contains "insufficient"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### Scheduling Failures by Node
```kql
AzureDiagnostics
| where Category == "kube-scheduler"
| where log_s contains "FailedScheduling" or log_s contains "unable to schedule"
| extend node = extract("\"node\":\"([^\"]+)\"", 1, log_s)
| summarize FailureCount = count() by node, bin(TimeGenerated, 1h)
| order by FailureCount desc
```

### Pod Scheduling Decisions
```kql
AzureDiagnostics
| where Category == "kube-scheduler"
| where log_s contains "scheduled" or log_s contains "binding"
| extend pod = extract("\"pod\":\"([^\"]+)\"", 1, log_s)
| extend node = extract("\"node\":\"([^\"]+)\"", 1, log_s)
| project TimeGenerated, pod, node
| order by TimeGenerated desc
| take 50
```

## kube-controller-manager

### All Controller Manager Logs
```kql
AzureDiagnostics
| where Category == "kube-controller-manager"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### Controller Errors
```kql
AzureDiagnostics
| where Category == "kube-controller-manager"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### Deployment Replica Mismatch
```kql
AzureDiagnostics
| where Category == "kube-controller-manager"
| where log_s contains "replica" or log_s contains "ReplicaSet" or log_s contains "Deployment"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

### Node Controller Events
```kql
AzureDiagnostics
| where Category == "kube-controller-manager"
| where log_s contains "node" or log_s contains "Node"
| where log_s contains "not ready" or log_s contains "unreachable" or log_s contains "timeout"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

## cluster-autoscaler

### All Autoscaler Logs
```kql
AzureDiagnostics
| where Category == "cluster-autoscaler"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, Level, Message
| order by TimeGenerated desc
```

### Scale-Up Events
```kql
AzureDiagnostics
| where Category == "cluster-autoscaler"
| where log_s contains "ScaleUp" or log_s contains "scale up"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### Scale-Down Events
```kql
AzureDiagnostics
| where Category == "cluster-autoscaler"
| where log_s contains "ScaleDown" or log_s contains "scale down"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### Autoscaler Failures
```kql
AzureDiagnostics
| where Category == "cluster-autoscaler"
| where log_s contains "error" or log_s contains "failed" or log_s contains "cannot"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

## cloud-controller-manager

### All Cloud Controller Logs
```kql
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### Load Balancer Provisioning Errors
```kql
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where log_s contains "loadbalancer" or log_s contains "LoadBalancer"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

### Disk/Volume Provisioning Errors
```kql
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where log_s contains "disk" or log_s contains "Disk" or log_s contains "volume" or log_s contains "Volume"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

### Route/Network Errors
```kql
AzureDiagnostics
| where Category == "cloud-controller-manager"
| where log_s contains "route" or log_s contains "Route" or log_s contains "network" or log_s contains "Network"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

## Cross-Cutting Control Plane Queries

### All Control Plane Errors (All Categories)
```kql
AzureDiagnostics
| where ResourceType == "MANAGEDCLUSTERS"
| where TimeGenerated >= ago(1h)
| where log_s contains "error" or log_s contains "failed" or log_s contains "Error" or log_s contains "Failed"
| summarize ErrorCount = count() by Category, bin(TimeGenerated, 5m)
| order by ErrorCount desc
```

### Control Plane Error Timeline
```kql
AzureDiagnostics
| where ResourceType == "MANAGEDCLUSTERS"
| where TimeGenerated >= ago(24h)
| where log_s contains "error" or log_s contains "failed"
| summarize Count = count() by Category, bin(TimeGenerated, 1h)
| render timechart
```

### Count Logs by Category
```kql
AzureDiagnostics
| where ResourceType == "MANAGEDCLUSTERS"
| summarize count() by Category
| order by count_ desc
```

### Control Plane Logs by Severity
```kql
AzureDiagnostics
| where ResourceType == "MANAGEDCLUSTERS"
| where TimeGenerated >= ago(1h)
| extend Level = extract("\"level\":\"([^\"]+)\"", 1, log_s)
| summarize Count = count() by Level, Category
| order by Count desc
```
