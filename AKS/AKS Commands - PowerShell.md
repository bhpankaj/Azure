---
title: AKS Commands - PowerShell
description: Complete reference for all Az.Aks PowerShell cmdlets with parameters and examples
tags: [azure, powershell, aks, kubernetes]
created: 2026-10-08
---

# AKS Commands - PowerShell

Complete reference for `Az.Aks` PowerShell module cmdlets.

## Module Installation

```powershell
Install-Module -Name Az.Aks -Scope CurrentUser -Repository PSGallery -Force
Import-Module Az.Aks
Connect-AzAccount
Get-Command -Module Az.Aks
```

## Common Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Name of resource group |
| `-Name` | String | Name of the managed cluster |
| `-ClusterName` | String | Name of the cluster (for nodepool cmdlets) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

---

## Cluster Lifecycle

### New-AzAksCluster

Create a new managed Kubernetes cluster.

```powershell
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster" -NodeCount 3 -GenerateSshKey
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-NodeCount` | Int32 | Number of nodes (default: 3) |
| `-NodeVmSize` | String | VM size (default: `standard_ds2_v2`) |
| `-KubernetesVersion` | String | Kubernetes version |
| `-GenerateSshKey` | Switch | Generate SSH key pair |
| `-AdminUsername` | String | Admin username (default: `azureuser`) |
| `-DnsNamePrefix` | String | DNS name prefix |
| `-Location` | String | Location |
| `-LoadBalancerSku` | String | `basic` or `standard` |
| `-VmSetType` | String | `VirtualMachineScaleSets` or `AvailabilitySet` |
| `-NetworkPlugin` | String | `azure`, `kubenet`, `none` |
| `-NetworkPolicy` | String | `azure`, `calico` |
| `-MaxPods` | Int32 | Max pods per node (default: 110) |
| `-NodeOSDiskSize` | Int32 | OS disk size in GB |
| `-NodeOSDiskType` | String | `Managed`, `Ephemeral` |
| `-EnableClusterAutoscaler` | Switch | Enable cluster autoscaler |
| `-MinCount` | Int32 | Min nodes for autoscaler |
| `-MaxCount` | Int32 | Max nodes for autoscaler |
| `-EnableAddons` | String | Enable addons (comma-separated) |
| `-DisableRbac` | Switch | Disable RBAC |
| `-EnableRbac` | Switch | Enable RBAC (default) |
| `-AadClientAppId` | String | AAD client app ID |
| `-AadServerAppId` | String | AAD server app ID |
| `-AadServerAppSecret` | String | AAD server app secret |
| `-AadTenantId` | String | AAD tenant ID |
| `-ServicePrincipal` | String | Service principal client ID |
| `-ClientSecret` | String | Service principal client secret |
| `-Tag` | Hashtable | Tags (key=value) |
| `-Zone` | String[] | Availability zones |
| `-VnetSubnetId` | String | VNet subnet ID |
| `-PodCidr` | String | Pod CIDR |
| `-ServiceCidr` | String | Service CIDR |
| `-DnsServiceIp` | String | DNS service IP |
| `-DockerBridgeAddress` | String | Docker bridge address |
| `-OutboundType` | String | `loadBalancer`, `userDefinedRouting`, `managedNATGateway`, `userAssignedNATGateway` |
| `-EnableManagedIdentity` | Switch | Enable managed identity |
| `-AssignIdentity` | String | User-assigned identity resource ID |
| `-AttachAcr` | String | Attach ACR by name or ID |
| `-EnablePrivateCluster` | Switch | Enable private cluster |
| `-PrivateDnsZone` | String | Private DNS zone |
| `-FqdnSubdomain` | String | FQDN subdomain |
| `-ApiServerAuthorizedIpRanges` | String | API server authorized IP ranges |
| `-DisableLocalAccounts` | Switch | Disable local accounts |
| `-EnableOidcIssuer` | Switch | Enable OIDC issuer |
| `-EnableWorkloadIdentity` | Switch | Enable workload identity |
| `-EnableEncryptionAtHost` | Switch | Enable encryption at host |
| `-EnableUltraSsd` | Switch | Enable Ultra SSD |
| `-EnableAzureKeyvaultKms` | Switch | Enable Azure Key Vault KMS |
| `-EnableImageCleaner` | Switch | Enable image cleaner |
| `-ImageCleanerIntervalHours` | Int32 | Image cleaner interval |
| `-EnableDefender` | Switch | Enable Microsoft Defender |
| `-DefenderConfigFile` | String | Defender config file path |
| `-EnableKeda` | Switch | Enable KEDA |
| `-EnableVpa` | Switch | Enable VPA |
| `-EnableAzureMonitorMetrics` | Switch | Enable Azure Monitor metrics |
| `-WorkspaceResourceId` | String | Log Analytics workspace resource ID |
| `-EnableSyslog` | Switch | Enable syslog |
| `-DataCollectionSettings` | String | Data collection settings file |
| `-EnableAppRouting` | Switch | Enable app routing |
| `-EnableAsm` | Switch | Enable Azure Service Mesh |
| `-Revision` | String | Service mesh revision |
| `-EnableCostAnalysis` | Switch | Enable cost analysis |
| `-NodeResourceGroup` | String | Node resource group |
| `-EnableCustomCaTrust` | Switch | Enable custom CA trust |
| `-CaCertificates` | String | Custom CA certificates file |
| `-EnableRunCommand` | Switch | Enable run command |
| `-DisableRunCommand` | Switch | Disable run command |
| `-EnableAcns` | Switch | Enable ACNS |
| `-AcnsAdvancedNetworkpolicies` | String | ACNS advanced network policies |
| `-AcnsTransparentEncryption` | Switch | ACNS transparent encryption |
| `-AcnsObservability` | Switch | ACNS observability |
| `-EnableCiliumDatapath` | Switch | Enable Cilium datapath |
| `-EnableNetworkObservability` | Switch | Enable network observability |
| `-EnableFqdnPolicy` | Switch | Enable FQDN policy |
| `-EnableSecurityPolicy` | Switch | Enable security policy |
| `-EnableTrustedLaunch` | Switch | Enable trusted launch |
| `-EnableConfidentialComputing` | Switch | Enable confidential computing |
| `-EnableVmBackup` | Switch | Enable VM backup |
| `-EnableElasticSan` | Switch | Enable Elastic SAN |
| `-EnableStaticEgressGateway` | Switch | Enable static egress gateway |
| `-EnableTelemetry` | Switch | Enable telemetry |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Basic cluster
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NodeCount 3 -GenerateSshKey

# Cluster with specific Kubernetes version
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -KubernetesVersion "1.28.0"

# Cluster with autoscaler
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NodeCount 3 -EnableClusterAutoscaler -MinCount 1 -MaxCount 5

# Cluster with managed identity
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableManagedIdentity

# Private cluster
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnablePrivateCluster -EnableManagedIdentity

# Cluster with Azure CNI
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NetworkPlugin azure -PodCidr "10.244.0.0/16" -ServiceCidr "10.0.0.0/16" -DnsServiceIp "10.0.0.10" -DockerBridgeAddress "172.17.0.1/16"

# Cluster with GPU nodes
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NodeVmSize "Standard_NC6s_v3" -NodeCount 3

# Cluster with availability zones
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Zone 1,2,3

# Cluster with Azure Policy addon
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAddons "azure-policy"

# Cluster with monitoring
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAddons "monitoring" -WorkspaceResourceId "<workspace-id>"

# Cluster with app routing
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAppRouting

# Cluster with Azure Service Mesh
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAsm

# Cluster with encryption at host
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableEncryptionAtHost

# Cluster with Ultra SSD
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableUltraSsd

# Cluster with custom VNet
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -VnetSubnetId "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>"

# Cluster with outbound NAT gateway
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -OutboundType userAssignedNATGateway

# Cluster with static egress gateway
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableStaticEgressGateway

# Cluster with confidential computing
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableConfidentialComputing

# Cluster with VM backup
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableVmBackup

# Cluster with Elastic SAN
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableElasticSan

# Cluster with trusted launch
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableTrustedLaunch

# Cluster with custom CA trust
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableCustomCaTrust

# Cluster with run command disabled
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableRunCommand

# Cluster with ACNS
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAcns

# Cluster with Cilium datapath
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableCiliumDatapath

# Cluster with network observability
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableNetworkObservability

# Cluster with FQDN policy
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableFqdnPolicy

# Cluster with security policy
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableSecurityPolicy

# Cluster with telemetry
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableTelemetry

# Cluster with cost analysis
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableCostAnalysis

# Cluster with image cleaner
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableImageCleaner -ImageCleanerIntervalHours 24

# Cluster with KEDA
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableKeda

# Cluster with VPA
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableVpa

# Cluster with Defender
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableDefender

# Cluster with Azure Key Vault KMS
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAzureKeyvaultKms

# Cluster with workload identity
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableWorkloadIdentity

# Cluster with OIDC issuer
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableOidcIssuer

# Cluster with local accounts disabled
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableLocalAccounts

# Cluster with API server authorized IP ranges
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ApiServerAuthorizedIpRanges "203.0.113.0/24"

# Cluster with custom DNS prefix
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DnsNamePrefix "mycluster-dns"

# Cluster with tags
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Tag @{environment="production"; team="devops"}

# Cluster with node resource group
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NodeResourceGroup "MyNodeResourceGroup"

# Cluster with syslog
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableSyslog -DataCollectionSettings "<settings-file>"

# Cluster with Azure Monitor metrics
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAzureMonitorMetrics

# Cluster with ephemeral OS disk
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NodeOSDiskType Ephemeral -NodeOSDiskSize 128

# Cluster with specific OS disk size
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NodeOSDiskSize 256

# Cluster with max pods
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -MaxPods 250

# Cluster with kubenet network plugin
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NetworkPlugin kubenet

# Cluster with calico network policy
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NetworkPolicy calico

