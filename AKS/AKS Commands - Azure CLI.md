---
title: AKS Commands - Azure CLI
description: Complete reference for all az aks Azure CLI commands with parameters and examples
tags: [azure, cli, aks, kubernetes]
created: 2026-10-08
---

# AKS Commands - Azure CLI

Complete reference for `az aks` commands. All commands use the pattern:

```bash
az aks <command> [parameters]
```

## Global Parameters

| Parameter | Short | Description |
|-----------|-------|-------------|
| `--debug` | | Increase logging verbosity to show all debug logs |
| `--help` | `-h` | Show help message and exit |
| `--only-show-errors` | | Only show errors, suppressing warnings |
| `--output` | `-o` | Output format: `json`, `jsonc`, `none`, `table`, `tsv`, `yaml`, `yamlc` |
| `--query` | | JMESPath query string |
| `--subscription` | | Name or ID of subscription |
| `--verbose` | | Increase logging verbosity |

## Common Parameters

| Parameter | Short | Description |
|-----------|-------|-------------|
| `--resource-group` | `-g` | Name of resource group |
| `--name` | `-n` | Name of the managed cluster |
| `--cluster-name` | | Name of the cluster (for nodepool commands) |
| `--nodepool-name` | | Name of the node pool |

---

## Cluster Lifecycle

### az aks create

Create a new managed Kubernetes cluster.

```bash
az aks create \
  --resource-group MyResourceGroup \
  --name MyManagedCluster \
  --node-count 3 \
  --generate-ssh-keys \
  --kubernetes-version 1.28.0
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--node-count` | Number of nodes (default: 3) |
| `--node-vm-size` | VM size for nodes (default: `standard_ds2_v2`) |
| `--kubernetes-version` | Kubernetes version (e.g., `1.28.0`) |
| `--generate-ssh-keys` | Generate SSH key pair |
| `--admin-username` | Admin username (default: `azureuser`) |
| `--dns-name-prefix` | DNS name prefix |
| `--location -l` | Location |
| `--load-balancer-sku` | Load balancer SKU: `basic` or `standard` |
| `--vm-set-type` | VM set type: `VirtualMachineScaleSets` or `AvailabilitySet` |
| `--network-plugin` | Network plugin: `azure`, `kubenet`, `none` |
| `--network-policy` | Network policy: `azure`, `calico` |
| `--max-pods` | Max pods per node (default: 110) |
| `--node-osdisk-size` | OS disk size in GB |
| `--node-osdisk-type` | OS disk type: `Managed`, `Ephemeral` |
| `--enable-cluster-autoscaler` | Enable cluster autoscaler |
| `--min-count` | Min nodes for autoscaler |
| `--max-count` | Max nodes for autoscaler |
| `--enable-addons` | Enable addons (comma-separated) |
| `--disable-rbac` | Disable RBAC |
| `--enable-rbac` | Enable RBAC (default) |
| `--aad-client-app-id` | AAD client app ID |
| `--aad-server-app-id` | AAD server app ID |
| `--aad-server-app-secret` | AAD server app secret |
| `--aad-tenant-id` | AAD tenant ID |
| `--service-principal` | Service principal client ID |
| `--client-secret` | Service principal client secret |
| `--ssh-key-value` | SSH public key value or path |
| `--tags` | Tags (space-separated key=value) |
| `--zones` | Availability zones (space-separated) |
| `--vnet-subnet-id` | VNet subnet ID |
| `--subnet` | Subnet name |
| `--pod-cidr` | Pod CIDR |
| `--service-cidr` | Service CIDR |
| `--dns-service-ip` | DNS service IP |
| `--docker-bridge-address` | Docker bridge address |
| `--outbound-type` | Outbound type: `loadBalancer`, `userDefinedRouting`, `managedNATGateway`, `userAssignedNATGateway` |
| `--enable-managed-identity` | Enable managed identity |
| `--assign-identity` | User-assigned identity resource ID |
| `--attach-acr` | Attach ACR by name or ID |
| `--enable-private-cluster` | Enable private cluster |
| `--private-dns-zone` | Private DNS zone |
| `--fqdn-subdomain` | FQDN subdomain |
| `--api-server-authorized-ip-ranges` | API server authorized IP ranges |
| `--disable-local-accounts` | Disable local accounts |
| `--enable-oidc-issuer` | Enable OIDC issuer |
| `--enable-workload-identity` | Enable workload identity |
| `--enable-encryption-at-host` | Enable encryption at host |
| `--enable-ultra-ssd` | Enable Ultra SSD |
| `--enable-azure-keyvault-kms` | Enable Azure Key Vault KMS |
| `--enable-image-cleaner` | Enable image cleaner |
| `--image-cleaner-interval-hours` | Image cleaner interval |
| `--enable-defender` | Enable Microsoft Defender |
| `--defender-config-file` | Defender config file path |
| `--enable-keda` | Enable KEDA |
| `--enable-vpa` | Enable VPA |
| `--enable-azure-monitor-metrics` | Enable Azure Monitor metrics |
| `--workspace-resource-id` | Log Analytics workspace resource ID |
| `--enable-syslog` | Enable syslog |
| `--data-collection-settings` | Data collection settings file |
| `--enable-app-routing` | Enable app routing |
| `--enable-asm` | Enable Azure Service Mesh |
| `--revision` | Service mesh revision |
| `--enable-cost-analysis` | Enable cost analysis |
| `--node-resource-group` | Node resource group |
| `--enable-custom-ca-trust` | Enable custom CA trust |
| `--ca-certificates` | Custom CA certificates file |
| `--enable-run-command` | Enable run command |
| `--disable-run-command` | Disable run command |
| `--enable-acns` | Enable ACNS |
| `--acns-advanced-networkpolicies` | ACNS advanced network policies |
| `--acns-transparent-encryption` | ACNS transparent encryption |
| `--acns-observability` | ACNS observability |
| `--enable-cilium-datapath` | Enable Cilium datapath |
| `--enable-network-observability` | Enable network observability |
| `--enable-fqdn-policy` | Enable FQDN policy |
| `--enable-security-policy` | Enable security policy |
| `--enable-trusted-launch` | Enable trusted launch |
| `--enable-confidential-computing` | Enable confidential computing |
| `--enable-vm-backup` | Enable VM backup |
| `--enable-elastic-san` | Enable Elastic SAN |
| `--enable-static-egress-gateway` | Enable static egress gateway |
| `--enable-telemetry` | Enable telemetry |
| `--no-wait` | Do not wait for completion |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Basic cluster
az aks create -g MyResourceGroup -n MyCluster --node-count 3 --generate-ssh-keys

# Cluster with specific Kubernetes version
az aks create -g MyResourceGroup -n MyCluster --kubernetes-version 1.28.0

# Cluster with autoscaler
az aks create -g MyResourceGroup -n MyCluster --node-count 3 \
  --enable-cluster-autoscaler --min-count 1 --max-count 5

# Cluster with managed identity
az aks create -g MyResourceGroup -n MyCluster --enable-managed-identity

# Private cluster
az aks create -g MyResourceGroup -n MyCluster --enable-private-cluster \
  --enable-managed-identity

# Cluster with Azure CNI
az aks create -g MyResourceGroup -n MyCluster --network-plugin azure \
  --pod-cidr 10.244.0.0/16 --service-cidr 10.0.0.0/16 \
  --dns-service-ip 10.0.0.10 --docker-bridge-address 172.17.0.1/16

# Cluster with GPU nodes
az aks create -g MyResourceGroup -n MyCluster \
  --node-vm-size Standard_NC6s_v3 --node-count 3

# Cluster with availability zones
az aks create -g MyResourceGroup -n MyCluster --zones 1 2 3

# Cluster with Windows node pool
az aks create -g MyResourceGroup -n MyCluster \
  --load-balancer-sku standard --network-plugin azure

# Cluster with Azure Policy addon
az aks create -g MyResourceGroup -n MyCluster --enable-addons azure-policy

# Cluster with monitoring
az aks create -g MyResourceGroup -n MyCluster \
  --enable-addons monitoring --workspace-resource-id <workspace-id>

# Cluster with app routing
az aks create -g MyResourceGroup -n MyCluster --enable-app-routing

# Cluster with Azure Service Mesh
az aks create -g MyResourceGroup -n MyCluster --enable-asm

# Cluster with encryption at host
az aks create -g MyResourceGroup -n MyCluster --enable-encryption-at-host

# Cluster with Ultra SSD
az aks create -g MyResourceGroup -n MyCluster --enable-ultra-ssd

# Cluster with custom VNet
az aks create -g MyResourceGroup -n MyCluster \
  --vnet-subnet-id /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>

# Cluster with outbound NAT gateway
az aks create -g MyResourceGroup -n MyCluster \
  --outbound-type userAssignedNATGateway

# Cluster with static egress gateway
az aks create -g MyResourceGroup -n MyCluster \
  --enable-static-egress-gateway

# Cluster with confidential computing
az aks create -g MyResourceGroup -n MyCluster \
  --enable-confidential-computing

# Cluster with VM backup
az aks create -g MyResourceGroup -n MyCluster --enable-vm-backup

# Cluster with Elastic SAN
az aks create -g MyResourceGroup -n MyCluster --enable-elastic-san

# Cluster with trusted launch
az aks create -g MyResourceGroup -n MyCluster --enable-trusted-launch

# Cluster with custom CA trust
az aks create -g MyResourceGroup -n MyCluster --enable-custom-ca-trust

# Cluster with run command disabled
az aks create -g MyResourceGroup -n MyCluster --disable-run-command

# Cluster with ACNS
az aks create -g MyResourceGroup -n MyCluster --enable-acns

# Cluster with Cilium datapath
az aks create -g MyResourceGroup -n MyCluster --enable-cilium-datapath

# Cluster with network observability
az aks create -g MyResourceGroup -n MyCluster --enable-network-observability

# Cluster with FQDN policy
az aks create -g MyResourceGroup -n MyCluster --enable-fqdn-policy

# Cluster with security policy
az aks create -g MyResourceGroup -n MyCluster --enable-security-policy

# Cluster with telemetry
az aks create -g MyResourceGroup -n MyCluster --enable-telemetry

# Cluster with cost analysis
az aks create -g MyResourceGroup -n MyCluster --enable-cost-analysis

