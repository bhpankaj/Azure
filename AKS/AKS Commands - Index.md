---
title: AKS Commands Index
description: Complete reference for Azure Kubernetes Service (AKS) management commands
tags: [azure, kubernetes, aks, cli, powershell]
created: 2026-10-08
---

# AKS Commands Index

Azure Kubernetes Service (AKS) command reference covering both Azure CLI (`az aks`) and PowerShell (`Az.Aks` module).

## Quick Links

- [[AKS Commands - Azure CLI]] — All `az aks` commands with parameters and examples
- [[AKS Commands - PowerShell]] — All `Az.Aks` PowerShell cmdlets with parameters and examples

## Common Tasks

| Task | Azure CLI | PowerShell |
|------|-----------|------------|
| Create cluster | `az aks create` | `New-AzAksCluster` |
| Delete cluster | `az aks delete` | `Remove-AzAksCluster` |
| List clusters | `az aks list` | `Get-AzAksCluster` |
| Show cluster | `az aks show` | `Get-AzAksCluster` |
| Get credentials | `az aks get-credentials` | `Import-AzAksCredential` |
| Scale cluster | `az aks scale` | `Update-AzAksNodePool` |
| Upgrade cluster | `az aks upgrade` | `Set-AzAksCluster` |
| Start cluster | `az aks start` | `Start-AzAksCluster` |
| Stop cluster | `az aks stop` | `Stop-AzAksCluster` |
| Run command | `az aks command invoke` | `Invoke-AzAksRunCommand` |
| Install kubectl | `az aks install-cli` | `Install-AzAksCliTool` |
| List node pools | `az aks nodepool list` | `Get-AzAksNodePool` |
| Add node pool | `az aks nodepool add` | `New-AzAksNodePool` |
| Delete node pool | `az aks nodepool delete` | `Remove-AzAksNodePool` |
| Get upgrades | `az aks get-upgrades` | `Get-AzAksUpgradeProfile` |
| Get versions | `az aks get-versions` | `Get-AzAksVersion` |
| Browse dashboard | `az aks browse` | `Start-AzAksDashboard` |
| Enable addons | `az aks enable-addons` | `Enable-AzAksAddOn` |
| Disable addons | `az aks disable-addons` | `Disable-AzAksAddOn` |

## Prerequisites

### Azure CLI
```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login
az login

# Install aks-preview extension (for advanced features)
az extension add --name aks-preview

# Verify
az aks --help
```

### PowerShell
```powershell
# Install Az.Aks module
Install-Module -Name Az.Aks -Scope CurrentUser -Repository PSGallery -Force

# Login
Connect-AzAccount

# Verify
Get-Command -Module Az.Aks
```

## Related Notes

- [[Azure CLI Reference]]
- [[PowerShell Az Module]]
- [[Kubernetes Commands]]
- [[Azure Networking]]