# Cluster with no network policy
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NetworkPolicy none

# Cluster with basic load balancer
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -LoadBalancerSku basic

# Cluster with standard load balancer
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -LoadBalancerSku standard

# Cluster with availability set VM type
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -VmSetType AvailabilitySet

# Cluster with VMSS VM type
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -VmSetType VirtualMachineScaleSets

# Cluster with user-defined routing
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -OutboundType userDefinedRouting

# Cluster with managed NAT gateway
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -OutboundType managedNATGateway

# Cluster with AAD integration
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AadClientAppId "<client-app-id>" -AadServerAppId "<server-app-id>" -AadServerAppSecret "<server-app-secret>" -AadTenantId "<tenant-id>"

# Cluster with service principal
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ServicePrincipal "<sp-id>" -ClientSecret "<secret>"

# Cluster with SSH key
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -SshKeyValue "~/.ssh/id_rsa.pub"

# Cluster with admin username
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AdminUsername "myadmin"

# Cluster with location
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Location "eastus"

# Cluster with no-wait
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NoWait

# Cluster with force
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Force

# Cluster as job
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Cluster with WhatIf
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Cluster with Confirm
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Cluster with default profile
New-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Remove-AzAksCluster

Delete a managed Kubernetes cluster.

```powershell
Remove-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Delete cluster
Remove-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Delete without confirmation
Remove-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Force

# Delete as job
Remove-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Delete with WhatIf
Remove-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Delete with Confirm
Remove-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Delete with default profile
Remove-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Get-AzAksCluster

List Kubernetes managed clusters.

```powershell
Get-AzAksCluster
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Filter by resource group |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# List all clusters
Get-AzAksCluster

# List clusters in resource group
Get-AzAksCluster -ResourceGroupName "MyResourceGroup"

# List with default profile
Get-AzAksCluster -DefaultProfile $context

# List and format as table
Get-AzAksCluster | Format-Table Name, Location, KubernetesVersion

# List and select specific properties
Get-AzAksCluster | Select-Object Name, Location, KubernetesVersion, ProvisioningState

# List and export to CSV
Get-AzAksCluster | Export-Csv -Path "clusters.csv" -NoTypeInformation

# List and filter by location
Get-AzAksCluster | Where-Object { $_.Location -eq "eastus" }

# List and sort by name
Get-AzAksCluster | Sort-Object Name

# List and count
(Get-AzAksCluster).Count

# List and get first cluster
Get-AzAksCluster | Select-Object -First 1

# List and get last cluster
Get-AzAksCluster | Select-Object -Last 1

# List and get specific cluster
Get-AzAksCluster | Where-Object { $_.Name -eq "MyCluster" }

# List and get clusters with specific Kubernetes version
Get-AzAksCluster | Where-Object { $_.KubernetesVersion -eq "1.28.0" }

# List and get clusters with specific provisioning state
Get-AzAksCluster | Where-Object { $_.ProvisioningState -eq "Succeeded" }

# List and get clusters with specific node count
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].Count -eq 3 }

# List and get clusters with specific VM size
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].VmSize -eq "standard_ds2_v2" }

# List and get clusters with specific network plugin
Get-AzAksCluster | Where-Object { $_.NetworkProfile.NetworkPlugin -eq "azure" }

# List and get clusters with specific load balancer SKU
Get-AzAksCluster | Where-Object { $_.NetworkProfile.LoadBalancerSku -eq "standard" }

# List and get clusters with specific outbound type
Get-AzAksCluster | Where-Object { $_.NetworkProfile.OutboundType -eq "loadBalancer" }

# List and get clusters with specific API server access profile
Get-AzAksCluster | Where-Object { $_.ApiServerAccessProfile.EnablePrivateCluster -eq $true }

# List and get clusters with specific identity
Get-AzAksCluster | Where-Object { $_.Identity.Type -eq "SystemAssigned" }

# List and get clusters with specific addon
Get-AzAksCluster | Where-Object { $_.AddonProfiles.Keys -contains "monitoring" }

# List and get clusters with specific tag
Get-AzAksCluster | Where-Object { $_.Tags["environment"] -eq "production" }

# List and get clusters with specific DNS prefix
Get-AzAksCluster | Where-Object { $_.DnsPrefix -eq "mycluster-dns" }

# List and get clusters with specific node resource group
Get-AzAksCluster | Where-Object { $_.NodeResourceGroup -eq "MyNodeResourceGroup" }

# List and get clusters with specific auto scaler profile
Get-AzAksCluster | Where-Object { $_.AutoScalerProfile.EnableClusterAutoscaler -eq $true }

# List and get clusters with specific auto upgrade profile
Get-AzAksCluster | Where-Object { $_.AutoUpgradeProfile.UpgradeChannel -eq "stable" }

# List and get clusters with specific power state
Get-AzAksCluster | Where-Object { $_.PowerState.Code -eq "Running" }

# List and get clusters with specific provisioning state
Get-AzAksCluster | Where-Object { $_.ProvisioningState -eq "Failed" }

# List and get clusters with specific creation time
Get-AzAksCluster | Where-Object { $_.CreationTime -gt (Get-Date).AddDays(-30) }

# List and get clusters with specific Kubernetes version
Get-AzAksCluster | Where-Object { $_.KubernetesVersion -like "1.28*" }

# List and get clusters with specific location
Get-AzAksCluster | Where-Object { $_.Location -eq "westus2" }

# List and get clusters with specific resource group
Get-AzAksCluster | Where-Object { $_.ResourceGroup -eq "MyResourceGroup" }

# List and get clusters with specific name
Get-AzAksCluster | Where-Object { $_.Name -like "*prod*" }

# List and get clusters with specific tag value
Get-AzAksCluster | Where-Object { $_.Tags["team"] -eq "devops" }

# List and get clusters with specific addon profile
Get-AzAksCluster | Where-Object { $_.AddonProfiles["monitoring"].Enabled -eq $true }

# List and get clusters with specific network profile
Get-AzAksCluster | Where-Object { $_.NetworkProfile.NetworkPolicy -eq "azure" }

# List and get clusters with specific API server access profile
Get-AzAksCluster | Where-Object { $_.ApiServerAccessProfile.AuthorizedIpRanges -contains "203.0.113.0/24" }

# List and get clusters with specific identity profile
Get-AzAksCluster | Where-Object { $_.IdentityProfile.kubeletidentity -ne $null }

# List and get clusters with specific service principal profile
Get-AzAksCluster | Where-Object { $_.ServicePrincipalProfile.ClientId -eq "msi" }

# List and get clusters with specific agent pool profile
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].Mode -eq "System" }

# List and get clusters with specific OS type
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].OsType -eq "Linux" }

# List and get clusters with specific OS SKU
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].OsSku -eq "Ubuntu" }

# List and get clusters with specific max pods
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].MaxPods -eq 110 }

# List and get clusters with specific node OS disk size
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].OsDiskSizeGB -eq 128 }

# List and get clusters with specific node OS disk type
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].OsDiskType -eq "Managed" }

# List and get clusters with specific VM set type
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].Type -eq "VirtualMachineScaleSets" }

# List and get clusters with specific availability zones
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].AvailabilityZones -contains "1" }

# List and get clusters with specific max surge
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].UpgradeSettings.MaxSurge -eq "1" }

# List and get clusters with specific scale down mode
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].ScaleDownMode -eq "Delete" }

# List and get clusters with specific node labels
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].NodeLabels["env"] -eq "prod" }

# List and get clusters with specific node taints
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].NodeTaints -contains "key1=value1:NoSchedule" }

# List and get clusters with specific tags
Get-AzAksCluster | Where-Object { $_.Tags["environment"] -eq "production" }

# List and get clusters with specific kubelet config
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].KubeletConfig.cpuCfsQuota -eq $true }

# List and get clusters with specific Linux OS config
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].LinuxOsConfig.SwapFileSizeMB -eq 1024 }

# List and get clusters with specific Windows config
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].WindowsProfile.AdminUsername -eq "azureuser" }

# List and get clusters with specific encryption at host
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].EncryptionAtHost -eq $true }

# List and get clusters with specific Ultra SSD
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].UltraSsdEnabled -eq $true }

# List and get clusters with specific FIPS image
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].EnableFips -eq $true }

# List and get clusters with specific public IP
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].EnableNodePublicIp -eq $true }

# List and get clusters with specific spot priority
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].ScaleSetPriority -eq "Spot" }

# List and get clusters with specific eviction policy
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].ScaleSetEvictionPolicy -eq "Delete" }

# List and get clusters with specific spot max price
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].SpotMaxPrice -eq 0.5 }

# List and get clusters with specific proximity placement group
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].ProximityPlacementGroupId -eq "<ppg-id>" }

# List and get clusters with specific orchestrator version
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].OrchestratorVersion -eq "1.28.0" }

# List and get clusters with specific current orchestrator version
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].CurrentOrchestratorVersion -eq "1.28.0" }

# List and get clusters with specific node image version
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].NodeImageVersion -eq "AKSUbuntu-1804gen2containerd-2023.08.09" }

# List and get clusters with specific VM ID
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].VmId -eq "<vm-id>" }

# List and get clusters with specific VM name
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].VmName -eq "<vm-name>" }

# List and get clusters with specific VM size properties
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].VmSizeProperties.vCPUsAvailable -eq 4 }

# List and get clusters with specific data disks
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].DataDisks.Count -gt 0 }

# List and get clusters with specific extensions
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].Extensions.Count -gt 0 }

# List and get clusters with specific hosted profile
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].HostedProfile -ne $null }

# List and get clusters with specific artifact streaming
Get-AzAksCluster | Where-Object { $_.AgentPoolProfiles[0].ArtifactStreamingProfile -ne $null }

# List and get clusters with specific security profile
Get-AzAksCluster | Where-Object { $_.SecurityProfile -ne $null }

# List and get clusters with specific mesh profile
Get-AzAksCluster | Where-Object { $_.MeshProfile -ne $null }