# Cluster with image cleaner
az aks create -g MyResourceGroup -n MyCluster --enable-image-cleaner \
  --image-cleaner-interval-hours 24

# Cluster with KEDA
az aks create -g MyResourceGroup -n MyCluster --enable-keda

# Cluster with VPA
az aks create -g MyResourceGroup -n MyCluster --enable-vpa

# Cluster with Defender
az aks create -g MyResourceGroup -n MyCluster --enable-defender

# Cluster with Azure Key Vault KMS
az aks create -g MyResourceGroup -n MyCluster --enable-azure-keyvault-kms

# Cluster with workload identity
az aks create -g MyResourceGroup -n MyCluster --enable-workload-identity

# Cluster with OIDC issuer
az aks create -g MyResourceGroup -n MyCluster --enable-oidc-issuer

# Cluster with local accounts disabled
az aks create -g MyResourceGroup -n MyCluster --disable-local-accounts

# Cluster with API server authorized IP ranges
az aks create -g MyResourceGroup -n MyCluster \
  --api-server-authorized-ip-ranges 203.0.113.0/24

# Cluster with custom DNS prefix
az aks create -g MyResourceGroup -n MyCluster \
  --dns-name-prefix mycluster-dns

# Cluster with tags
az aks create -g MyResourceGroup -n MyCluster \
  --tags "environment=production" "team=devops"

# Cluster with node resource group
az aks create -g MyResourceGroup -n MyCluster \
  --node-resource-group MyNodeResourceGroup

# Cluster with syslog
az aks create -g MyResourceGroup -n MyCluster \
  --enable-syslog --data-collection-settings <settings-file>

# Cluster with Azure Monitor metrics
az aks create -g MyResourceGroup -n MyCluster \
  --enable-azure-monitor-metrics

# Cluster with ephemeral OS disk
az aks create -g MyResourceGroup -n MyCluster \
  --node-osdisk-type Ephemeral --node-osdisk-size 128

# Cluster with specific OS disk size
az aks create -g MyResourceGroup -n MyCluster \
  --node-osdisk-size 256

# Cluster with max pods
az aks create -g MyResourceGroup -n MyCluster --max-pods 250

# Cluster with kubenet network plugin
az aks create -g MyResourceGroup -n MyCluster --network-plugin kubenet

# Cluster with calico network policy
az aks create -g MyResourceGroup -n MyCluster --network-policy calico

# Cluster with no network policy
az aks create -g MyResourceGroup -n MyCluster --network-policy none

# Cluster with basic load balancer
az aks create -g MyResourceGroup -n MyCluster --load-balancer-sku basic

# Cluster with standard load balancer
az aks create -g MyResourceGroup -n MyCluster --load-balancer-sku standard

# Cluster with availability set VM type
az aks create -g MyResourceGroup -n MyCluster --vm-set-type AvailabilitySet

# Cluster with VMSS VM type
az aks create -g MyResourceGroup -n MyCluster --vm-set-type VirtualMachineScaleSets

# Cluster with user-defined routing
az aks create -g MyResourceGroup -n MyCluster \
  --outbound-type userDefinedRouting

# Cluster with managed NAT gateway
az aks create -g MyResourceGroup -n MyCluster \
  --outbound-type managedNATGateway

# Cluster with user-assigned NAT gateway
az aks create -g MyResourceGroup -n MyCluster \
  --outbound-type userAssignedNATGateway

# Cluster with AAD integration
az aks create -g MyResourceGroup -n MyCluster \
  --aad-client-app-id <client-app-id> \
  --aad-server-app-id <server-app-id> \
  --aad-server-app-secret <server-app-secret> \
  --aad-tenant-id <tenant-id>

# Cluster with service principal
az aks create -g MyResourceGroup -n MyCluster \
  --service-principal <sp-id> --client-secret <secret>

# Cluster with SSH key
az aks create -g MyResourceGroup -n MyCluster \
  --ssh-key-value ~/.ssh/id_rsa.pub

# Cluster with admin username
az aks create -g MyResourceGroup -n MyCluster \
  --admin-username myadmin

# Cluster with location
az aks create -g MyResourceGroup -n MyCluster \
  --location eastus

# Cluster with no-wait
az aks create -g MyResourceGroup -n MyCluster --no-wait

# Cluster with yes flag
az aks create -g MyResourceGroup -n MyCluster --yes

# Cluster with debug logging
az aks create -g MyResourceGroup -n MyCluster --debug

# Cluster with verbose logging
az aks create -g MyResourceGroup -n MyCluster --verbose

# Cluster with only-show-errors
az aks create -g MyResourceGroup -n MyCluster --only-show-errors

# Cluster with JSON output
az aks create -g MyResourceGroup -n MyCluster --output json

# Cluster with table output
az aks create -g MyResourceGroup -n MyCluster --output table

# Cluster with YAML output
az aks create -g MyResourceGroup -n MyCluster --output yaml

# Cluster with TSV output
az aks create -g MyResourceGroup -n MyCluster --output tsv

# Cluster with JMESPath query
az aks create -g MyResourceGroup -n MyCluster \
  --query "provisioningState"

# Cluster with subscription
az aks create -g MyResourceGroup -n MyCluster \
  --subscription <subscription-id>
```

---

### az aks delete

Delete a managed Kubernetes cluster.

```bash
az aks delete --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--no-wait` | Do not wait for completion |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Delete cluster
az aks delete -g MyResourceGroup -n MyCluster

# Delete without confirmation
az aks delete -g MyResourceGroup -n MyCluster --yes

# Delete without waiting
az aks delete -g MyResourceGroup -n MyCluster --no-wait

# Delete with debug
az aks delete -g MyResourceGroup -n MyCluster --debug
```

---

### az aks list

List managed Kubernetes clusters.

```bash
az aks list
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Filter by resource group |
| `--output -o` | Output format |

**Examples:**

```bash
# List all clusters
az aks list

# List clusters in resource group
az aks list -g MyResourceGroup

# List as table
az aks list --output table

# List as JSON
az aks list --output json

# List with query
az aks list --query "[].{Name:name, Location:location, K8sVersion:kubernetesVersion}"

# List with verbose
az aks list --verbose
```

---

### az aks show

Show details for a managed Kubernetes cluster.

```bash
az aks show --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--output -o` | Output format |
| `--query` | JMESPath query |

**Examples:**

```bash
# Show cluster details
az aks show -g MyResourceGroup -n MyCluster

# Show as table
az aks show -g MyResourceGroup -n MyCluster --output table

# Show provisioning state
az aks show -g MyResourceGroup -n MyCluster \
  --query "provisioningState" --output tsv

# Show with query
az aks show -g MyResourceGroup -n MyCluster \
  --query "{Name:name, Location:location, K8sVersion:kubernetesVersion, NodeCount:agentPoolProfiles[0].count}"
```

---

### az aks get-credentials

Get access credentials for a managed Kubernetes cluster.

```bash
az aks get-credentials --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--admin` | Get cluster administrator credentials |
| `--overwrite-existing` | Overwrite existing credentials |
| `--file -f` | File path to save kubeconfig |
| `--format` | Format: `azure`, `exec` |

**Examples:**

```bash
# Get credentials
az aks get-credentials -g MyResourceGroup -n MyCluster

# Get admin credentials
az aks get-credentials -g MyResourceGroup -n MyCluster --admin

# Overwrite existing
az aks get-credentials -g MyResourceGroup -n MyCluster --overwrite-existing

# Save to file
az aks get-credentials -g MyResourceGroup -n MyCluster -f ~/.kube/config

# Get exec format credentials
az aks get-credentials -g MyResourceGroup -n MyCluster --format exec
```

---

### az aks scale

Scale the node pool in a managed Kubernetes cluster.

```bash
az aks scale --resource-group MyResourceGroup --name MyManagedCluster --node-count 5
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--node-count` | Number of nodes (required) |
| `--nodepool-name` | Node pool name (default: `nodepool1`) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Scale to 5 nodes
az aks scale -g MyResourceGroup -n MyCluster --node-count 5

# Scale specific node pool
az aks scale -g MyResourceGroup -n MyCluster \
  --nodepool-name MyNodePool --node-count 3

# Scale without waiting
az aks scale -g MyResourceGroup -n MyCluster --node-count 5 --no-wait
```

---

### az aks upgrade

Upgrade a managed Kubernetes cluster to a newer version.

```bash
az aks upgrade --resource-group MyResourceGroup --name MyManagedCluster --kubernetes-version 1.28.0
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--kubernetes-version` | Target Kubernetes version |
| `--control-plane-only` | Upgrade control plane only |
| `--node-image-only` | Upgrade node image only |
| `--no-wait` | Do not wait for completion |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Upgrade cluster
az aks upgrade -g MyResourceGroup -n MyCluster --kubernetes-version 1.28.0

# Upgrade control plane only
az aks upgrade -g MyResourceGroup -n MyCluster \
  --kubernetes-version 1.28.0 --control-plane-only

# Upgrade node image only
az aks upgrade -g MyResourceGroup -n MyCluster --node-image-only

# Upgrade without confirmation
az aks upgrade -g MyResourceGroup -n MyCluster \
  --kubernetes-version 1.28.0 --yes

# Upgrade without waiting
az aks upgrade -g MyResourceGroup -n MyCluster \
  --kubernetes-version 1.28.0 --no-wait
