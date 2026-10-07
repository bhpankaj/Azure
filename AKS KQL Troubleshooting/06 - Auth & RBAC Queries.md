# Auth & RBAC KQL Queries

> Queries for troubleshooting AKS authentication, authorization, RBAC, Entra ID integration, and access control issues.

## guard (Azure AD Authentication)

### All guard Logs
```kql
AzureDiagnostics
| where Category == "guard"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### guard Authentication Errors
```kql
AzureDiagnostics
| where Category == "guard"
| where log_s contains "error" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 20
```

### guard Authorization Failures (403)
```kql
AzureDiagnostics
| where Category == "guard"
| where log_s contains "403" or log_s contains "Forbidden" or log_s contains "unauthorized"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

### guard Token Validation Failures
```kql
AzureDiagnostics
| where Category == "guard"
| where log_s contains "token" or log_s contains "Token"
| where log_s contains "invalid" or log_s contains "expired" or log_s contains "failed"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 30
```

## kube-audit-admin (Admin Audit)

### All Admin Audit Logs
```kql
AzureDiagnostics
| where Category == "kube-audit-admin"
| where TimeGenerated >= ago(24h)
| project TimeGenerated, log_s
| order by TimeGenerated desc
```

### Authentication Failures (401/403)
```kql
AzureDiagnostics
| where Category == "kube-audit-admin"
| where log_s contains "\"code\":403" or log_s contains "\"code\":401"
| project TimeGenerated, log_s
| order by TimeGenerated desc
| take 50
```

### RBAC Modifications
```kql
AzureDiagnostics
| where Category == "kube-audit-admin"
| extend event = parse_json(log_s)
| where event.objectRef.resource in ("clusterrolebindings", "rolebindings", "clusterroles", "roles")
| extend User = tostring(event.user.username)
| extend Resource = tostring(event.objectRef.resource)
| extend Name = tostring(event.objectRef.name)
| extend Verb = tostring(event.verb)
| project TimeGenerated, User, Resource, Name, Verb
| order by TimeGenerated desc
```

### ClusterRoleBinding Changes
```kql
AzureDiagnostics
| where Category == "kube-audit-admin"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "clusterrolebindings"
| extend User = tostring(event.user.username)
| extend BindingName = tostring(event.objectRef.name)
| extend Verb = tostring(event.verb)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, User, BindingName, Verb, SourceIP
| order by TimeGenerated desc
```

### RoleBinding Changes
```kql
AzureDiagnostics
| where Category == "kube-audit-admin"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "rolebindings"
| extend User = tostring(event.user.username)
| extend BindingName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| extend Verb = tostring(event.verb)
| project TimeGenerated, User, BindingName, Namespace, Verb
| order by TimeGenerated desc
```

## kube-audit (Full Audit)

### Failed API Requests (4xx/5xx)
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend Code = tolong(event.code)
| where Code >= 400
| extend User = tostring(event.user.username)
| extend Verb = tostring(event.verb)
| extend Resource = tostring(event.objectRef.resource)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, Code, User, Verb, Resource, SourceIP
| order by TimeGenerated desc
| take 50
```

### Forbidden (403) Requests
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.code == 403
| extend User = tostring(event.user.username)
| extend Verb = tostring(event.verb)
| extend Resource = tostring(event.objectRef.resource)
| extend Name = tostring(event.objectRef.name)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, User, Verb, Resource, Name, SourceIP
| order by TimeGenerated desc
| take 50
```

### Unauthorized (401) Requests
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.code == 401
| extend User = tostring(event.user.username)
| extend Verb = tostring(event.verb)
| extend Resource = tostring(event.objectRef.resource)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, User, Verb, Resource, SourceIP
| order by TimeGenerated desc
| take 50
```

### Anonymous Authentication Attempts
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.user.username == "system:anonymous" or event.user.username == "anonymous"
| extend Verb = tostring(event.verb)
| extend Resource = tostring(event.objectRef.resource)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, Verb, Resource, SourceIP
| order by TimeGenerated desc
```