# List and get clusters with specific metrics profile
Get-AzAksCluster | Where-Object { $_.MetricsProfile -ne $null }

# List and get clusters with specific AI toolchain operator
Get-AzAksCluster | Where-Object { $_.AiToolchainOperatorProfile -ne $null }

# List and get clusters with specific scheduler profile
Get-AzAksCluster | Where-Object { $_.SchedulerProfile -ne $null }

# List and get clusters with specific certificate profile
Get-AzAksCluster | Where-Object { $_.CertificateProfile -ne $null }

# List and get clusters with specific extensions profile
Get-AzAksCluster | Where-Object { $_.ExtensionsProfile -ne $null }

# List and get clusters with specific egress profile
Get-AzAksCluster | Where-Object { $_.EgressProfile -ne $null }

# List and get clusters with specific security posture
Get-AzAksCluster | Where-Object { $_.SecurityPosture -ne $null }

# List and get clusters with specific guardrails profile
Get-AzAksCluster | Where-Object { $_.GuardrailsProfile -ne $null }

# List and get clusters with specific policy profile
Get-AzAksCluster | Where-Object { $_.PolicyProfile -ne $null }

# List and get clusters with specific observability profile
Get-AzAksCluster | Where-Object { $_.ObservabilityProfile -ne $null }

# List and get clusters with specific cost analysis
Get-AzAksCluster | Where-Object { $_.CostAnalysis -ne $null }

# List and get clusters with specific metrics
Get-AzAksCluster | Where-Object { $_.Metrics -ne $null }

# List and get clusters with specific identity binding
Get-AzAksCluster | Where-Object { $_.IdentityBinding -ne $null }

# List and get clusters with specific snapshot
Get-AzAksCluster | Where-Object { $_.Snapshot -ne $null }

# List and get clusters with specific managed cluster snapshot
Get-AzAksCluster | Where-Object { $_.ManagedClusterSnapshot -ne $null }

# List and get clusters with specific agent pool
Get-AzAksCluster | Where-Object { $_.AgentPool -ne $null }

# List and get clusters with specific maintenance configuration
Get-AzAksCluster | Where-Object { $_.MaintenanceConfiguration -ne $null }

# List and get clusters with specific upgrade profile
Get-AzAksCluster | Where-Object { $_.UpgradeProfile -ne $null }

# List and get clusters with specific version
Get-AzAksCluster | Where-Object { $_.Version -ne $null }

# List and get clusters with specific node pool upgrade profile
Get-AzAksCluster | Where-Object { $_.NodePoolUpgradeProfile -ne $null }

# List and get clusters with specific outbound network dependency endpoint
Get-AzAksCluster | Where-Object { $_.OutboundNetworkDependencyEndpoint -ne $null }

# List and get clusters with specific OS option
Get-AzAksCluster | Where-Object { $_.OsOption -ne $null }

# List and get clusters with specific command result
Get-AzAksCluster | Where-Object { $_.CommandResult -ne $null }

# List and get clusters with specific abort operation
Get-AzAksCluster | Where-Object { $_.AbortOperation -ne $null }

# List and get clusters with specific rotate service account signing key
Get-AzAksCluster | Where-Object { $_.RotateServiceAccountSigningKey -ne $null }

# List and get clusters with specific run command
Get-AzAksCluster | Where-Object { $_.RunCommand -ne $null }

# List and get clusters with specific dashboard
Get-AzAksCluster | Where-Object { $_.Dashboard -ne $null }

# List and get clusters with specific cluster credential
Get-AzAksCluster | Where-Object { $_.ClusterCredential -ne $null }

# List and get clusters with specific addon
Get-AzAksCluster | Where-Object { $_.Addon -ne $null }

# List and get clusters with specific time in week
Get-AzAksCluster | Where-Object { $_.TimeInWeek -ne $null }

# List and get clusters with specific time span
Get-AzAksCluster | Where-Object { $_.TimeSpan -ne $null }
```

---

### Set-AzAksCluster

Update or create a managed Kubernetes cluster.

```powershell
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-EnableClusterAutoscaler` | Switch | Enable cluster autoscaler |
| `-DisableClusterAutoscaler` | Switch | Disable cluster autoscaler |
| `-UpdateClusterAutoscaler` | Switch | Update cluster autoscaler |
| `-MinCount` | Int32 | Min nodes for autoscaler |
| `-MaxCount` | Int32 | Max nodes for autoscaler |
| `-LoadBalancerManagedOutboundIpCount` | Int32 | Managed outbound IP count |
| `-LoadBalancerOutboundIps` | String[] | Outbound IPs |
| `-LoadBalancerOutboundIpPrefixes` | String[] | Outbound IP prefixes |
| `-LoadBalancerIdleTimeout` | Int32 | Idle timeout in minutes |
| `-LoadBalancerBackendPoolType` | String | Backend pool type |
| `-NatGatewayManagedOutboundIpCount` | Int32 | NAT gateway managed outbound IP count |
| `-NatGatewayIdleTimeout` | Int32 | NAT gateway idle timeout |
| `-AttachAcr` | String | Attach ACR |
| `-DetachAcr` | String | Detach ACR |
| `-EnableLocalAccounts` | Switch | Enable local accounts |
| `-DisableLocalAccounts` | Switch | Disable local accounts |
| `-EnablePublicFqdn` | Switch | Enable public FQDN |
| `-DisablePublicFqdn` | Switch | Disable public FQDN |
| `-ApiServerAuthorizedIpRanges` | String | API server authorized IP ranges |
| `-EnableOidcIssuer` | Switch | Enable OIDC issuer |
| `-DisableOidcIssuer` | Switch | Disable OIDC issuer |
| `-EnableWorkloadIdentity` | Switch | Enable workload identity |
| `-DisableWorkloadIdentity` | Switch | Disable workload identity |
| `-EnableManagedIdentity` | Switch | Enable managed identity |
| `-DisableManagedIdentity` | Switch | Disable managed identity |
| `-EnableAzureKeyvaultKms` | Switch | Enable Azure Key Vault KMS |
| `-DisableAzureKeyvaultKms` | Switch | Disable Azure Key Vault KMS |
| `-AzureKeyvaultKmsKeyId` | String | Key ID |
| `-AzureKeyvaultKmsKeyVaultNetworkAccess` | String | Key vault network access |
| `-AzureKeyvaultKmsKeyVaultResourceId` | String | Key vault resource ID |
| `-EnableImageCleaner` | Switch | Enable image cleaner |
| `-DisableImageCleaner` | Switch | Disable image cleaner |
| `-ImageCleanerIntervalHours` | Int32 | Image cleaner interval |
| `-EnableDefender` | Switch | Enable Defender |
| `-DisableDefender` | Switch | Disable Defender |
| `-DefenderConfigFile` | String | Defender config file |
| `-EnableKeda` | Switch | Enable KEDA |
| `-DisableKeda` | Switch | Disable KEDA |
| `-EnableVpa` | Switch | Enable VPA |
| `-DisableVpa` | Switch | Disable VPA |
| `-EnableAzureMonitorMetrics` | Switch | Enable Azure Monitor metrics |
| `-DisableAzureMonitorMetrics` | Switch | Disable Azure Monitor metrics |
| `-WorkspaceResourceId` | String | Workspace resource ID |
| `-EnableSyslog` | Switch | Enable syslog |
| `-DisableSyslog` | Switch | Disable syslog |
| `-DataCollectionSettings` | String | Data collection settings |
| `-EnableCostAnalysis` | Switch | Enable cost analysis |
| `-DisableCostAnalysis` | Switch | Disable cost analysis |
| `-EnableAcns` | Switch | Enable ACNS |
| `-DisableAcns` | Switch | Disable ACNS |
| `-AcnsAdvancedNetworkpolicies` | String | ACNS advanced network policies |
| `-AcnsTransparentEncryption` | Switch | ACNS transparent encryption |
| `-AcnsObservability` | Switch | ACNS observability |
| `-EnableCiliumDatapath` | Switch | Enable Cilium datapath |
| `-DisableCiliumDatapath` | Switch | Disable Cilium datapath |
| `-EnableNetworkObservability` | Switch | Enable network observability |
| `-DisableNetworkObservability` | Switch | Disable network observability |
| `-EnableFqdnPolicy` | Switch | Enable FQDN policy |
| `-DisableFqdnPolicy` | Switch | Disable FQDN policy |
| `-EnableSecurityPolicy` | Switch | Enable security policy |
| `-DisableSecurityPolicy` | Switch | Disable security policy |
| `-EnableTrustedLaunch` | Switch | Enable trusted launch |
| `-DisableTrustedLaunch` | Switch | Disable trusted launch |
| `-EnableConfidentialComputing` | Switch | Enable confidential computing |
| `-DisableConfidentialComputing` | Switch | Disable confidential computing |
| `-EnableVmBackup` | Switch | Enable VM backup |
| `-DisableVmBackup` | Switch | Disable VM backup |
| `-EnableElasticSan` | Switch | Enable Elastic SAN |
| `-DisableElasticSan` | Switch | Disable Elastic SAN |
| `-EnableStaticEgressGateway` | Switch | Enable static egress gateway |
| `-DisableStaticEgressGateway` | Switch | Disable static egress gateway |
| `-EnableTelemetry` | Switch | Enable telemetry |
| `-DisableTelemetry` | Switch | Disable telemetry |
| `-Tag` | Hashtable | Tags |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Enable autoscaler
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableClusterAutoscaler -MinCount 1 -MaxCount 5

# Disable autoscaler
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableClusterAutoscaler

# Update autoscaler
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -UpdateClusterAutoscaler -MinCount 2 -MaxCount 8

# Attach ACR
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AttachAcr "MyACR"

# Detach ACR
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DetachAcr "MyACR"

# Enable local accounts
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableLocalAccounts

# Disable local accounts
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableLocalAccounts

# Enable public FQDN
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnablePublicFqdn

# Disable public FQDN
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisablePublicFqdn

# Set API server authorized IP ranges
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ApiServerAuthorizedIpRanges "203.0.113.0/24"

# Enable OIDC issuer
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableOidcIssuer

# Disable OIDC issuer
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableOidcIssuer

# Enable workload identity
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableWorkloadIdentity

# Disable workload identity
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableWorkloadIdentity

# Enable managed identity
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableManagedIdentity

# Disable managed identity
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableManagedIdentity

# Enable Azure Key Vault KMS
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAzureKeyvaultKms -AzureKeyvaultKmsKeyId "<key-id>"

# Disable Azure Key Vault KMS
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableAzureKeyvaultKms

# Enable image cleaner
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableImageCleaner -ImageCleanerIntervalHours 24

# Disable image cleaner
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableImageCleaner

# Enable Defender
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableDefender -DefenderConfigFile "<config-file>"

# Disable Defender
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableDefender

# Enable KEDA
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableKeda

# Disable KEDA
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableKeda

# Enable VPA
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableVpa

# Disable VPA
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableVpa

# Enable Azure Monitor metrics
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAzureMonitorMetrics -WorkspaceResourceId "<workspace-id>"

# Disable Azure Monitor metrics
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableAzureMonitorMetrics

# Enable syslog
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableSyslog -DataCollectionSettings "<settings-file>"

# Disable syslog
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableSyslog

# Enable cost analysis
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableCostAnalysis

# Disable cost analysis
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableCostAnalysis

# Enable ACNS
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableAcns

# Disable ACNS
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableAcns

# Enable Cilium datapath
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableCiliumDatapath

# Disable Cilium datapath
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableCiliumDatapath

# Enable network observability
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableNetworkObservability

# Disable network observability
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableNetworkObservability

# Enable FQDN policy
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableFqdnPolicy

# Disable FQDN policy
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableFqdnPolicy

# Enable security policy
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableSecurityPolicy

# Disable security policy
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableSecurityPolicy

# Enable trusted launch
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableTrustedLaunch

# Disable trusted launch
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableTrustedLaunch

# Enable confidential computing
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableConfidentialComputing

# Disable confidential computing
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableConfidentialComputing

# Enable VM backup
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableVmBackup

# Disable VM backup
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableVmBackup

# Enable Elastic SAN
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableElasticSan

# Disable Elastic SAN
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableElasticSan

# Enable static egress gateway
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableStaticEgressGateway

# Disable static egress gateway
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableStaticEgressGateway

# Enable telemetry
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -EnableTelemetry

# Disable telemetry
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DisableTelemetry

# Update tags
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Tag @{environment="staging"; team="platform"}

# Update load balancer outbound IP count
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -LoadBalancerManagedOutboundIpCount 2

# Update load balancer idle timeout
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -LoadBalancerIdleTimeout 10

# Update NAT gateway managed outbound IP count
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NatGatewayManagedOutboundIpCount 2

# Update NAT gateway idle timeout
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NatGatewayIdleTimeout 10

# Update without waiting
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NoWait

# Update without confirmation
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Force

# Update as job
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Update with WhatIf
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Update with Confirm
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Update with default profile
Set-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Start-AzAksCluster

Start a managed Kubernetes cluster.

```powershell
Start-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Start cluster
Start-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Start without waiting
Start-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NoWait