```

---

### az aks update

Update a managed Kubernetes cluster.

```bash
az aks update --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--enable-cluster-autoscaler` | Enable cluster autoscaler |
| `--disable-cluster-autoscaler` | Disable cluster autoscaler |
| `--update-cluster-autoscaler` | Update cluster autoscaler |
| `--min-count` | Min nodes for autoscaler |
| `--max-count` | Max nodes for autoscaler |
| `--load-balancer-managed-outbound-ip-count` | Managed outbound IP count |
| `--load-balancer-outbound-ips` | Outbound IPs |
| `--load-balancer-outbound-ip-prefixes` | Outbound IP prefixes |
| `--load-balancer-idle-timeout` | Idle timeout in minutes |
| `--load-balancer-backend-pool-type` | Backend pool type |
| `--nat-gateway-managed-outbound-ip-count` | NAT gateway managed outbound IP count |
| `--nat-gateway-idle-timeout` | NAT gateway idle timeout |
| `--attach-acr` | Attach ACR |
| `--detach-acr` | Detach ACR |
| `--enable-local-accounts` | Enable local accounts |
| `--disable-local-accounts` | Disable local accounts |
| `--enable-public-fqdn` | Enable public FQDN |
| `--disable-public-fqdn` | Disable public FQDN |
| `--api-server-authorized-ip-ranges` | API server authorized IP ranges |
| `--enable-oidc-issuer` | Enable OIDC issuer |
| `--disable-oidc-issuer` | Disable OIDC issuer |
| `--enable-workload-identity` | Enable workload identity |
| `--disable-workload-identity` | Disable workload identity |
| `--enable-managed-identity` | Enable managed identity |
| `--disable-managed-identity` | Disable managed identity |
| `--enable-azure-keyvault-kms` | Enable Azure Key Vault KMS |
| `--disable-azure-keyvault-kms` | Disable Azure Key Vault KMS |
| `--azure-keyvault-kms-key-id` | Key ID |
| `--azure-keyvault-kms-key-vault-network-access` | Key vault network access |
| `--azure-keyvault-kms-key-vault-resource-id` | Key vault resource ID |
| `--enable-image-cleaner` | Enable image cleaner |
| `--disable-image-cleaner` | Disable image cleaner |
| `--image-cleaner-interval-hours` | Image cleaner interval |
| `--enable-defender` | Enable Defender |
| `--disable-defender` | Disable Defender |
| `--defender-config-file` | Defender config file |
| `--enable-keda` | Enable KEDA |
| `--disable-keda` | Disable KEDA |
| `--enable-vpa` | Enable VPA |
| `--disable-vpa` | Disable VPA |
| `--enable-azure-monitor-metrics` | Enable Azure Monitor metrics |
| `--disable-azure-monitor-metrics` | Disable Azure Monitor metrics |
| `--workspace-resource-id` | Workspace resource ID |
| `--enable-syslog` | Enable syslog |
| `--disable-syslog` | Disable syslog |
| `--data-collection-settings` | Data collection settings |
| `--enable-cost-analysis` | Enable cost analysis |
| `--disable-cost-analysis` | Disable cost analysis |
| `--enable-acns` | Enable ACNS |
| `--disable-acns` | Disable ACNS |
| `--acns-advanced-networkpolicies` | ACNS advanced network policies |
| `--acns-transparent-encryption` | ACNS transparent encryption |
| `--acns-observability` | ACNS observability |
| `--enable-cilium-datapath` | Enable Cilium datapath |
| `--disable-cilium-datapath` | Disable Cilium datapath |
| `--enable-network-observability` | Enable network observability |
| `--disable-network-observability` | Disable network observability |
| `--enable-fqdn-policy` | Enable FQDN policy |
| `--disable-fqdn-policy` | Disable FQDN policy |
| `--enable-security-policy` | Enable security policy |
| `--disable-security-policy` | Disable security policy |
| `--enable-trusted-launch` | Enable trusted launch |
| `--disable-trusted-launch` | Disable trusted launch |
| `--enable-confidential-computing` | Enable confidential computing |
| `--disable-confidential-computing` | Disable confidential computing |
| `--enable-vm-backup` | Enable VM backup |
| `--disable-vm-backup` | Disable VM backup |
| `--enable-elastic-san` | Enable Elastic SAN |
| `--disable-elastic-san` | Disable Elastic SAN |
| `--enable-static-egress-gateway` | Enable static egress gateway |
| `--disable-static-egress-gateway` | Disable static egress gateway |
| `--enable-telemetry` | Enable telemetry |
| `--disable-telemetry` | Disable telemetry |
| `--tags` | Tags |
| `--no-wait` | Do not wait for completion |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Enable autoscaler
az aks update -g MyResourceGroup -n MyCluster \
  --enable-cluster-autoscaler --min-count 1 --max-count 5

# Disable autoscaler
az aks update -g MyResourceGroup -n MyCluster --disable-cluster-autoscaler

# Update autoscaler
az aks update -g MyResourceGroup -n MyCluster \
  --update-cluster-autoscaler --min-count 2 --max-count 8

# Attach ACR
az aks update -g MyResourceGroup -n MyCluster --attach-acr MyACR

# Detach ACR
az aks update -g MyResourceGroup -n MyCluster --detach-acr MyACR

# Enable local accounts
az aks update -g MyResourceGroup -n MyCluster --enable-local-accounts

# Disable local accounts
az aks update -g MyResourceGroup -n MyCluster --disable-local-accounts

# Enable public FQDN
az aks update -g MyResourceGroup -n MyCluster --enable-public-fqdn

# Disable public FQDN
az aks update -g MyResourceGroup -n MyCluster --disable-public-fqdn

# Set API server authorized IP ranges
az aks update -g MyResourceGroup -n MyCluster \
  --api-server-authorized-ip-ranges 203.0.113.0/24

# Enable OIDC issuer
az aks update -g MyResourceGroup -n MyCluster --enable-oidc-issuer

# Disable OIDC issuer
az aks update -g MyResourceGroup -n MyCluster --disable-oidc-issuer

# Enable workload identity
az aks update -g MyResourceGroup -n MyCluster --enable-workload-identity

# Disable workload identity
az aks update -g MyResourceGroup -n MyCluster --disable-workload-identity

# Enable managed identity
az aks update -g MyResourceGroup -n MyCluster --enable-managed-identity

# Disable managed identity
az aks update -g MyResourceGroup -n MyCluster --disable-managed-identity

# Enable Azure Key Vault KMS
az aks update -g MyResourceGroup -n MyCluster --enable-azure-keyvault-kms \
  --azure-keyvault-kms-key-id <key-id>

# Disable Azure Key Vault KMS
az aks update -g MyResourceGroup -n MyCluster --disable-azure-keyvault-kms

# Enable image cleaner
az aks update -g MyResourceGroup -n MyCluster --enable-image-cleaner \
  --image-cleaner-interval-hours 24

# Disable image cleaner
az aks update -g MyResourceGroup -n MyCluster --disable-image-cleaner

# Enable Defender
az aks update -g MyResourceGroup -n MyCluster --enable-defender \
  --defender-config-file <config-file>

# Disable Defender
az aks update -g MyResourceGroup -n MyCluster --disable-defender

# Enable KEDA
az aks update -g MyResourceGroup -n MyCluster --enable-keda

# Disable KEDA
az aks update -g MyResourceGroup -n MyCluster --disable-keda

# Enable VPA
az aks update -g MyResourceGroup -n MyCluster --enable-vpa

# Disable VPA
az aks update -g MyResourceGroup -n MyCluster --disable-vpa

# Enable Azure Monitor metrics
az aks update -g MyResourceGroup -n MyCluster \
  --enable-azure-monitor-metrics --workspace-resource-id <workspace-id>

# Disable Azure Monitor metrics
az aks update -g MyResourceGroup -n MyCluster --disable-azure-monitor-metrics

# Enable syslog
az aks update -g MyResourceGroup -n MyCluster \
  --enable-syslog --data-collection-settings <settings-file>

# Disable syslog
az aks update -g MyResourceGroup -n MyCluster --disable-syslog

# Enable cost analysis
az aks update -g MyResourceGroup -n MyCluster --enable-cost-analysis

# Disable cost analysis
az aks update -g MyResourceGroup -n MyCluster --disable-cost-analysis

# Enable ACNS
az aks update -g MyResourceGroup -n MyCluster --enable-acns

# Disable ACNS
az aks update -g MyResourceGroup -n MyCluster --disable-acns

# Enable Cilium datapath
az aks update -g MyResourceGroup -n MyCluster --enable-cilium-datapath

# Disable Cilium datapath
az aks update -g MyResourceGroup -n MyCluster --disable-cilium-datapath

# Enable network observability
az aks update -g MyResourceGroup -n MyCluster --enable-network-observability

# Disable network observability
az aks update -g MyResourceGroup -n MyCluster --disable-network-observability

# Enable FQDN policy
az aks update -g MyResourceGroup -n MyCluster --enable-fqdn-policy

# Disable FQDN policy
az aks update -g MyResourceGroup -n MyCluster --disable-fqdn-policy

# Enable security policy
az aks update -g MyResourceGroup -n MyCluster --enable-security-policy

# Disable security policy
az aks update -g MyResourceGroup -n MyCluster --disable-security-policy

# Enable trusted launch
az aks update -g MyResourceGroup -n MyCluster --enable-trusted-launch

# Disable trusted launch
az aks update -g MyResourceGroup -n MyCluster --disable-trusted-launch

# Enable confidential computing
az aks update -g MyResourceGroup -n MyCluster --enable-confidential-computing

# Disable confidential computing
az aks update -g MyResourceGroup -n MyCluster --disable-confidential-computing

# Enable VM backup
az aks update -g MyResourceGroup -n MyCluster --enable-vm-backup

# Disable VM backup
az aks update -g MyResourceGroup -n MyCluster --disable-vm-backup

# Enable Elastic SAN
az aks update -g MyResourceGroup -n MyCluster --enable-elastic-san

# Disable Elastic SAN
az aks update -g MyResourceGroup -n MyCluster --disable-elastic-san

# Enable static egress gateway
az aks update -g MyResourceGroup -n MyCluster --enable-static-egress-gateway

# Disable static egress gateway
az aks update -g MyResourceGroup -n MyCluster --disable-static-egress-gateway

# Enable telemetry
az aks update -g MyResourceGroup -n MyCluster --enable-telemetry

# Disable telemetry
az aks update -g MyResourceGroup -n MyCluster --disable-telemetry

# Update tags
az aks update -g MyResourceGroup -n MyCluster \
  --tags "environment=staging" "team=platform"

# Update load balancer outbound IP count
az aks update -g MyResourceGroup -n MyCluster \
  --load-balancer-managed-outbound-ip-count 2

# Update load balancer idle timeout
az aks update -g MyResourceGroup -n MyCluster \
  --load-balancer-idle-timeout 10

# Update NAT gateway managed outbound IP count
az aks update -g MyResourceGroup -n MyCluster \
  --nat-gateway-managed-outbound-ip-count 2

# Update NAT gateway idle timeout
az aks update -g MyResourceGroup -n MyCluster \
  --nat-gateway-idle-timeout 10

# Update without waiting
az aks update -g MyResourceGroup -n MyCluster --no-wait

# Update without confirmation
az aks update -g MyResourceGroup -n MyCluster --yes
```