### Requests by Service Account
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.user.username startswith "system:serviceaccount:"
| extend SA = tostring(event.user.username)
| extend Verb = tostring(event.verb)
| extend Resource = tostring(event.objectRef.resource)
| summarize Count = count() by SA, Verb, Resource
| order by Count desc
```

### Requests by Source IP
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend SourceIP = tostring(event.sourceIPs[0])
| summarize Count = count() by SourceIP
| order by Count desc
| take 20
```

### Requests by User Agent
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend UserAgent = tostring(event.userAgent)
| summarize Count = count() by UserAgent
| order by Count desc
| take 20
```

## Access Pattern Analysis

### Secret Access by User
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "secrets"
| extend User = tostring(event.user.username)
| extend SecretName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| extend Verb = tostring(event.verb)
| summarize Count = count() by User, SecretName, Namespace, Verb
| order by Count desc
```

### ConfigMap Access by User
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "configmaps"
| extend User = tostring(event.user.username)
| extend CMName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| extend Verb = tostring(event.verb)
| summarize Count = count() by User, CMName, Namespace, Verb
| order by Count desc
```

### Pod Exec/Attach Events
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "pods" and event.objectRef.subresource in ("exec", "attach")
| extend User = tostring(event.user.username)
| extend PodName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| extend Subresource = tostring(event.objectRef.subresource)
| extend SourceIP = tostring(event.sourceIPs[0])
| project TimeGenerated, User, PodName, Namespace, Subresource, SourceIP
| order by TimeGenerated desc
```

### Pod Creation/Deletion by User
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.objectRef.resource == "pods"
| where event.verb in ("create", "delete", "update", "patch")
| extend User = tostring(event.user.username)
| extend PodName = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| extend Verb = tostring(event.verb)
| project TimeGenerated, User, PodName, Namespace, Verb
| order by TimeGenerated desc
| take 100
```

### Deployment Changes by User
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| where event.objectRef.resource in ("deployments", "statefulsets", "daemonsets", "replicasets")
| where event.verb in ("create", "delete", "update", "patch")
| extend User = tostring(event.user.username)
| extend Resource = tostring(event.objectRef.resource)
| extend Name = tostring(event.objectRef.name)
| extend Namespace = tostring(event.objectRef.namespace)
| extend Verb = tostring(event.verb)
| project TimeGenerated, User, Resource, Name, Namespace, Verb
| order by TimeGenerated desc
| take 100
```

## Cross-Cutting Auth Queries

### All Auth Failures (All Categories)
```kql
AzureDiagnostics
| where ResourceType == "MANAGEDCLUSTERS"
| where TimeGenerated >= ago(1h)
| where log_s contains "401" or log_s contains "403" or log_s contains "unauthorized" or log_s contains "Unauthorized" or log_s contains "Forbidden"
| summarize Count = count() by Category, bin(TimeGenerated, 5m)
| order by Count desc
```

### Auth Failure Timeline
```kql
AzureDiagnostics
| where ResourceType == "MANAGEDCLUSTERS"
| where TimeGenerated >= ago(24h)
| where log_s contains "401" or log_s contains "403" or log_s contains "unauthorized" or log_s contains "Forbidden"
| summarize Count = count() by Category, bin(TimeGenerated, 1h)
| render timechart
```

### Top Users by API Call Volume
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend User = tostring(event.user.username)
| summarize CallCount = count() by User
| order by CallCount desc
| take 20
```

### API Calls by Verb
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend Verb = tostring(event.verb)
| summarize Count = count() by Verb, bin(TimeGenerated, 1h)
| render timechart
```

### API Calls by Resource Type
```kql
AzureDiagnostics
| where Category == "kube-audit"
| extend event = parse_json(log_s)
| extend Resource = tostring(event.objectRef.resource)
| summarize Count = count() by Resource
| order by Count desc
| take 20
```