# Start as job
Start-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Start with WhatIf
Start-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Start with Confirm
Start-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Start with default profile
Start-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Stop-AzAksCluster

Stop a managed Kubernetes cluster.

```powershell
Stop-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Stop cluster
Stop-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Stop without waiting
Stop-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NoWait

# Stop as job
Stop-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Stop with WhatIf
Stop-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Stop with Confirm
Stop-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Stop with default profile
Stop-AzAksCluster -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Get-AzAksUpgradeProfile

Gets the upgrade profile of a managed cluster.

```powershell
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Get upgrade profile
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Get upgrade profile with default profile
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context

# Get upgrade profile and format as table
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Format-Table

# Get upgrade profile and select properties
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object Name, ControlPlaneProfile, AgentPoolProfiles

# Get upgrade profile and export to JSON
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | ConvertTo-Json -Depth 10

# Get upgrade profile and save to file
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Out-File -FilePath "upgrade-profile.json"

# Get upgrade profile and get control plane profile
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile

# Get upgrade profile and get agent pool profiles
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles

# Get upgrade profile and get Kubernetes version
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty KubernetesVersion

# Get upgrade profile and get upgrades
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades

# Get upgrade profile and get agent pool upgrades
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Upgrades

# Get upgrade profile and get available upgrades
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades | Where-Object { $_.IsPreview -eq $false }

# Get upgrade profile and get preview upgrades
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades | Where-Object { $_.IsPreview -eq $true }

# Get upgrade profile and get latest upgrade
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades | Select-Object -First 1

# Get upgrade profile and get oldest upgrade
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades | Select-Object -Last 1

# Get upgrade profile and get upgrade count
(Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades).Count

# Get upgrade profile and get agent pool upgrade count
(Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Upgrades).Count

# Get upgrade profile and get upgrade versions
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty KubernetesVersion

# Get upgrade profile and get agent pool upgrade versions
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty KubernetesVersion

# Get upgrade profile and get upgrade preview status
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty IsPreview

# Get upgrade profile and get agent pool upgrade preview status
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty IsPreview

# Get upgrade profile and get upgrade component
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Component

# Get upgrade profile and get agent pool upgrade component
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Component

# Get upgrade profile and get upgrade name
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Name

# Get upgrade profile and get agent pool upgrade name
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Name

# Get upgrade profile and get upgrade type
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Type

# Get upgrade profile and get agent pool upgrade type
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Type

# Get upgrade profile and get upgrade provisioning state
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty ProvisioningState

# Get upgrade profile and get agent pool upgrade provisioning state
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty ProvisioningState

# Get upgrade profile and get upgrade created time
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty CreatedTime

# Get upgrade profile and get agent pool upgrade created time
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty CreatedTime

# Get upgrade profile and get upgrade last updated time
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty LastUpdatedTime

# Get upgrade profile and get agent pool upgrade last updated time
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty LastUpdatedTime

# Get upgrade profile and get upgrade etag
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Etag

# Get upgrade profile and get agent pool upgrade etag
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Etag

# Get upgrade profile and get upgrade id
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Id

# Get upgrade profile and get agent pool upgrade id
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Id

# Get upgrade profile and get upgrade location
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Location

# Get upgrade profile and get agent pool upgrade location
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Location

# Get upgrade profile and get upgrade tags
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Tags

# Get upgrade profile and get agent pool upgrade tags
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Tags

# Get upgrade profile and get upgrade zones
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Zones

# Get upgrade profile and get agent pool upgrade zones
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Zones

# Get upgrade profile and get upgrade sku
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Sku

# Get upgrade profile and get agent pool upgrade sku
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Sku

# Get upgrade profile and get upgrade identity
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Identity

# Get upgrade profile and get agent pool upgrade identity
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Identity

# Get upgrade profile and get upgrade extended location
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty ExtendedLocation

# Get upgrade profile and get agent pool upgrade extended location
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty ExtendedLocation

# Get upgrade profile and get upgrade system data
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty SystemData

# Get upgrade profile and get agent pool upgrade system data
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty SystemData

# Get upgrade profile and get upgrade kind
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Kind

# Get upgrade profile and get agent pool upgrade kind
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Kind

# Get upgrade profile and get upgrade managed by
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty ManagedBy

# Get upgrade profile and get agent pool upgrade managed by
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty ManagedBy

# Get upgrade profile and get upgrade plan
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Plan

# Get upgrade profile and get agent pool upgrade plan
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Plan

# Get upgrade profile and get upgrade properties
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty Properties

# Get upgrade profile and get agent pool upgrade properties
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty Properties

# Get upgrade profile and get upgrade additional properties
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty ControlPlaneProfile | Select-Object -ExpandProperty AdditionalProperties