---

### az aks start

Start a managed Kubernetes cluster.

```bash
az aks start --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Start cluster
az aks start -g MyResourceGroup -n MyCluster

# Start without waiting
az aks start -g MyResourceGroup -n MyCluster --no-wait
```

---

### az aks stop

Stop a managed Kubernetes cluster.

```bash
az aks stop --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Stop cluster
az aks stop -g MyResourceGroup -n MyCluster

# Stop without waiting
az aks stop -g MyResourceGroup -n MyCluster --no-wait
```

---

### az aks get-upgrades

Get the upgrade versions available for a managed Kubernetes cluster.

```bash
az aks get-upgrades --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Get available upgrades
az aks get-upgrades -g MyResourceGroup -n MyCluster

# Get upgrades as table
az aks get-upgrades -g MyResourceGroup -n MyCluster --output table

# Get upgrades as JSON
az aks get-upgrades -g MyResourceGroup -n MyCluster --output json
```

---

### az aks get-versions

Get the versions available for creating a managed Kubernetes cluster.

```bash
az aks get-versions --location eastus
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--location -l` | Location (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Get available versions
az aks get-versions -l eastus

# Get versions as table
az aks get-versions -l eastus --output table

# Get versions as JSON
az aks get-versions -l eastus --output json
```

---

### az aks install-cli

Download and install kubectl and kubelogin.

```bash
az aks install-cli
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--client-version` | kubectl client version |
| `--install-location` | Install location |
| `--base-src-url` | Base source URL |
| `--kubelogin-version` | kubelogin version |
| `--kubelogin-install-location` | kubelogin install location |
| `--kubelogin-base-src-url` | kubelogin base source URL |

**Examples:**

```bash
# Install kubectl and kubelogin
az aks install-cli

# Install specific kubectl version
az aks install-cli --client-version 1.28.0

# Install to custom location
az aks install-cli --install-location /usr/local/bin/kubectl

# Install specific kubelogin version
az aks install-cli --kubelogin-version 0.1.0
```

---

### az aks browse

Show the dashboard for a Kubernetes cluster in a web browser.

```bash
az aks browse --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--disable-browser` | Don't open browser |
| `--listen-port` | Listen port |
| `--listen-address` | Listen address |

**Examples:**

```bash
# Open dashboard
az aks browse -g MyResourceGroup -n MyCluster

# Don't open browser
az aks browse -g MyResourceGroup -n MyCluster --disable-browser

# Custom port
az aks browse -g MyResourceGroup -n MyCluster --listen-port 8080

# Custom address
az aks browse -g MyResourceGroup -n MyCluster --listen-address 127.0.0.1
```

---

### az aks check-acr

Validate an ACR is accessible from an AKS cluster.

```bash
az aks check-acr --resource-group MyResourceGroup --name MyManagedCluster --acr MyACR.azurecr.io
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--acr` | ACR name or resource ID (required) |

**Examples:**

```bash
# Check ACR access
az aks check-acr -g MyResourceGroup -n MyCluster --acr MyACR.azurecr.io

# Check ACR by resource ID
az aks check-acr -g MyResourceGroup -n MyCluster \
  --acr /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ContainerRegistry/registries/<acr>
```

---

### az aks wait

Wait for a managed Kubernetes cluster to reach a desired state.

```bash
az aks wait --resource-group MyResourceGroup --name MyManagedCluster --created
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--created` | Wait until created |
| `--updated` | Wait until updated |
| `--deleted` | Wait until deleted |
| `--exists` | Wait until exists |
| `--custom` | Custom JMESPath condition |
| `--interval` | Polling interval (default: 30) |
| `--timeout` | Max wait time (default: 3600) |

**Examples:**

```bash
# Wait for creation
az aks wait -g MyResourceGroup -n MyCluster --created

# Wait for update
az aks wait -g MyResourceGroup -n MyCluster --updated

# Wait for deletion
az aks wait -g MyResourceGroup -n MyCluster --deleted

# Wait for existence
az aks wait -g MyResourceGroup -n MyCluster --exists

# Custom condition
az aks wait -g MyResourceGroup -n MyCluster \
  --custom "provisioningState!='InProgress'"

# Custom interval and timeout
az aks wait -g MyResourceGroup -n MyCluster \
  --created --interval 60 --timeout 1800
```

---

### az aks update-credentials

Update credentials for a managed Kubernetes cluster.

```bash
az aks update-credentials --resource-group MyResourceGroup --name MyManagedCluster --reset-service-principal
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--reset-service-principal` | Reset service principal |
| `--reset-aad` | Reset AAD |
| `--service-principal` | New service principal |
| `--client-secret` | New client secret |
| `--aad-server-app-id` | New AAD server app ID |
| `--aad-server-app-secret` | New AAD server app secret |
| `--aad-client-app-id` | New AAD client app ID |
| `--aad-tenant-id` | New AAD tenant ID |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Reset service principal
az aks update-credentials -g MyResourceGroup -n MyCluster \
  --reset-service-principal --service-principal <sp-id> --client-secret <secret>

# Reset AAD
az aks update-credentials -g MyResourceGroup -n MyCluster \
  --reset-aad --aad-server-app-id <id> --aad-server-app-secret <secret> \
  --aad-client-app-id <id> --aad-tenant-id <id>
```

---

## Node Pool Commands

### az aks nodepool add

Add a node pool to a managed Kubernetes cluster.

```bash
az aks nodepool add \
  --resource-group MyResourceGroup \
  --cluster-name MyManagedCluster \
  --name MyNodePool \
  --node-count 3
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--node-count` | Number of nodes (default: 3) |
| `--node-vm-size` | VM size |
| `--os-type` | OS type: `Linux`, `Windows` |
| `--os-sku` | OS SKU |
| `--max-pods` | Max pods per node |
| `--node-osdisk-size` | OS disk size in GB |
| `--node-osdisk-type` | OS disk type |
| `--enable-cluster-autoscaler` | Enable autoscaler |
| `--min-count` | Min nodes |
| `--max-count` | Max nodes |
| `--mode` | Mode: `System`, `User` |
| `--availability-zones` | Availability zones |
| `--vnet-subnet-id` | VNet subnet ID |
| `--pod-subnet-id` | Pod subnet ID |
| `--labels` | Node labels |
| `--tags` | Node tags |
| `--node-taints` | Node taints |
| `--priority` | Priority: `Regular`, `Spot` |
| `--eviction-policy` | Eviction policy: `Delete`, `Deallocate` |
| `--spot-max-price` | Spot max price |
| `--scale-down-mode` | Scale down mode: `Delete`, `Deallocate` |
| `--max-surge` | Max surge |
| `--enable-encryption-at-host` | Enable encryption at host |
| `--enable-ultra-ssd` | Enable Ultra SSD |
| `--enable-fips-image` | Enable FIPS image |
| `--enable-public-ip` | Enable public IP |
| `--public-ip-prefix-id` | Public IP prefix ID |
| `--kubelet-config` | Kubelet config file |
| `--linux-os-config` | Linux OS config file |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Add basic node pool
az aks nodepool add -g MyResourceGroup -c MyCluster -n MyNodePool --node-count 3

# Add Windows node pool
az aks nodepool add -g MyResourceGroup -c MyCluster -n WinNodePool \
  --os-type Windows --node-count 3

# Add GPU node pool
az aks nodepool add -g MyResourceGroup -c MyCluster -n GpuNodePool \
  --node-vm-size Standard_NC6s_v3 --node-count 3

# Add spot node pool
az aks nodepool add -g MyResourceGroup -c MyCluster -n SpotNodePool \
  --priority Spot --eviction-policy Delete --spot-max-price 0.5

# Add node pool with autoscaler
az aks nodepool add -g MyResourceGroup -c MyCluster -n AutoNodePool \
  --enable-cluster-autoscaler --min-count 1 --max-count 5

# Add node pool with labels
az aks nodepool add -g MyResourceGroup -c MyCluster -n LabeledNodePool \
  --labels "env=prod" "team=devops"

# Add node pool with taints
az aks nodepool add -g MyResourceGroup -c MyCluster -n TaintedNodePool \
  --node-taints "key1=value1:NoSchedule"

# Add node pool with max surge
az aks nodepool add -g MyResourceGroup -c MyCluster -n SurgeNodePool \
  --max-surge 2

# Add node pool with FIPS
az aks nodepool add -g MyResourceGroup -c MyCluster -n FipsNodePool \
  --enable-fips-image

# Add node pool with public IP
az aks nodepool add -g MyResourceGroup -c MyCluster -n PublicIpNodePool \
  --enable-public-ip

# Add node pool with custom VNet
az aks nodepool add -g MyResourceGroup -c MyCluster -n VnetNodePool \
  --vnet-subnet-id <subnet-id>

# Add node pool with pod subnet
az aks nodepool add -g MyResourceGroup -c MyCluster -n PodSubnetNodePool \
  --pod-subnet-id <pod-subnet-id>

# Add node pool with kubelet config
az aks nodepool add -g MyResourceGroup -c MyCluster -n KubeletNodePool \
  --kubelet-config <config-file>

# Add node pool with Linux OS config
az aks nodepool add -g MyResourceGroup -c MyCluster -n OsConfigNodePool \
  --linux-os-config <config-file>

# Add node pool with encryption at host
az aks nodepool add -g MyResourceGroup -c MyCluster -n EncNodePool \
  --enable-encryption-at-host

# Add node pool with Ultra SSD
az aks nodepool add -g MyResourceGroup -c MyCluster -n UltraNodePool \
  --enable-ultra-ssd

# Add node pool with scale down mode
az aks nodepool add -g MyResourceGroup -c MyCluster -n ScaleDownNodePool \
  --scale-down-mode Deallocate

# Add node pool with availability zones
az aks nodepool add -g MyResourceGroup -c MyCluster -n ZoneNodePool \
  --availability-zones 1 2 3

# Add node pool with OS SKU
az aks nodepool add -g MyResourceGroup -c MyCluster -n OsSkuNodePool \
  --os-sku Ubuntu

# Add node pool with max pods
az aks nodepool add -g MyResourceGroup -c MyCluster -n MaxPodsNodePool \
  --max-pods 250

# Add node pool with OS disk size
az aks nodepool add -g MyResourceGroup -c MyCluster -n DiskNodePool \
  --node-osdisk-size 256

# Add node pool with OS disk type
az aks nodepool add -g MyResourceGroup -c MyCluster -n DiskTypeNodePool \
  --node-osdisk-type Ephemeral

# Add node pool with mode
az aks nodepool add -g MyResourceGroup -c MyCluster -n SystemNodePool \
  --mode System

# Add node pool with no-wait
az aks nodepool add -g MyResourceGroup -c MyCluster -n NoWaitNodePool \
  --no-wait
```

---

### az aks nodepool list

List node pools in a managed Kubernetes cluster.

```bash
az aks nodepool list --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List node pools
az aks nodepool list -g MyResourceGroup -c MyCluster

# List as table
az aks nodepool list -g MyResourceGroup -c MyCluster --output table

# List as JSON
az aks nodepool list -g MyResourceGroup -c MyCluster --output json
```

---

### az aks nodepool show

Show details for a node pool in a managed Kubernetes cluster.

```bash
az aks nodepool show --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show node pool
az aks nodepool show -g MyResourceGroup -c MyCluster -n MyNodePool

# Show as table
az aks nodepool show -g MyResourceGroup -c MyCluster -n MyNodePool --output table
```

---

### az aks nodepool scale

Scale the node pool in a managed Kubernetes cluster.

```bash
az aks nodepool scale --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool --node-count 5
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--node-count` | Number of nodes (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Scale node pool
az aks nodepool scale -g MyResourceGroup -c MyCluster -n MyNodePool --node-count 5

# Scale without waiting
az aks nodepool scale -g MyResourceGroup -c MyCluster -n MyNodePool \
  --node-count 5 --no-wait
```

---

### az aks nodepool upgrade

Upgrade the node pool in a managed Kubernetes cluster.

```bash
az aks nodepool upgrade --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool --kubernetes-version 1.28.0
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--kubernetes-version` | Target Kubernetes version |
| `--node-image-only` | Upgrade node image only |
| `--max-surge` | Max surge |
| `--no-wait` | Do not wait for completion |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Upgrade node pool
az aks nodepool upgrade -g MyResourceGroup -c MyCluster -n MyNodePool \
  --kubernetes-version 1.28.0

# Upgrade node image only
az aks nodepool upgrade -g MyResourceGroup -c MyCluster -n MyNodePool \
  --node-image-only

# Upgrade with max surge
az aks nodepool upgrade -g MyResourceGroup -c MyCluster -n MyNodePool \
  --kubernetes-version 1.28.0 --max-surge 2

# Upgrade without confirmation
az aks nodepool upgrade -g MyResourceGroup -c MyCluster -n MyNodePool \
  --kubernetes-version 1.28.0 --yes
```

---

### az aks nodepool update

Update the node pool in a managed Kubernetes cluster.

```bash
az aks nodepool update --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--enable-cluster-autoscaler` | Enable autoscaler |
| `--disable-cluster-autoscaler` | Disable autoscaler |
| `--update-cluster-autoscaler` | Update autoscaler |
| `--min-count` | Min nodes |
| `--max-count` | Max nodes |
| `--mode` | Mode: `System`, `User` |
| `--labels` | Node labels |
| `--tags` | Node tags |
| `--node-taints` | Node taints |
| `--max-surge` | Max surge |
| `--scale-down-mode` | Scale down mode |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Enable autoscaler
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --enable-cluster-autoscaler --min-count 1 --max-count 5

# Disable autoscaler
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --disable-cluster-autoscaler

# Update autoscaler
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --update-cluster-autoscaler --min-count 2 --max-count 8

# Update mode
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --mode System

# Update labels
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --labels "env=prod"

# Update taints
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --node-taints "key1=value1:NoSchedule"

# Update max surge
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --max-surge 2

# Update scale down mode
az aks nodepool update -g MyResourceGroup -c MyCluster -n MyNodePool \
  --scale-down-mode Deallocate
```

---

### az aks nodepool delete

Delete a node pool from a managed Kubernetes cluster.

```bash
az aks nodepool delete --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Delete node pool
az aks nodepool delete -g MyResourceGroup -c MyCluster -n MyNodePool

# Delete without waiting
az aks nodepool delete -g MyResourceGroup -c MyCluster -n MyNodePool --no-wait
```

---

### az aks nodepool get-upgrades

Get the available upgrade versions for an agent pool.

```bash
az aks nodepool get-upgrades --resource-group MyResourceGroup --cluster-name MyManagedCluster --nodepool-name MyNodePool
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--nodepool-name` | Node pool name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Get node pool upgrades
az aks nodepool get-upgrades -g MyResourceGroup -c MyCluster -n MyNodePool

# Get upgrades as table
az aks nodepool get-upgrades -g MyResourceGroup -c MyCluster -n MyNodePool \
  --output table
```

---

### az aks nodepool stop

Stop a node pool in a managed Kubernetes cluster.

```bash
az aks nodepool stop --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Stop node pool
az aks nodepool stop -g MyResourceGroup -c MyCluster -n MyNodePool

# Stop without waiting
az aks nodepool stop -g MyResourceGroup -c MyCluster -n MyNodePool --no-wait
```

---

### az aks nodepool start

Start a node pool in a managed Kubernetes cluster.

```bash
az aks nodepool start --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Start node pool
az aks nodepool start -g MyResourceGroup -c MyCluster -n MyNodePool

# Start without waiting
az aks nodepool start -g MyResourceGroup -c MyCluster -n MyNodePool --no-wait
```

---

### az aks nodepool operation-abort

Abort the currently running operation on a node pool.

```bash
az aks nodepool operation-abort --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyNodePool
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Node pool name (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Abort operation
az aks nodepool operation-abort -g MyResourceGroup -c MyCluster -n MyNodePool

# Abort without waiting
az aks nodepool operation-abort -g MyResourceGroup -c MyCluster -n MyNodePool --no-wait
```

---

## Addon Commands

### az aks enable-addons

Enable Kubernetes addons.

```bash
az aks enable-addons --resource-group MyResourceGroup --name MyManagedCluster --addons monitoring
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--addons` | Addons to enable (comma-separated, required) |
| `--workspace-resource-id` | Log Analytics workspace ID |
| `--subnet-name` | Subnet name |
| `--appgw-name` | Application Gateway name |
| `--appgw-subnet-cidr` | App Gateway subnet CIDR |
| `--appgw-subnet-id` | App Gateway subnet ID |
| `--appgw-watch-namespace` | App Gateway watch namespace |
| `--enable-syslog` | Enable syslog |
| `--data-collection-settings` | Data collection settings |
| `--dns-zone-resource-id` | DNS zone resource ID |
| `--dns-zone-name` | DNS zone name |
| `--rotation-poll-interval` | Rotation poll interval |
| `--no-wait` | Do not wait for completion |

**Available Addons:**

| Addon | Description |
|-------|-------------|
| `http_application_routing` | HTTP application routing |
| `monitoring` | Azure Monitor for containers |
| `virtual-node` | Virtual node (ACI) |
| `azure-policy` | Azure Policy |
| `kube-dashboard` | Kubernetes dashboard |
| `ingress-appgw` | Application Gateway ingress |
| `confidential-computing` | Confidential computing |
| `open-service-mesh` | Open Service Mesh |
| `azure-keyvault-secrets-provider` | Azure Key Vault secrets provider |
| `gitops` | GitOps |
| `web_application_routing` | Web application routing |

**Examples:**

```bash
# Enable monitoring
az aks enable-addons -g MyResourceGroup -n MyCluster --addons monitoring

# Enable monitoring with workspace
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons monitoring --workspace-resource-id <workspace-id>

# Enable Azure Policy
az aks enable-addons -g MyResourceGroup -n MyCluster --addons azure-policy

# Enable HTTP application routing
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons http_application_routing

# Enable virtual node
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons virtual-node --subnet-name <subnet-name>

# Enable App Gateway ingress
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons ingress-appgw --appgw-name <appgw-name> \
  --appgw-subnet-cidr <cidr>

# Enable Key Vault secrets provider
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons azure-keyvault-secrets-provider

# Enable Open Service Mesh
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons open-service-mesh

# Enable GitOps
az aks enable-addons -g MyResourceGroup -n MyCluster --addons gitops

# Enable web application routing
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons web_application_routing

# Enable multiple addons
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons monitoring,azure-policy

# Enable with syslog
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons monitoring --enable-syslog \
  --data-collection-settings <settings-file>

# Enable with DNS zone
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons http_application_routing --dns-zone-resource-id <zone-id>

# Enable with rotation poll interval
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons azure-keyvault-secrets-provider \
  --rotation-poll-interval 2m

# Enable without waiting
az aks enable-addons -g MyResourceGroup -n MyCluster \
  --addons monitoring --no-wait
```

---

### az aks disable-addons

Disable Kubernetes addons.

```bash
az aks disable-addons --resource-group MyResourceGroup --name MyManagedCluster --addons monitoring
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--addons` | Addons to disable (comma-separated, required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Disable monitoring
az aks disable-addons -g MyResourceGroup -n MyCluster --addons monitoring

# Disable Azure Policy
az aks disable-addons -g MyResourceGroup -n MyCluster --addons azure-policy

# Disable multiple addons
az aks disable-addons -g MyResourceGroup -n MyCluster \
  --addons monitoring,azure-policy

# Disable without waiting
az aks disable-addons -g MyResourceGroup -n MyCluster \
  --addons monitoring --no-wait
```

---

### az aks addon list-available

List available Kubernetes addons.

```bash
az aks addon list-available
```

**Examples:**

```bash
# List available addons
az aks addon list-available
```

---

### az aks addon list

List status of all Kubernetes addons in a cluster.

```bash
az aks addon list --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List addons
az aks addon list -g MyResourceGroup -n MyCluster

# List as table
az aks addon list -g MyResourceGroup -n MyCluster --output table
```

---

### az aks addon show

Show status and configuration for an enabled addon.

```bash
az aks addon show --resource-group MyResourceGroup --name MyManagedCluster --addon monitoring
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--addon` | Addon name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show addon
az aks addon show -g MyResourceGroup -n MyCluster --addon monitoring

# Show as JSON
az aks addon show -g MyResourceGroup -n MyCluster --addon monitoring --output json
```

---

### az aks addon update

Update an already enabled Kubernetes addon.

```bash
az aks addon update --resource-group MyResourceGroup --name MyManagedCluster --addon monitoring
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--addon` | Addon name (required) |
| `--workspace-resource-id` | Workspace resource ID |
| `--enable-syslog` | Enable syslog |
| `--disable-syslog` | Disable syslog |
| `--data-collection-settings` | Data collection settings |
| `--dns-zone-resource-id` | DNS zone resource ID |
| `--rotation-poll-interval` | Rotation poll interval |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Update monitoring addon
az aks addon update -g MyResourceGroup -n MyCluster --addon monitoring

# Update with workspace
az aks addon update -g MyResourceGroup -n MyCluster \
  --addon monitoring --workspace-resource-id <workspace-id>

# Update with syslog
az aks addon update -g MyResourceGroup -n MyCluster \
  --addon monitoring --enable-syslog \
  --data-collection-settings <settings-file>

# Update DNS zone
az aks addon update -g MyResourceGroup -n MyCluster \
  --addon http_application_routing --dns-zone-resource-id <zone-id>

# Update rotation poll interval
az aks addon update -g MyResourceGroup -n MyCluster \
  --addon azure-keyvault-secrets-provider \
  --rotation-poll-interval 2m
```

---

## Run Command

### az aks command invoke

Run a shell command on your AKS cluster.

```bash
az aks command invoke --resource-group MyResourceGroup --name MyManagedCluster --command "kubectl get nodes"
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--command` | Command to run (required) |
| `--file` | Files to attach (space-separated) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Run kubectl command
az aks command invoke -g MyResourceGroup -n MyCluster \
  --command "kubectl get nodes"

# Run with file
az aks command invoke -g MyResourceGroup -n MyCluster \
  --command "kubectl apply -f -" --file deployment.yaml

# Run without waiting
az aks command invoke -g MyResourceGroup -n MyCluster \
  --command "kubectl get pods" --no-wait
```

---

### az aks command result

Fetch result from a previously triggered command invoke.

```bash
az aks command result --resource-group MyResourceGroup --name MyManagedCluster --command-id <command-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--command-id` | Command ID (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Get command result
az aks command result -g MyResourceGroup -n MyCluster --command-id <id>

# Get result as JSON
az aks command result -g MyResourceGroup -n MyCluster --command-id <id> --output json
```

---

## Maintenance Configuration

### az aks maintenanceconfiguration list

List maintenance configurations for a managed cluster.

```bash
az aks maintenanceconfiguration list --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List maintenance configurations
az aks maintenanceconfiguration list -g MyResourceGroup -c MyCluster

# List as table
az aks maintenanceconfiguration list -g MyResourceGroup -c MyCluster --output table
```

---

### az aks maintenanceconfiguration show

Show details for a maintenance configuration.

```bash
az aks maintenanceconfiguration show --resource-group MyResourceGroup --cluster-name MyManagedCluster --name default
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Configuration name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show maintenance configuration
az aks maintenanceconfiguration show -g MyResourceGroup -c MyCluster -n default

# Show as JSON
az aks maintenanceconfiguration show -g MyResourceGroup -c MyCluster -n default --output json
```

---

### az aks maintenanceconfiguration add

Add a maintenance configuration to a managed cluster.

```bash
az aks maintenanceconfiguration add --resource-group MyResourceGroup --cluster-name MyManagedCluster --name default --weekday Monday --start-hour 1
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Configuration name (required) |
| `--weekday` | Day of week (e.g., `Monday`) |
| `--start-hour` | Start hour (0-23) |
| `--duration-hours` | Duration in hours |
| `--schedule-type` | Schedule type: `Daily`, `Weekly`, `AbsoluteMonthly`, `RelativeMonthly` |
| `--day-of-month` | Day of month (for AbsoluteMonthly) |
| `--day-of-week` | Day of week (for RelativeMonthly) |
| `--week-index` | Week index: `First`, `Second`, `Third`, `Fourth`, `Last` |
| `--interval-days` | Interval in days (for Daily) |
| `--interval-weeks` | Interval in weeks (for Weekly) |
| `--interval-months` | Interval in months (for monthly) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Add weekly maintenance window
az aks maintenanceconfiguration add -g MyResourceGroup -c MyCluster \
  -n default --weekday Monday --start-hour 1 --duration-hours 4

# Add daily maintenance window
az aks maintenanceconfiguration add -g MyResourceGroup -c MyCluster \
  -n daily --schedule-type Daily --start-hour 2 --duration-hours 2

# Add absolute monthly maintenance window
az aks maintenanceconfiguration add -g MyResourceGroup -c MyCluster \
  -n monthly --schedule-type AbsoluteMonthly --day-of-month 1 \
  --start-hour 1 --duration-hours 4

# Add relative monthly maintenance window
az aks maintenanceconfiguration add -g MyResourceGroup -c MyCluster \
  -n relative --schedule-type RelativeMonthly --day-of-week Monday \
  --week-index First --start-hour 1 --duration-hours 4
```

---

### az aks maintenanceconfiguration update

Update a maintenance configuration.

```bash
az aks maintenanceconfiguration update --resource-group MyResourceGroup --cluster-name MyManagedCluster --name default --weekday Tuesday --start-hour 2
```

**Key Parameters:** Same as `add`

**Examples:**

```bash
# Update maintenance window
az aks maintenanceconfiguration update -g MyResourceGroup -c MyCluster \
  -n default --weekday Tuesday --start-hour 2
```

---

### az aks maintenanceconfiguration delete

Delete a maintenance configuration.

```bash
az aks maintenanceconfiguration delete --resource-group MyResourceGroup --cluster-name MyManagedCluster --name default
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Configuration name (required) |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Delete maintenance configuration
az aks maintenanceconfiguration delete -g MyResourceGroup -c MyCluster -n default

# Delete without confirmation
az aks maintenanceconfiguration delete -g MyResourceGroup -c MyCluster -n default --yes
```

---

## Snapshot Commands

### az aks snapshot list

List managed cluster snapshots.

```bash
az aks snapshot list
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Filter by resource group |
| `--output -o` | Output format |

**Examples:**

```bash
# List all snapshots
az aks snapshot list

# List snapshots in resource group
az aks snapshot list -g MyResourceGroup

# List as table
az aks snapshot list --output table
```

---

### az aks snapshot show

Show details for a managed cluster snapshot.

```bash
az aks snapshot show --resource-group MyResourceGroup --name MySnapshot
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Snapshot name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show snapshot
az aks snapshot show -g MyResourceGroup -n MySnapshot

# Show as JSON
az aks snapshot show -g MyResourceGroup -n MySnapshot --output json
```

---

### az aks snapshot create

Create a managed cluster snapshot.

```bash
az aks snapshot create --resource-group MyResourceGroup --name MySnapshot --cluster-id <cluster-resource-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Snapshot name (required) |
| `--cluster-id` | Source cluster resource ID (required) |
| `--tags` | Tags |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Create snapshot
az aks snapshot create -g MyResourceGroup -n MySnapshot \
  --cluster-id /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ContainerService/managedClusters/<cluster>

# Create with tags
az aks snapshot create -g MyResourceGroup -n MySnapshot \
  --cluster-id <cluster-id> --tags "env=prod"
```

---

### az aks snapshot delete

Delete a managed cluster snapshot.

```bash
az aks snapshot delete --resource-group MyResourceGroup --name MySnapshot
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Snapshot name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Delete snapshot
az aks snapshot delete -g MyResourceGroup -n MySnapshot

# Delete without confirmation
az aks snapshot delete -g MyResourceGroup -n MySnapshot --yes
```

---

### az aks snapshot update

Update a managed cluster snapshot.

```bash
az aks snapshot update --resource-group MyResourceGroup --name MySnapshot --tags "env=staging"
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Snapshot name (required) |
| `--tags` | Tags |

**Examples:**

```bash
# Update snapshot tags
az aks snapshot update -g MyResourceGroup -n MySnapshot --tags "env=staging"
```

---

## Identity Binding Commands

### az aks identity-binding create

Create a new identity binding in a managed Kubernetes cluster.

```bash
az aks identity-binding create --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyBinding --source-identity <identity-id> --target-identity <target-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Binding name (required) |
| `--source-identity` | Source identity resource ID (required) |
| `--target-identity` | Target identity resource ID (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Create identity binding
az aks identity-binding create -g MyResourceGroup -c MyCluster \
  -n MyBinding --source-identity <source-id> --target-identity <target-id>
```

---

### az aks identity-binding delete

Delete a specific identity binding.

```bash
az aks identity-binding delete --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyBinding
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Binding name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Delete identity binding
az aks identity-binding delete -g MyResourceGroup -c MyCluster -n MyBinding
```

---

### az aks identity-binding list

List identity bindings in a managed Kubernetes cluster.

```bash
az aks identity-binding list --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List identity bindings
az aks identity-binding list -g MyResourceGroup -c MyCluster

# List as table
az aks identity-binding list -g MyResourceGroup -c MyCluster --output table
```

---

### az aks identity-binding show

Show details for an identity binding.

```bash
az aks identity-binding show --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyBinding
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Binding name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show identity binding
az aks identity-binding show -g MyResourceGroup -c MyCluster -n MyBinding
```

---

## Operation Commands

### az aks operation list

List operations on a managed Kubernetes cluster or one of its node pools.

```bash
az aks operation list --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--nodepool-name` | Filter by node pool name |
| `--active-only` | Show only active operations |
| `--output -o` | Output format |

**Examples:**

```bash
# List operations
az aks operation list -g MyResourceGroup -n MyCluster

# List active operations only
az aks operation list -g MyResourceGroup -n MyCluster --active-only

# List operations for node pool
az aks operation list -g MyResourceGroup -n MyCluster \
  --nodepool-name MyNodePool

# List as table
az aks operation list -g MyResourceGroup -n MyCluster --output table
```

---

### az aks operation show

Show details for a specific operation.

```bash
az aks operation show --resource-group MyResourceGroup --name MyManagedCluster --operation-id <operation-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--operation-id` | Operation ID (required) |
| `--nodepool-name` | Node pool name |
| `--output -o` | Output format |

**Examples:**

```bash
# Show operation
az aks operation show -g MyResourceGroup -n MyCluster --operation-id <id>

# Show as JSON
az aks operation show -g MyResourceGroup -n MyCluster --operation-id <id> --output json
```

---

### az aks operation show-latest

Show details for the latest operation.

```bash
az aks operation show-latest --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--nodepool-name` | Node pool name |
| `--output -o` | Output format |

**Examples:**

```bash
# Show latest operation
az aks operation show-latest -g MyResourceGroup -n MyCluster

# Show latest operation for node pool
az aks operation show-latest -g MyResourceGroup -n MyCluster \
  --nodepool-name MyNodePool
```

---

## Egress Endpoint Commands

### az aks egress-endpoints list

List egress endpoints required or recommended for a cluster.

```bash
az aks egress-endpoints list --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List egress endpoints
az aks egress-endpoints list -g MyResourceGroup -n MyCluster

# List as table
az aks egress-endpoints list -g MyResourceGroup -n MyCluster --output table
```

---

## Network Check Commands

### az aks check-network outbound

Perform outbound network connectivity check for a node.

```bash
az aks check-network outbound --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--nodepool-name` | Node pool name |
| `--node-name` | Node name |
| `--output -o` | Output format |

**Examples:**

```bash
# Check outbound connectivity
az aks check-network outbound -g MyResourceGroup -n MyCluster

# Check for specific node pool
az aks check-network outbound -g MyResourceGroup -n MyCluster \
  --nodepool-name MyNodePool
```

---

## App Routing Commands

### az aks approuting enable

Enable App Routing addon.

```bash
az aks approuting enable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--enable-kube-metric-scraper` | Enable kube metric scraper |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Enable app routing
az aks approuting enable -g MyResourceGroup -n MyCluster

# Enable with kube metric scraper
az aks approuting enable -g MyResourceGroup -n MyCluster \
  --enable-kube-metric-scraper
```

---

### az aks approuting disable

Disable App Routing addon.

```bash
az aks approuting disable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Disable app routing
az aks approuting disable -g MyResourceGroup -n MyCluster
```

---

### az aks approuting update

Update App Routing addon.

```bash
az aks approuting update --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--enable-kube-metric-scraper` | Enable kube metric scraper |
| `--disable-kube-metric-scraper` | Disable kube metric scraper |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Update app routing
az aks approuting update -g MyResourceGroup -n MyCluster

# Enable kube metric scraper
az aks approuting update -g MyResourceGroup -n MyCluster \
  --enable-kube-metric-scraper
```

---

### az aks approuting zone add

Add DNS Zone(s) to App Routing.

```bash
az aks approuting zone add --resource-group MyResourceGroup --name MyManagedCluster --ids <zone-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--ids` | DNS zone resource IDs (space-separated) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Add DNS zone
az aks approuting zone add -g MyResourceGroup -n MyCluster \
  --ids /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/dnsZones/<zone>
```

---

### az aks approuting zone delete

Delete DNS Zone(s) from App Routing.

```bash
az aks approuting zone delete --resource-group MyResourceGroup --name MyManagedCluster --ids <zone-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--ids` | DNS zone resource IDs (space-separated) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Delete DNS zone
az aks approuting zone delete -g MyResourceGroup -n MyCluster --ids <zone-id>
```

---

### az aks approuting zone list

List DNS Zone IDs in App Routing.

```bash
az aks approuting zone list --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List DNS zones
az aks approuting zone list -g MyResourceGroup -n MyCluster
```

---

### az aks approuting zone update

Replace DNS Zone(s) in App Routing.

```bash
az aks approuting zone update --resource-group MyResourceGroup --name MyManagedCluster --ids <zone-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--ids` | DNS zone resource IDs (space-separated) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Replace DNS zones
az aks approuting zone update -g MyResourceGroup -n MyCluster --ids <zone-id>
```

---

### az aks approuting defaultdomain show

Show the Default Domain configuration for App Routing.

```bash
az aks approuting defaultdomain show --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show default domain
az aks approuting defaultdomain show -g MyResourceGroup -n MyCluster
```

---

## App Routing Gateway Commands

### az aks approuting gateway istio enable

Enable Gateway API based ingress on App Routing via Istio.

```bash
az aks approuting gateway istio enable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Enable Istio gateway
az aks approuting gateway istio enable -g MyResourceGroup -n MyCluster
```

---

### az aks approuting gateway istio disable

Disable Gateway API based ingress on App Routing via Istio.

```bash
az aks approuting gateway istio disable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Disable Istio gateway
az aks approuting gateway istio disable -g MyResourceGroup -n MyCluster
```

---

## Bastion Commands

### az aks bastion enable

Enable managed Azure Bastion host for a managed Kubernetes cluster.

```bash
az aks bastion enable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--vnet-subnet-id` | VNet subnet ID |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Enable bastion
az aks bastion enable -g MyResourceGroup -n MyCluster

# Enable with subnet
az aks bastion enable -g MyResourceGroup -n MyCluster \
  --vnet-subnet-id <subnet-id>
```

---

### az aks bastion disable

Disable managed Azure Bastion host.

```bash
az aks bastion disable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Disable bastion
az aks bastion disable -g MyResourceGroup -n MyCluster
```

---

### az aks bastion tunnel

Connect to a managed Kubernetes cluster using Azure Bastion.

```bash
az aks bastion tunnel --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--listen-port` | Listen port |
| `--listen-address` | Listen address |

**Examples:**

```bash
# Tunnel to cluster
az aks bastion tunnel -g MyResourceGroup -n MyCluster

# Custom port
az aks bastion tunnel -g MyResourceGroup -n MyCluster --listen-port 8080
```

---

### az aks bastion update

Update managed Azure Bastion host.

```bash
az aks bastion update --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--vnet-subnet-id` | VNet subnet ID |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Update bastion
az aks bastion update -g MyResourceGroup -n MyCluster
```

---

## Alert Config Commands

### az aks alert-config add

Add an alert configuration to a managed cluster.

```bash
az aks alert-config add --resource-group MyResourceGroup --name MyManagedCluster --alert-name <name> --action-group <action-group-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--alert-name` | Alert name (required) |
| `--action-group` | Action group resource ID (required) |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Add alert config
az aks alert-config add -g MyResourceGroup -n MyCluster \
  --alert-name "HighCPU" --action-group <action-group-id>
```

---

### az aks alert-config delete

Delete an alert configuration from a managed cluster.

```bash
az aks alert-config delete --resource-group MyResourceGroup --name MyManagedCluster --alert-name <name>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--alert-name` | Alert name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Delete alert config
az aks alert-config delete -g MyResourceGroup -n MyCluster --alert-name "HighCPU"
```

---

### az aks alert-config list

List the alert configurations of a managed cluster.

```bash
az aks alert-config list --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List alert configs
az aks alert-config list -g MyResourceGroup -n MyCluster
```

---

### az aks alert-config show

Show the details of an alert configuration.

```bash
az aks alert-config show --resource-group MyResourceGroup --name MyManagedCluster --alert-name <name>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--alert-name` | Alert name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show alert config
az aks alert-config show -g MyResourceGroup -n MyCluster --alert-name "HighCPU"
```

---

### az aks alert-config update

Update an alert configuration in a managed cluster.

```bash
az aks alert-config update --resource-group MyResourceGroup --name MyManagedCluster --alert-name <name> --action-group <action-group-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--alert-name` | Alert name (required) |
| `--action-group` | Action group resource ID |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Update alert config
az aks alert-config update -g MyResourceGroup -n MyCluster \
  --alert-name "HighCPU" --action-group <action-group-id>
```

---

## Extension Commands

### az aks extension create

Create a Cluster Extension instance on the managed cluster.

```bash
az aks extension create --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyExtension --extension-type <type>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Extension name (required) |
| `--extension-type` | Extension type (required) |
| `--scope` | Scope: `cluster`, `namespace` |
| `--release-namespace` | Release namespace |
| `--release-train` | Release train |
| `--version` | Extension version |
| `--configuration-settings` | Configuration settings |
| `--configuration-protected-settings` | Protected configuration settings |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Create extension
az aks extension create -g MyResourceGroup -c MyCluster \
  -n MyExtension --extension-type <type>

# Create with scope
az aks extension create -g MyResourceGroup -c MyCluster \
  -n MyExtension --extension-type <type> --scope cluster

# Create with version
az aks extension create -g MyResourceGroup -c MyCluster \
  -n MyExtension --extension-type <type> --version 1.0.0

# Create with configuration
az aks extension create -g MyResourceGroup -c MyCluster \
  -n MyExtension --extension-type <type> \
  --configuration-settings "key=value"
```

---

### az aks extension delete

Delete a Cluster Extension.

```bash
az aks extension delete --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyExtension
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Extension name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Delete extension
az aks extension delete -g MyResourceGroup -c MyCluster -n MyExtension
```

---

### az aks extension list

List Cluster Extensions.

```bash
az aks extension list --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List extensions
az aks extension list -g MyResourceGroup -c MyCluster
```

---

### az aks extension show

Show a Cluster Extension.

```bash
az aks extension show --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyExtension
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Extension name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show extension
az aks extension show -g MyResourceGroup -c MyCluster -n MyExtension
```

---

### az aks extension update

Update mutable properties of a Cluster Extension.

```bash
az aks extension update --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyExtension
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Extension name (required) |
| `--configuration-settings` | Configuration settings |
| `--configuration-protected-settings` | Protected configuration settings |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Update extension
az aks extension update -g MyResourceGroup -c MyCluster -n MyExtension

# Update with configuration
az aks extension update -g MyResourceGroup -c MyCluster -n MyExtension \
  --configuration-settings "key=value"
```

---

### az aks extension type list

List available Cluster Extension Types.

```bash
az aks extension type list --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--location -l` | Location |
| `--output -o` | Output format |

**Examples:**

```bash
# List extension types
az aks extension type list -g MyResourceGroup -c MyCluster
```

---

### az aks extension type show

Show properties for a Cluster Extension Type.

```bash
az aks extension type show --resource-group MyResourceGroup --cluster-name MyManagedCluster --extension-type <type>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--extension-type` | Extension type (required) |
| `--location -l` | Location |
| `--output -o` | Output format |

**Examples:**

```bash
# Show extension type
az aks extension type show -g MyResourceGroup -c MyCluster --extension-type <type>
```

---

### az aks extension type version list

List available Cluster Extension Type versions.

```bash
az aks extension type version list --resource-group MyResourceGroup --cluster-name MyManagedCluster --extension-type <type>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--extension-type` | Extension type (required) |
| `--location -l` | Location |
| `--output -o` | Output format |

**Examples:**

```bash
# List extension type versions
az aks extension type version list -g MyResourceGroup -c MyCluster \
  --extension-type <type>
```

---

### az aks extension type version show

Show properties for a Cluster Extension Type version.

```bash
az aks extension type version show --resource-group MyResourceGroup --cluster-name MyManagedCluster --extension-type <type> --version <version>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--extension-type` | Extension type (required) |
| `--version` | Version (required) |
| `--location -l` | Location |
| `--output -o` | Output format |

**Examples:**

```bash
# Show extension type version
az aks extension type version show -g MyResourceGroup -c MyCluster \
  --extension-type <type> --version 1.0.0
```

---

## Draft Commands

### az aks draft create

Generate a Dockerfile and minimum required Kubernetes deployment files.

```bash
az aks draft create --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--app` | Application name |
| `--language` | Language |
| `--create-config` | Create config file |
| `--destination` | Destination directory |

**Examples:**

```bash
# Create draft files
az aks draft create -g MyResourceGroup -c MyCluster

# Create with app name
az aks draft create -g MyResourceGroup -c MyCluster --app MyApp
```

---

### az aks draft generate-workflow

Generate a GitHub workflow for automatic build and deploy to AKS.

```bash
az aks draft generate-workflow --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--app` | Application name |
| `--branch` | Git branch |
| `--registry` | Container registry |
| `--destination` | Destination directory |

**Examples:**

```bash
# Generate workflow
az aks draft generate-workflow -g MyResourceGroup -c MyCluster
```

---

### az aks draft setup-gh

Set up GitHub OIDC for your application.

```bash
az aks draft setup-gh --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--app` | Application name |
| `--subscription-id` | Subscription ID |
| `--resource-group` | Resource group |

**Examples:**

```bash
# Setup GitHub OIDC
az aks draft setup-gh -g MyResourceGroup -c MyCluster
```

---

### az aks draft up

Run `az aks draft setup-gh` then `az aks draft generate-workflow`.

```bash
az aks draft up --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--app` | Application name |
| `--subscription-id` | Subscription ID |
| `--branch` | Git branch |
| `--registry` | Container registry |

**Examples:**

```bash
# Run draft up
az aks draft up -g MyResourceGroup -c MyCluster
```

---

### az aks draft update

Update your application to be internet accessible.

```bash
az aks draft update --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--app` | Application name |
| `--host` | Host name |
| `--certificate` | Certificate |

**Examples:**

```bash
# Update draft
az aks draft update -g MyResourceGroup -c MyCluster
```

---

## Agent Commands

### az aks agent

Run AI assistant to analyze and troubleshoot AKS clusters.

```bash
az aks agent --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--query` | Query for the AI assistant |

**Examples:**

```bash
# Run agent
az aks agent -g MyResourceGroup -n MyCluster

# Run with query
az aks agent -g MyResourceGroup -n MyCluster --query "Why is my pod pending?"
```

---

### az aks agent-init

Initialize AKS agent helm deployment.

```bash
az aks agent-init --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--llm-endpoint` | LLM endpoint |
| `--llm-api-key` | LLM API key |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Initialize agent
az aks agent-init -g MyResourceGroup -n MyCluster
```

---

### az aks agent-cleanup

Cleanup and uninstall the AKS agent.

```bash
az aks agent-cleanup --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Cleanup agent
az aks agent-cleanup -g MyResourceGroup -n MyCluster
```

---

## Connection Commands (Preview)

### az aks connection create

Create a connection between an AKS cluster and a target resource.

```bash
az aks connection create --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyConnection --target-resource-id <target-id>
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Connection name (required) |
| `--target-resource-id` | Target resource ID (required) |
| `--client-type` | Client type: `python`, `dotnet`, `java`, `nodejs`, `go`, `php`, `ruby`, `springBoot`, `kafka`, `django`, `fastapi` |
| `--auth-type` | Auth type: `secret`, `systemAssignedIdentity`, `userAssignedIdentity`, `servicePrincipalSecret` |
| `--secret` | Secret |
| `--scope` | Scope |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Create connection
az aks connection create -g MyResourceGroup -c MyCluster \
  -n MyConnection --target-resource-id <target-id>

# Create with client type
az aks connection create -g MyResourceGroup -c MyCluster \
  -n MyConnection --target-resource-id <target-id> --client-type python
```

---

### az aks connection delete

Delete an AKS connection.

```bash
az aks connection delete --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyConnection
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Connection name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Delete connection
az aks connection delete -g MyResourceGroup -c MyCluster -n MyConnection
```

---

### az aks connection list

List connections of an AKS cluster.

```bash
az aks connection list --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List connections
az aks connection list -g MyResourceGroup -c MyCluster
```

---

### az aks connection show

Get the details of an AKS connection.

```bash
az aks connection show --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyConnection
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Connection name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# Show connection
az aks connection show -g MyResourceGroup -c MyCluster -n MyConnection
```

---

### az aks connection update

Update an AKS connection.

```bash
az aks connection update --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyConnection
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Connection name (required) |
| `--client-type` | Client type |
| `--auth-type` | Auth type |
| `--secret` | Secret |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Update connection
az aks connection update -g MyResourceGroup -c MyCluster -n MyConnection
```

---

### az aks connection validate

Validate an AKS connection.

```bash
az aks connection validate --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyConnection
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Connection name (required) |

**Examples:**

```bash
# Validate connection
az aks connection validate -g MyResourceGroup -c MyCluster -n MyConnection
```

---

### az aks connection wait

Wait for an AKS connection to reach a desired state.

```bash
az aks connection wait --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyConnection --created
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Connection name (required) |
| `--created` | Wait until created |
| `--updated` | Wait until updated |
| `--deleted` | Wait until deleted |
| `--exists` | Wait until exists |
| `--custom` | Custom JMESPath condition |
| `--interval` | Polling interval |
| `--timeout` | Max wait time |

**Examples:**

```bash
# Wait for connection
az aks connection wait -g MyResourceGroup -c MyCluster -n MyConnection --created
```

---

### az aks connection list-configuration

List source configurations of an AKS connection.

```bash
az aks connection list-configuration --resource-group MyResourceGroup --cluster-name MyManagedCluster --name MyConnection
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--name -n` | Connection name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List connection configurations
az aks connection list-configuration -g MyResourceGroup -c MyCluster -n MyConnection
```

---

### az aks connection list-support-types

List client types and auth types supported by AKS connections.

```bash
az aks connection list-support-types --resource-group MyResourceGroup --cluster-name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--cluster-name` | Cluster name (required) |
| `--output -o` | Output format |

**Examples:**

```bash
# List supported types
az aks connection list-support-types -g MyResourceGroup -c MyCluster
```

---

## Application Load Balancer Commands

### az aks applicationloadbalancer enable

Enable Application Load Balancer (Application Gateway for Containers) addon.

```bash
az aks applicationloadbalancer enable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--appgw-name` | Application Gateway name |
| `--appgw-subnet-cidr` | App Gateway subnet CIDR |
| `--appgw-subnet-id` | App Gateway subnet ID |
| `--appgw-watch-namespace` | App Gateway watch namespace |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Enable ALB
az aks applicationloadbalancer enable -g MyResourceGroup -n MyCluster

# Enable with App Gateway
az aks applicationloadbalancer enable -g MyResourceGroup -n MyCluster \
  --appgw-name MyAppGateway
```

---

### az aks applicationloadbalancer disable

Disable Application Load Balancer addon.

```bash
az aks applicationloadbalancer disable --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--yes -y` | Do not prompt for confirmation |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Disable ALB
az aks applicationloadbalancer disable -g MyResourceGroup -n MyCluster
```

---

### az aks applicationloadbalancer update

Update Application Load Balancer addon.

```bash
az aks applicationloadbalancer update --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--appgw-name` | Application Gateway name |
| `--appgw-subnet-cidr` | App Gateway subnet CIDR |
| `--appgw-subnet-id` | App Gateway subnet ID |
| `--appgw-watch-namespace` | App Gateway watch namespace |
| `--no-wait` | Do not wait for completion |

**Examples:**

```bash
# Update ALB
az aks applicationloadbalancer update -g MyResourceGroup -n MyCluster
```

---

## App Commands (Preview)

### az aks app up

Deploy to AKS via GitHub actions.

```bash
az aks app up --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--app` | Application name |
| `--subscription-id` | Subscription ID |
| `--branch` | Git branch |
| `--registry` | Container registry |

**Examples:**

```bash
# Deploy app
az aks app up -g MyResourceGroup -n MyCluster
```

---

## Dev Spaces Commands

### az aks use-dev-spaces

Use Azure Dev Spaces with a managed Kubernetes cluster.

```bash
az aks use-dev-spaces --resource-group MyResourceGroup --name MyManagedCluster
```

**Key Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--resource-group -g` | Resource group name (required) |
| `--name -n` | Cluster name (required) |
| `--space -s` | Dev space name |
| `--endpoint -e` | Endpoint type: `Public`, `Private` |
| `--update` | Update to latest client components |
| `--yes -y` | Do not prompt for confirmation |

**Examples:**

```bash
# Use dev spaces
az aks use-dev-spaces -g MyResourceGroup -n MyCluster

# Use specific space
az aks use-dev-spaces -g MyResourceGroup -n MyCluster -s MySpace

# Use private endpoint
az aks use-dev-spaces -g MyResourceGroup -n MyCluster -e Private
```

---

## Related Notes

- [[AKS Commands - Index]]
- [[AKS Commands - PowerShell]]
- [[Azure CLI Reference]]
- [[Kubernetes Commands]]