# Get upgrade profile and get agent pool upgrade additional properties
Get-AzAksUpgradeProfile -ResourceGroupName "MyResourceGroup" -Name "MyCluster" | Select-Object -ExpandProperty AgentPoolProfiles | Select-Object -ExpandProperty AdditionalProperties
```

---

### Get-AzAksVersion

List available version for creating managed Kubernetes cluster.

```powershell
Get-AzAksVersion -Location "eastus"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-Location` | String | Location (required) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Get available versions
Get-AzAksVersion -Location "eastus"

# Get versions with default profile
Get-AzAksVersion -Location "eastus" -DefaultProfile $context

# Get versions and format as table
Get-AzAksVersion -Location "eastus" | Format-Table

# Get versions and select properties
Get-AzAksVersion -Location "eastus" | Select-Object OrchestratorVersion, IsPreview, Upgrades

# Get versions and export to JSON
Get-AzAksVersion -Location "eastus" | ConvertTo-Json -Depth 10

# Get versions and save to file
Get-AzAksVersion -Location "eastus" | Out-File -FilePath "versions.json"

# Get versions and get orchestrator versions
Get-AzAksVersion -Location "eastus" | Select-Object -ExpandProperty OrchestratorVersion

# Get versions and get preview versions
Get-AzAksVersion -Location "eastus" | Where-Object { $_.IsPreview -eq $true }

# Get versions and get non-preview versions
Get-AzAksVersion -Location "eastus" | Where-Object { $_.IsPreview -eq $false }

# Get versions and get latest version
Get-AzAksVersion -Location "eastus" | Select-Object -First 1

# Get versions and get oldest version
Get-AzAksVersion -Location "eastus" | Select-Object -Last 1

# Get versions and get version count
(Get-AzAksVersion -Location "eastus").Count

# Get versions and get upgrades
Get-AzAksVersion -Location "eastus" | Select-Object -ExpandProperty Upgrades

# Get versions and get available upgrades
Get-AzAksVersion -Location "eastus" | Select-Object -ExpandProperty Upgrades | Where-Object { $_.IsPreview -eq $false }

# Get versions and get preview upgrades
Get-AzAksVersion -Location "eastus" | Select-Object -ExpandProperty Upgrades | Where-Object { $_.IsPreview -eq $true }

# Get versions and get upgrade versions
Get-AzAksVersion -Location "eastus" | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty OrchestratorVersion

# Get versions and get upgrade preview status
Get-AzAksVersion -Location "eastus" | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty IsPreview

# Get versions and get upgrade count
(Get-AzAksVersion -Location "eastus" | Select-Object -ExpandProperty Upgrades).Count

# Get versions and get version by name
Get-AzAksVersion -Location "eastus" | Where-Object { $_.OrchestratorVersion -eq "1.28.0" }

# Get versions and get versions with upgrades
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -gt 0 }

# Get versions and get versions without upgrades
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 0 }

# Get versions and get versions with specific upgrade
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.OrchestratorVersion -contains "1.29.0" }

# Get versions and get versions with specific preview upgrade
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades | Where-Object { $_.OrchestratorVersion -eq "1.29.0" -and $_.IsPreview -eq $true } }

# Get versions and get versions with specific non-preview upgrade
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades | Where-Object { $_.OrchestratorVersion -eq "1.29.0" -and $_.IsPreview -eq $false } }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 2 }

# Get versions and get versions with more than 2 upgrades
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -gt 2 }

# Get versions and get versions with less than 2 upgrades
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -lt 2 }

# Get versions and get versions with specific upgrade version
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.OrchestratorVersion -contains "1.28.0" }

# Get versions and get versions with specific upgrade preview status
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades | Where-Object { $_.IsPreview -eq $true } }

# Get versions and get versions with specific upgrade preview status
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades | Where-Object { $_.IsPreview -eq $false } }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 1 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 3 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 4 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 5 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 6 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 7 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 8 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 9 }

# Get versions and get versions with specific upgrade count
Get-AzAksVersion -Location "eastus" | Where-Object { $_.Upgrades.Count -eq 10 }
```

---

### Import-AzAksCredential

Import and merge Kubectl config for a managed Kubernetes Cluster.

```powershell
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Admin` | Switch | Get cluster administrator credentials |
| `-OverwriteExisting` | Switch | Overwrite existing credentials |
| `-Path` | String | File path to save kubeconfig |
| `-Format` | String | Format: `azure`, `exec` |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Import credentials
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Import admin credentials
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Admin

# Overwrite existing
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -OverwriteExisting

# Save to file
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Path "~/.kube/config"

# Get exec format credentials
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Format exec

# Import as job
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Import with WhatIf
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Import with Confirm
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Import with default profile
Import-AzAksCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Install-AzAksCliTool

Download and install kubectl and kubelogin.

```powershell
Install-AzAksCliTool
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ClientVersion` | String | kubectl client version |
| `-InstallLocation` | String | Install location |
| `-BaseSrcUrl` | String | Base source URL |
| `-KubeloginVersion` | String | kubelogin version |
| `-KubeloginInstallLocation` | String | kubelogin install location |
| `-KubeloginBaseSrcUrl` | String | kubelogin base source URL |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Install kubectl and kubelogin
Install-AzAksCliTool

# Install specific kubectl version
Install-AzAksCliTool -ClientVersion "1.28.0"

# Install to custom location
Install-AzAksCliTool -InstallLocation "/usr/local/bin/kubectl"

# Install specific kubelogin version
Install-AzAksCliTool -KubeloginVersion "0.1.0"

# Install as job
Install-AzAksCliTool -AsJob

# Install with WhatIf
Install-AzAksCliTool -WhatIf

# Install with Confirm
Install-AzAksCliTool -Confirm

# Install with default profile
Install-AzAksCliTool -DefaultProfile $context
```

---

### Start-AzAksDashboard

Create a Kubectl SSH tunnel to the managed cluster's dashboard.

```powershell
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-ListenPort` | Int32 | Listen port |
| `-ListenAddress` | String | Listen address |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Start dashboard
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Custom port
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ListenPort 8080

# Custom address
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ListenAddress "127.0.0.1"

# Start as job
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Start with WhatIf
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Start with Confirm
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Start with default profile
Start-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Stop-AzAksDashboard

Stop the Kubectl SSH tunnel created in Start-AzKubernetesDashboard.

```powershell
Stop-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Stop dashboard
Stop-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Stop as job
Stop-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Stop with WhatIf
Stop-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Stop with Confirm
Stop-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Stop with default profile
Stop-AzAksDashboard -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Set-AzAksClusterCredential

Reset the ServicePrincipal of an existing AKS cluster.

```powershell
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster" -ResetServicePrincipal
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-ResetServicePrincipal` | Switch | Reset service principal |
| `-ResetAad` | Switch | Reset AAD |
| `-ServicePrincipal` | String | New service principal |
| `-ClientSecret` | String | New client secret |
| `-AadServerAppId` | String | New AAD server app ID |
| `-AadServerAppSecret` | String | New AAD server app secret |
| `-AadClientAppId` | String | New AAD client app ID |
| `-AadTenantId` | String | New AAD tenant ID |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Reset service principal
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ResetServicePrincipal -ServicePrincipal "<sp-id>" -ClientSecret "<secret>"

# Reset AAD
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ResetAad -AadServerAppId "<id>" -AadServerAppSecret "<secret>" -AadClientAppId "<id>" -AadTenantId "<id>"

# Reset without waiting
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ResetServicePrincipal -ServicePrincipal "<sp-id>" -ClientSecret "<secret>" -NoWait

# Reset as job
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ResetServicePrincipal -ServicePrincipal "<sp-id>" -ClientSecret "<secret>" -AsJob

# Reset with WhatIf
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ResetServicePrincipal -ServicePrincipal "<sp-id>" -ClientSecret "<secret>" -WhatIf

# Reset with Confirm
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ResetServicePrincipal -ServicePrincipal "<sp-id>" -ClientSecret "<secret>" -Confirm

# Reset with default profile
Set-AzAksClusterCredential -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -ResetServicePrincipal -ServicePrincipal "<sp-id>" -ClientSecret "<secret>" -DefaultProfile $context
```

---

## Node Pool Commands

### New-AzAksNodePool

Create a new node pool in specified cluster.

```powershell
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "MyNodePool" -NodeCount 3
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Node pool name (required) |
| `-NodeCount` | Int32 | Number of nodes (default: 3) |
| `-NodeVmSize` | String | VM size |
| `-OsType` | String | OS type: `Linux`, `Windows` |
| `-OsSku` | String | OS SKU |
| `-MaxPods` | Int32 | Max pods per node |
| `-NodeOSDiskSize` | Int32 | OS disk size in GB |
| `-NodeOSDiskType` | String | OS disk type |
| `-EnableClusterAutoscaler` | Switch | Enable autoscaler |
| `-MinCount` | Int32 | Min nodes |
| `-MaxCount` | Int32 | Max nodes |
| `-Mode` | String | Mode: `System`, `User` |
| `-AvailabilityZones` | String[] | Availability zones |
| `-VnetSubnetId` | String | VNet subnet ID |
| `-PodSubnetId` | String | Pod subnet ID |
| `-NodeLabels` | Hashtable | Node labels |
| `-NodeTaints` | String[] | Node taints |
| `-Priority` | String | Priority: `Regular`, `Spot` |
| `-EvictionPolicy` | String | Eviction policy: `Delete`, `Deallocate` |
| `-SpotMaxPrice` | Double | Spot max price |
| `-ScaleDownMode` | String | Scale down mode: `Delete`, `Deallocate` |
| `-MaxSurge` | String | Max surge |
| `-EnableEncryptionAtHost` | Switch | Enable encryption at host |
| `-EnableUltraSsd` | Switch | Enable Ultra SSD |
| `-EnableFipsImage` | Switch | Enable FIPS image |
| `-EnablePublicIp` | Switch | Enable public IP |
| `-PublicIpPrefixId` | String | Public IP prefix ID |
| `-KubeletConfig` | String | Kubelet config file |
| `-LinuxOsConfig` | String | Linux OS config file |
| `-Tag` | Hashtable | Tags |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Add basic node pool
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -NodeCount 3

# Add Windows node pool
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "WinNodePool" -OsType Windows -NodeCount 3

# Add GPU node pool
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "GpuNodePool" -NodeVmSize "Standard_NC6s_v3" -NodeCount 3

# Add spot node pool
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "SpotNodePool" -Priority Spot -EvictionPolicy Delete -SpotMaxPrice 0.5

# Add node pool with autoscaler
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "AutoNodePool" -EnableClusterAutoscaler -MinCount 1 -MaxCount 5

# Add node pool with labels
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "LabeledNodePool" -NodeLabels @{env="prod"; team="devops"}

# Add node pool with taints
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "TaintedNodePool" -NodeTaints "key1=value1:NoSchedule"

# Add node pool with max surge
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "SurgeNodePool" -MaxSurge 2

# Add node pool with FIPS
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "FipsNodePool" -EnableFipsImage

# Add node pool with public IP
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "PublicIpNodePool" -EnablePublicIp

# Add node pool with custom VNet
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "VnetNodePool" -VnetSubnetId "<subnet-id>"

# Add node pool with pod subnet
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "PodSubnetNodePool" -PodSubnetId "<pod-subnet-id>"

# Add node pool with kubelet config
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "KubeletNodePool" -KubeletConfig "<config-file>"

# Add node pool with Linux OS config
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "OsConfigNodePool" -LinuxOsConfig "<config-file>"

# Add node pool with encryption at host
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "EncNodePool" -EnableEncryptionAtHost

# Add node pool with Ultra SSD
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "UltraNodePool" -EnableUltraSsd

# Add node pool with scale down mode
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "ScaleDownNodePool" -ScaleDownMode Deallocate

# Add node pool with availability zones
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "ZoneNodePool" -AvailabilityZones 1,2,3

# Add node pool with OS SKU
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "OsSkuNodePool" -OsSku Ubuntu

# Add node pool with max pods
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MaxPodsNodePool" -MaxPods 250

# Add node pool with OS disk size
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "DiskNodePool" -NodeOSDiskSize 256

# Add node pool with OS disk type
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "DiskTypeNodePool" -NodeOSDiskType Ephemeral

# Add node pool with mode
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "SystemNodePool" -Mode System

# Add node pool with tags
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "TaggedNodePool" -Tag @{env="prod"}

# Add node pool with no-wait
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "NoWaitNodePool" -NoWait

# Add node pool with force
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "ForceNodePool" -Force

# Add node pool as job
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "JobNodePool" -AsJob

# Add node pool with WhatIf
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "WhatIfNodePool" -WhatIf

# Add node pool with Confirm
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "ConfirmNodePool" -Confirm

# Add node pool with default profile
New-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "DefaultProfileNodePool" -DefaultProfile $context
```

---

### Get-AzAksNodePool

List node pools in specified cluster.

```powershell
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Node pool name |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# List node pools
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster"

# List specific node pool
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool"

# List with default profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -DefaultProfile $context

# List and format as table
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Format-Table

# List and select properties
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Select-Object Name, NodeCount, VmSize, OsType

# List and export to CSV
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Export-Csv -Path "nodepools.csv" -NoTypeInformation

# List and filter by OS type
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.OsType -eq "Linux" }

# List and filter by mode
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Mode -eq "System" }

# List and filter by priority
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ScaleSetPriority -eq "Spot" }

# List and sort by name
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Sort-Object Name

# List and count
(Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster").Count

# List and get first node pool
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Select-Object -First 1

# List and get last node pool
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Select-Object -Last 1

# List and get specific node pool
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Name -eq "MyNodePool" }

# List and get node pools with specific VM size
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.VmSize -eq "standard_ds2_v2" }

# List and get node pools with specific node count
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Count -eq 3 }

# List and get node pools with autoscaler enabled
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.EnableAutoScaling -eq $true }

# List and get node pools with autoscaler disabled
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.EnableAutoScaling -eq $false }

# List and get node pools with specific max pods
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.MaxPods -eq 110 }

# List and get node pools with specific OS disk size
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.OsDiskSizeGB -eq 128 }

# List and get node pools with specific OS disk type
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.OsDiskType -eq "Managed" }

# List and get node pools with specific VM set type
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Type -eq "VirtualMachineScaleSets" }

# List and get node pools with specific availability zones
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.AvailabilityZones -contains "1" }

# List and get node pools with specific max surge
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.UpgradeSettings.MaxSurge -eq "1" }

# List and get node pools with specific scale down mode
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ScaleDownMode -eq "Delete" }

# List and get node pools with specific node labels
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.NodeLabels["env"] -eq "prod" }

# List and get node pools with specific node taints
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.NodeTaints -contains "key1=value1:NoSchedule" }

# List and get node pools with specific tags
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Tags["env"] -eq "prod" }

# List and get node pools with specific kubelet config
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.KubeletConfig.cpuCfsQuota -eq $true }

# List and get node pools with specific Linux OS config
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.LinuxOsConfig.SwapFileSizeMB -eq 1024 }

# List and get node pools with specific Windows config
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.WindowsProfile.AdminUsername -eq "azureuser" }

# List and get node pools with specific encryption at host
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.EncryptionAtHost -eq $true }

# List and get node pools with specific Ultra SSD
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.UltraSsdEnabled -eq $true }

# List and get node pools with specific FIPS image
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.EnableFips -eq $true }

# List and get node pools with specific public IP
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.EnableNodePublicIp -eq $true }

# List and get node pools with specific spot priority
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ScaleSetPriority -eq "Spot" }

# List and get node pools with specific eviction policy
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ScaleSetEvictionPolicy -eq "Delete" }

# List and get node pools with specific spot max price
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.SpotMaxPrice -eq 0.5 }

# List and get node pools with specific proximity placement group
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ProximityPlacementGroupId -eq "<ppg-id>" }

# List and get node pools with specific orchestrator version
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.OrchestratorVersion -eq "1.28.0" }

# List and get node pools with specific current orchestrator version
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.CurrentOrchestratorVersion -eq "1.28.0" }

# List and get node pools with specific node image version
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.NodeImageVersion -eq "AKSUbuntu-1804gen2containerd-2023.08.09" }

# List and get node pools with specific VM ID
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.VmId -eq "<vm-id>" }

# List and get node pools with specific VM name
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.VmName -eq "<vm-name>" }

# List and get node pools with specific VM size properties
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.VmSizeProperties.vCPUsAvailable -eq 4 }

# List and get node pools with specific data disks
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.DataDisks.Count -gt 0 }

# List and get node pools with specific extensions
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Extensions.Count -gt 0 }

# List and get node pools with specific hosted profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.HostedProfile -ne $null }

# List and get node pools with specific artifact streaming
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ArtifactStreamingProfile -ne $null }

# List and get node pools with specific security profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.SecurityProfile -ne $null }

# List and get node pools with specific mesh profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.MeshProfile -ne $null }

# List and get node pools with specific metrics profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.MetricsProfile -ne $null }

# List and get node pools with specific AI toolchain operator
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.AiToolchainOperatorProfile -ne $null }

# List and get node pools with specific scheduler profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.SchedulerProfile -ne $null }

# List and get node pools with specific certificate profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.CertificateProfile -ne $null }

# List and get node pools with specific extensions profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ExtensionsProfile -ne $null }

# List and get node pools with specific egress profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.EgressProfile -ne $null }

# List and get node pools with specific security posture
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.SecurityPosture -ne $null }

# List and get node pools with specific guardrails profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.GuardrailsProfile -ne $null }

# List and get node pools with specific policy profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.PolicyProfile -ne $null }

# List and get node pools with specific observability profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ObservabilityProfile -ne $null }

# List and get node pools with specific cost analysis
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.CostAnalysis -ne $null }

# List and get node pools with specific metrics
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Metrics -ne $null }

# List and get node pools with specific identity binding
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.IdentityBinding -ne $null }

# List and get node pools with specific snapshot
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Snapshot -ne $null }

# List and get node pools with specific managed cluster snapshot
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ManagedClusterSnapshot -ne $null }

# List and get node pools with specific agent pool
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.AgentPool -ne $null }

# List and get node pools with specific maintenance configuration
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.MaintenanceConfiguration -ne $null }

# List and get node pools with specific upgrade profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.UpgradeProfile -ne $null }

# List and get node pools with specific version
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Version -ne $null }

# List and get node pools with specific node pool upgrade profile
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.NodePoolUpgradeProfile -ne $null }

# List and get node pools with specific outbound network dependency endpoint
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.OutboundNetworkDependencyEndpoint -ne $null }

# List and get node pools with specific OS option
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.OsOption -ne $null }

# List and get node pools with specific command result
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.CommandResult -ne $null }

# List and get node pools with specific abort operation
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.AbortOperation -ne $null }

# List and get node pools with specific rotate service account signing key
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.RotateServiceAccountSigningKey -ne $null }

# List and get node pools with specific run command
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.RunCommand -ne $null }

# List and get node pools with specific dashboard
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Dashboard -ne $null }

# List and get node pools with specific cluster credential
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.ClusterCredential -ne $null }

# List and get node pools with specific addon
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.Addon -ne $null }

# List and get node pools with specific time in week
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.TimeInWeek -ne $null }

# List and get node pools with specific time span
Get-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" | Where-Object { $_.TimeSpan -ne $null }
```

---

### Update-AzAksNodePool

Update node pool in a managed cluster.

```powershell
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "MyNodePool"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Node pool name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-EnableClusterAutoscaler` | Switch | Enable autoscaler |
| `-DisableClusterAutoscaler` | Switch | Disable autoscaler |
| `-UpdateClusterAutoscaler` | Switch | Update autoscaler |
| `-MinCount` | Int32 | Min nodes |
| `-MaxCount` | Int32 | Max nodes |
| `-Mode` | String | Mode: `System`, `User` |
| `-NodeLabels` | Hashtable | Node labels |
| `-NodeTaints` | String[] | Node taints |
| `-MaxSurge` | String | Max surge |
| `-ScaleDownMode` | String | Scale down mode |
| `-Tag` | Hashtable | Tags |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Enable autoscaler
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -EnableClusterAutoscaler -MinCount 1 -MaxCount 5

# Disable autoscaler
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -DisableClusterAutoscaler

# Update autoscaler
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -UpdateClusterAutoscaler -MinCount 2 -MaxCount 8

# Update mode
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -Mode System

# Update labels
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -NodeLabels @{env="prod"}

# Update taints
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -NodeTaints "key1=value1:NoSchedule"

# Update max surge
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -MaxSurge 2

# Update scale down mode
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -ScaleDownMode Deallocate

# Update tags
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -Tag @{env="prod"}

# Update without waiting
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -NoWait

# Update without confirmation
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -Force

# Update as job
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -AsJob

# Update with WhatIf
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -WhatIf

# Update with Confirm
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -Confirm

# Update with default profile
Update-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -DefaultProfile $context
```

---

### Remove-AzAksNodePool

Delete node pool from managed cluster.

```powershell
Remove-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "MyNodePool"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Node pool name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Delete node pool
Remove-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool"

# Delete without confirmation
Remove-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -Force

# Delete as job
Remove-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -AsJob

# Delete with WhatIf
Remove-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -WhatIf

# Delete with Confirm
Remove-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -Confirm

# Delete with default profile
Remove-AzAksNodePool -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -DefaultProfile $context
```

---

### Get-AzAksNodePoolUpgradeProfile

Gets the upgrade profile for an agent pool.

```powershell
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "MyNodePool"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Node pool name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Get node pool upgrade profile
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool"

# Get with default profile
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -DefaultProfile $context

# Get and format as table
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Format-Table

# Get and select properties
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object Name, KubernetesVersion, Upgrades

# Get and export to JSON
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | ConvertTo-Json -Depth 10

# Get and save to file
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Out-File -FilePath "nodepool-upgrade-profile.json"

# Get and get Kubernetes version
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty KubernetesVersion

# Get and get upgrades
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades

# Get and get available upgrades
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades | Where-Object { $_.IsPreview -eq $false }

# Get and get preview upgrades
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades | Where-Object { $_.IsPreview -eq $true }

# Get and get latest upgrade
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades | Select-Object -First 1

# Get and get oldest upgrade
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades | Select-Object -Last 1

# Get and get upgrade count
(Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades).Count

# Get and get upgrade versions
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty KubernetesVersion

# Get and get upgrade preview status
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Upgrades | Select-Object -ExpandProperty IsPreview

# Get and get upgrade component
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Component

# Get and get upgrade name
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Name

# Get and get upgrade type
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Type

# Get and get upgrade provisioning state
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty ProvisioningState

# Get and get upgrade created time
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty CreatedTime

# Get and get upgrade last updated time
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty LastUpdatedTime

# Get and get upgrade etag
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Etag

# Get and get upgrade id
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Id

# Get and get upgrade location
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Location

# Get and get upgrade tags
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Tags

# Get and get upgrade zones
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Zones

# Get and get upgrade sku
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Sku

# Get and get upgrade identity
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Identity

# Get and get upgrade extended location
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty ExtendedLocation

# Get and get upgrade system data
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty SystemData

# Get and get upgrade kind
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Kind

# Get and get upgrade managed by
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty ManagedBy

# Get and get upgrade plan
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Plan

# Get and get upgrade properties
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty Properties

# Get and get upgrade additional properties
Get-AzAksNodePoolUpgradeProfile -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" | Select-Object -ExpandProperty AdditionalProperties
```

---

## Addon Commands

### Enable-AzAksAddOn

Enable the addons for AKS.

```powershell
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster" -Addon "monitoring"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Addon` | String | Addon to enable (required) |
| `-WorkspaceResourceId` | String | Log Analytics workspace ID |
| `-SubnetName` | String | Subnet name |
| `-AppgwName` | String | Application Gateway name |
| `-AppgwSubnetCidr` | String | App Gateway subnet CIDR |
| `-AppgwSubnetId` | String | App Gateway subnet ID |
| `-AppgwWatchNamespace` | String | App Gateway watch namespace |
| `-EnableSyslog` | Switch | Enable syslog |
| `-DataCollectionSettings` | String | Data collection settings |
| `-DnsZoneResourceId` | String | DNS zone resource ID |
| `-DnsZoneName` | String | DNS zone name |
| `-RotationPollInterval` | String | Rotation poll interval |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

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

```powershell
# Enable monitoring
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring"

# Enable monitoring with workspace
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -WorkspaceResourceId "<workspace-id>"

# Enable Azure Policy
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "azure-policy"

# Enable HTTP application routing
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "http_application_routing"

# Enable virtual node
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "virtual-node" -SubnetName "<subnet-name>"

# Enable App Gateway ingress
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "ingress-appgw" -AppgwName "<appgw-name>" -AppgwSubnetCidr "<cidr>"

# Enable Key Vault secrets provider
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "azure-keyvault-secrets-provider"

# Enable Open Service Mesh
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "open-service-mesh"

# Enable GitOps
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "gitops"

# Enable web application routing
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "web_application_routing"

# Enable with syslog
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -EnableSyslog -DataCollectionSettings "<settings-file>"

# Enable with DNS zone
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "http_application_routing" -DnsZoneResourceId "<zone-id>"

# Enable with rotation poll interval
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "azure-keyvault-secrets-provider" -RotationPollInterval "2m"

# Enable without waiting
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -NoWait

# Enable as job
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -AsJob

# Enable with WhatIf
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -WhatIf

# Enable with Confirm
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -Confirm

# Enable with default profile
Enable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -DefaultProfile $context
```

---

### Disable-AzAksAddOn

Disable the addons for AKS.

```powershell
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster" -Addon "monitoring"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Addon` | String | Addon to disable (required) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Disable monitoring
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring"

# Disable Azure Policy
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "azure-policy"

# Disable without waiting
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -NoWait

# Disable as job
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -AsJob

# Disable with WhatIf
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -WhatIf

# Disable with Confirm
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -Confirm

# Disable with default profile
Disable-AzAksAddOn -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Addon "monitoring" -DefaultProfile $context
```

---

## Run Command

### Invoke-AzAksRunCommand

Run a shell command (with kubectl, helm) on your AKS cluster.

```powershell
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster" -Command "kubectl get nodes"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Command` | String | Command to run (required) |
| `-File` | String[] | Files to attach (space-separated) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Run kubectl command
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes"

# Run with file
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl apply -f -" -File "deployment.yaml"

# Run without waiting
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get pods" -NoWait

# Run as job
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -AsJob

# Run with WhatIf
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -WhatIf

# Run with Confirm
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -Confirm

# Run with default profile
Invoke-AzAksRunCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -DefaultProfile $context
```

---

### Start-AzAksManagedClusterCommand

AKS will run a pod to run the command. Primarily useful for private clusters.

```powershell
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster" -Command "kubectl get nodes"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Command` | String | Command to run (required) |
| `-File` | String[] | Files to attach (space-separated) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Run command
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes"

# Run with file
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl apply -f -" -File "deployment.yaml"

# Run without waiting
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get pods" -NoWait

# Run as job
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -AsJob

# Run with WhatIf
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -WhatIf

# Run with Confirm
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -Confirm

# Run with default profile
Start-AzAksManagedClusterCommand -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Command "kubectl get nodes" -DefaultProfile $context
```

---

### Get-AzAksManagedClusterCommandResult

Gets the results of a command which has been run on the Managed Cluster.

```powershell
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster" -CommandId "<command-id>"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-CommandId` | String | Command ID (required) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Get command result
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>"

# Get with default profile
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" -DefaultProfile $context

# Get and format as table
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Format-Table

# Get and select properties
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object Id, ProvisioningState, ExitCode, StartedAt, FinishedAt

# Get and export to JSON
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | ConvertTo-Json -Depth 10

# Get and save to file
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Out-File -FilePath "command-result.json"

# Get and get logs
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty Logs

# Get and get exit code
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty ExitCode

# Get and get provisioning state
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty ProvisioningState

# Get and get started at
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty StartedAt

# Get and get finished at
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty FinishedAt

# Get and get id
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty Id

# Get and get name
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty Name

# Get and get type
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty Type

# Get and get location
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty Location

# Get and get tags
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty Tags

# Get and get system data
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty SystemData

# Get and get etag
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty Etag

# Get and get created by
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty CreatedBy

# Get and get created by type
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty CreatedByType

# Get and get created at
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty CreatedAt

# Get and get last modified by
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty LastModifiedBy

# Get and get last modified by type
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty LastModifiedByType

# Get and get last modified at
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty LastModifiedAt

# Get and get additional properties
Get-AzAksManagedClusterCommandResult -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -CommandId "<id>" | Select-Object -ExpandProperty AdditionalProperties
```

---

## Maintenance Configuration

### New-AzAksMaintenanceConfiguration

Create a maintenance configuration in the specified managed cluster.

```powershell
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "default" -Weekday Monday -StartHour 1
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Configuration name (required) |
| `-Weekday` | String | Day of week (e.g., `Monday`) |
| `-StartHour` | Int32 | Start hour (0-23) |
| `-DurationHours` | Int32 | Duration in hours |
| `-ScheduleType` | String | Schedule type: `Daily`, `Weekly`, `AbsoluteMonthly`, `RelativeMonthly` |
| `-DayOfMonth` | Int32 | Day of month (for AbsoluteMonthly) |
| `-DayOfWeek` | String | Day of week (for RelativeMonthly) |
| `-WeekIndex` | String | Week index: `First`, `Second`, `Third`, `Fourth`, `Last` |
| `-IntervalDays` | Int32 | Interval in days (for Daily) |
| `-IntervalWeeks` | Int32 | Interval in weeks (for Weekly) |
| `-IntervalMonths` | Int32 | Interval in months (for monthly) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Add weekly maintenance window
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Monday -StartHour 1 -DurationHours 4

# Add daily maintenance window
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "daily" -ScheduleType Daily -StartHour 2 -DurationHours 2

# Add absolute monthly maintenance window
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "monthly" -ScheduleType AbsoluteMonthly -DayOfMonth 1 -StartHour 1 -DurationHours 4

# Add relative monthly maintenance window
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "relative" -ScheduleType RelativeMonthly -DayOfWeek Monday -WeekIndex First -StartHour 1 -DurationHours 4

# Add without waiting
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Monday -StartHour 1 -NoWait

# Add as job
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Monday -StartHour 1 -AsJob

# Add with WhatIf
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Monday -StartHour 1 -WhatIf

# Add with Confirm
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Monday -StartHour 1 -Confirm

# Add with default profile
New-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Monday -StartHour 1 -DefaultProfile $context
```

---

### Get-AzAksMaintenanceConfiguration

Gets the specified maintenance configuration of a managed cluster.

```powershell
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "default"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Configuration name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Get maintenance configuration
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default"

# Get with default profile
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -DefaultProfile $context

# Get and format as table
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Format-Table

# Get and select properties
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object Name, Schedule, TimeInWeek, TimeSpan, NotAllowedTime

# Get and export to JSON
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | ConvertTo-Json -Depth 10

# Get and save to file
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Out-File -FilePath "maintenance-config.json"

# Get and get schedule
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty Schedule

# Get and get time in week
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty TimeInWeek

# Get and get time span
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty TimeSpan

# Get and get not allowed time
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty NotAllowedTime

# Get and get name
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty Name

# Get and get id
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty Id

# Get and get type
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty Type

# Get and get system data
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty SystemData

# Get and get etag
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty Etag

# Get and get created by
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty CreatedBy

# Get and get created by type
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty CreatedByType

# Get and get created at
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty CreatedAt

# Get and get last modified by
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty LastModifiedBy

# Get and get last modified by type
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty LastModifiedByType

# Get and get last modified at
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty LastModifiedAt

# Get and get additional properties
Get-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" | Select-Object -ExpandProperty AdditionalProperties
```

---

### Update-AzAksMaintenanceConfiguration

Update a maintenance configuration in the specified managed cluster.

```powershell
Update-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "default" -Weekday Tuesday -StartHour 2
```

**Key Parameters:** Same as `New-AzAksMaintenanceConfiguration`

**Examples:**

```powershell
# Update maintenance window
Update-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Tuesday -StartHour 2

# Update without waiting
Update-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Tuesday -StartHour 2 -NoWait

# Update as job
Update-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Tuesday -StartHour 2 -AsJob

# Update with WhatIf
Update-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Tuesday -StartHour 2 -WhatIf

# Update with Confirm
Update-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Tuesday -StartHour 2 -Confirm

# Update with default profile
Update-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Weekday Tuesday -StartHour 2 -DefaultProfile $context
```

---

### Remove-AzAksMaintenanceConfiguration

Deletes a maintenance configuration.

```powershell
Remove-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "default"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Configuration</longcat_think>
 name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Delete maintenance configuration
Remove-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default"

# Delete without confirmation
Remove-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Force

# Delete as job
Remove-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -AsJob

# Delete with WhatIf
Remove-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -WhatIf

# Delete with Confirm
Remove-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -Confirm

# Delete with default profile
Remove-AzAksMaintenanceConfiguration -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "default" -DefaultProfile $context
```

---

## Snapshot Commands

### New-AzAksSnapshot

Create a snapshot.

```powershell
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "<cluster-resource-id>"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Snapshot name (required) |
| `-ClusterId` | String | Source cluster resource ID (required) |
| `-Tag` | Hashtable | Tags |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Create snapshot
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ContainerService/managedClusters/<cluster>"

# Create with tags
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "<cluster-id>" -Tag @{env="prod"}

# Create without waiting
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "<cluster-id>" -NoWait

# Create as job
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "<cluster-id>" -AsJob

# Create with WhatIf
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "<cluster-id>" -WhatIf

# Create with Confirm
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "<cluster-id>" -Confirm

# Create with default profile
New-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -ClusterId "<cluster-id>" -DefaultProfile $context
```

---

### Get-AzAksSnapshot

Gets a snapshot.

```powershell
Get-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Snapshot name (required) |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Get snapshot
Get-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot"

# Get with default profile
Get-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -DefaultProfile $context

# Get and format as table
Get-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" | Format-Table

# Get and select properties
Get-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" | Select-Object Name, SourceClusterId, Tags

# Get and export to JSON
Get-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" | ConvertTo-Json -Depth 10

# Get and save to file
Get-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" | Out-File -FilePath "snapshot.json"
```

---

### Remove-AzAksSnapshot

Deletes a snapshot.

```powershell
Remove-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Snapshot name (required) |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Delete snapshot
Remove-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot"

# Delete without confirmation
Remove-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -Force

# Delete as job
Remove-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -AsJob

# Delete with WhatIf
Remove-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -WhatIf

# Delete with Confirm
Remove-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -Confirm

# Delete with default profile
Remove-AzAksSnapshot -ResourceGroupName "MyResourceGroup" -Name "MySnapshot" -DefaultProfile $context
```

---

## Helper Object Commands

### New-AzAksTimeInWeekObject

Create an in-memory object for TimeInWeek.

```powershell
$timeInWeek = New-AzAksTimeInWeekObject -Day Monday -Hour 1,2,3
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-Day` | String | Day of week |
| `-Hour` | Int32[] | Hours (0-23) |

**Examples:**

```powershell
# Create time in week object
New-AzAksTimeInWeekObject -Day Monday -Hour 1,2,3

# Create for Tuesday
New-AzAksTimeInWeekObject -Day Tuesday -Hour 4,5,6

# Create for Wednesday
New-AzAksTimeInWeekObject -Day Wednesday -Hour 7,8,9

# Create for Thursday
New-AzAksTimeInWeekObject -Day Thursday -Hour 10,11,12

# Create for Friday
New-AzAksTimeInWeekObject -Day Friday -Hour 13,14,15

# Create for Saturday
New-AzAksTimeInWeekObject -Day Saturday -Hour 16,17,18

# Create for Sunday
New-AzAksTimeInWeekObject -Day Sunday -Hour 19,20,21

# Create with single hour
New-AzAksTimeInWeekObject -Day Monday -Hour 1

# Create with multiple hours
New-AzAksTimeInWeekObject -Day Monday -Hour 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
```

---

### New-AzAksTimeSpanObject

Create an in-memory object for TimeSpan.

```powershell
$timeSpan = New-AzAksTimeSpanObject -StartHour 1 -EndHour 5
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-StartHour` | Int32 | Start hour (0-23) |
| `-EndHour` | Int32 | End hour (0-23) |

**Examples:**

```powershell
# Create time span object
New-AzAksTimeSpanObject -StartHour 1 -EndHour 5

# Create for morning
New-AzAksTimeSpanObject -StartHour 6 -EndHour 12

# Create for afternoon
New-AzAksTimeSpanObject -StartHour 12 -EndHour 18

# Create for evening
New-AzAksTimeSpanObject -StartHour 18 -EndHour 23

# Create for night
New-AzAksTimeSpanObject -StartHour 0 -EndHour 6

# Create for full day
New-AzAksTimeSpanObject -StartHour 0 -EndHour 23

# Create for business hours
New-AzAksTimeSpanObject -StartHour 9 -EndHour 17

# Create for weekend hours
New-AzAksTimeSpanObject -StartHour 10 -EndHour 16
```

---

## Abort Operation Commands

### Invoke-AzAksAbortManagedClusterLatestOperation

Aborts the currently running operation on the managed cluster.

```powershell
Invoke-AzAksAbortManagedClusterLatestOperation -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Abort operation
Invoke-AzAksAbortManagedClusterLatestOperation -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Abort without waiting
Invoke-AzAksAbortManagedClusterLatestOperation -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NoWait

# Abort as job
Invoke-AzAksAbortManagedClusterLatestOperation -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Abort with WhatIf
Invoke-AzAksAbortManagedClusterLatestOperation -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Abort with Confirm
Invoke-AzAksAbortManagedClusterLatestOperation -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Abort with default profile
Invoke-AzAksAbortManagedClusterLatestOperation -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

### Invoke-AzAksAbortAgentPoolLatestOperation

Aborts the currently running operation on the agent pool.

```powershell
Invoke-AzAksAbortAgentPoolLatestOperation -ResourceGroupName "MyResourceGroup" -ClusterName "MyManagedCluster" -Name "MyNodePool"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-ClusterName` | String | Cluster name (required) |
| `-Name` | String | Node pool name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Abort operation
Invoke-AzAksAbortAgentPoolLatestOperation -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool"

# Abort without waiting
Invoke-AzAksAbortAgentPoolLatestOperation -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -NoWait

# Abort as job
Invoke-AzAksAbortAgentPoolLatestOperation -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -AsJob

# Abort with WhatIf
Invoke-AzAksAbortAgentPoolLatestOperation -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -WhatIf

# Abort with Confirm
Invoke-AzAksAbortAgentPoolLatestOperation -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -Confirm

# Abort with default profile
Invoke-AzAksAbortAgentPoolLatestOperation -ResourceGroupName "MyResourceGroup" -ClusterName "MyCluster" -Name "MyNodePool" -DefaultProfile $context
```

---

## Rotate Service Account Signing Key

### Invoke-AzAksRotateManagedClusterServiceAccountSigningKey

Rotates the service account signing keys of a managed cluster.

```powershell
Invoke-AzAksRotateManagedClusterServiceAccountSigningKey -ResourceGroupName "MyResourceGroup" -Name "MyManagedCluster"
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `-ResourceGroupName` | String | Resource group name (required) |
| `-Name` | String | Cluster name (required) |
| `-InputObject` | PSManagedCluster | Input object (pipeline) |
| `-NoWait` | Switch | Do not wait for completion |
| `-Force` | Switch | Force execution without confirmation |
| `-AsJob` | Switch | Run as background job |
| `-WhatIf` | Switch | Show what would happen |
| `-Confirm` | Switch | Prompt for confirmation |
| `-DefaultProfile` | IAzureContextContainer | Azure context |

**Examples:**

```powershell
# Rotate service account signing key
Invoke-AzAksRotateManagedClusterServiceAccountSigningKey -ResourceGroupName "MyResourceGroup" -Name "MyCluster"

# Rotate without waiting
Invoke-AzAksRotateManagedClusterServiceAccountSigningKey -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -NoWait

# Rotate as job
Invoke-AzAksRotateManagedClusterServiceAccountSigningKey -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -AsJob

# Rotate with WhatIf
Invoke-AzAksRotateManagedClusterServiceAccountSigningKey -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -WhatIf

# Rotate with Confirm
Invoke-AzAksRotateManagedClusterServiceAccountSigningKey -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -Confirm

# Rotate with default profile
Invoke-AzAksRotateManagedClusterServiceAccountSigningKey -ResourceGroupName "MyResourceGroup" -Name "MyCluster" -DefaultProfile $context
```

---

## Related Notes

- [[AKS Commands - Index]]
- [[AKS Commands - Azure CLI]]
- [[Azure CLI Reference]]
- [[Kubernetes Commands]]
