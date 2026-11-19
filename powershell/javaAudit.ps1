[CmdletBinding()]
param(
    [Parameter(HelpMessage="Path to TXT, CSV or XLSX file containing hostnames and IPs")]
    [string]$ServerFile = ".\Data\LinuxServers\LinuxServersListLatest.xlsx",
    [string]$Username = "ansiblesrv",
    [string]$ExcelLookupFile = ".\Data\LinuxServers\LinuxServersListLatest.xlsx",
    [Parameter(HelpMessage="SSH password for -Username. If omitted you are prompted.")]
    [string]$Password
)

$ErrorActionPreference = "Stop"
$script:Failed = $false

# --- helpers ------------------------------------------------------------
$Servers = [System.Collections.Generic.List[PSCustomObject]]::new()
$Seen = @{}

function Add-Server {
    param([string]$Rhost, [string]$Ip)
    if ([string]::IsNullOrWhiteSpace($Rhost) -or [string]::IsNullOrWhiteSpace($Ip)) { return }
    $Key = "$($Rhost.ToLowerInvariant())|$($Ip)"
    if ($script:Seen.ContainsKey($Key)) { return }
    $script:Seen[$Key] = $true
    $script:Servers.Add([PSCustomObject]@{ RHOST = $Rhost; IP = $Ip })
}

function ConvertTo-ServerRow {
    # Map a row from XLSX/Excel onto RHOST + IP using common column names.
    param($Row)
    $Rhost = $Row.'RHOST' ?? $Row.'COMPUTER NAME' ?? $Row.'HOSTNAME' ?? $Row.'NAME' ?? $Row.'SERVER NAME'
    $Ip    = $Row.'IP' ?? $Row.'PRIVATE IP ADDRESS' ?? $Row.'IP ADDRESS' ?? $Row.'PRIVATE_IP'
    if ($Rhost -and $Ip) {
        return [pscustomobject]@{ RHOST = "$($Rhost)".Trim(); IP = "$($Ip)".Trim() }
    }
    return $null
}

function ConvertFrom-CsvLine {
    # Split one CSV row on commas outside double quotes; trim and unquote.
    param([string]$Line)
    $Fields = [System.Collections.Generic.List[string]]::new()
    $Current = [System.Text.StringBuilder]::new()
    $InQuotes = $false
    foreach ($Ch in "$Line".ToCharArray()) {
        if ($Ch -eq '"') { $InQuotes = -not $InQuotes; continue }
        if (($Ch -eq ',') -and (-not $InQuotes)) {
            $Fields.Add(([string]$Current).Trim())
            [void]$Current.Clear()
        } else {
            [void]$Current.Append($Ch)
        }
    }
    $Fields.Add(([string]$Current).Trim())
    return $Fields
}

function Get-IpLookup {
    # Hostname -> IP map from the reference Excel file.
    param([string]$Path)
    if (-not (Test-Path -Path $Path -PathType Leaf)) {
        Write-Host "Reference Excel file for hostname lookup not found: $Path" -ForegroundColor Red
        exit 1
    }
    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        Write-Host "ImportExcel module is required for hostname lookups. Install using: Install-Module ImportExcel -Scope CurrentUser" -ForegroundColor Red
        exit 1
    }
    Write-Host "Loading reference Excel data for IP lookup..." -ForegroundColor Cyan
    $Lookup = @{}
    foreach ($Row in (Import-Excel -Path $Path)) {
        $Entry = ConvertTo-ServerRow -Row $Row
        if ($Entry) { $Lookup[$Entry.RHOST.ToLowerInvariant()] = $Entry.IP }
    }
    return $Lookup
}

# --- prerequisites ------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Posh-SSH)) {
    Write-Host "Posh-SSH module is required. Install it with: Install-Module Posh-SSH -Scope CurrentUser" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path -Path $ServerFile -PathType Leaf)) {
    Write-Host "Server file not found: $ServerFile" -ForegroundColor Red
    exit 1
}

$Extension = [System.IO.Path]::GetExtension($ServerFile).ToLowerInvariant()

switch ($Extension) {
    ".txt" {
        $Lines = @(Get-Content -Path $ServerFile | Where-Object { $_ -match '\S' -and $_ -notmatch '^\s*#' })

        if ($Lines.Count -eq 0) {
            Write-Host "Server file is empty: $ServerFile" -ForegroundColor Red
            exit 1
        }

        # Drop a header row such as "RHOST IP" or "HOSTNAME".
        $First = $Lines[0].Trim()
        if (($First -match '^(rhost|hostname|host|name|server)\b') -and ($First -notmatch '\d{1,3}(\.\d{1,3}){3}')) {
            $Lines = @($Lines | Select-Object -Skip 1)
        }
        if ($Lines.Count -eq 0) {
            Write-Host "Server file has only a header row: $ServerFile" -ForegroundColor Red
            exit 1
        }

        $TwoColumn = (@($Lines[0].Trim() -split '\s+')).Count -ge 2

        if ($TwoColumn) {
            # 2-column format: RHOST IP
            foreach ($Line in $Lines) {
                $Parts = @($Line.Trim() -split '\s+' | Where-Object { $_ -ne '' })
                if ($Parts.Count -ge 2) {
                    Add-Server -Rhost "$($Parts[0])" -Ip "$($Parts[1])"
                }
            }
        } else {
            # 1-column format: RHOST only -> look the IP up in the reference Excel file.
            $Lookup = Get-IpLookup -Path $ExcelLookupFile
            foreach ($Line in $Lines) {
                $Rhost = $Line.Trim()
                $Key = $Rhost.ToLowerInvariant()
                if ($Lookup.ContainsKey($Key)) {
                    Add-Server -Rhost $Rhost -Ip $Lookup[$Key]
                } else {
                    Write-Warning "Host '$Rhost' not found in reference Excel lookup."
                    $script:Failed = $true
                }
            }
        }
    }

    ".csv" {
        $Raw = @(Get-Content -Path $ServerFile | Where-Object { $_ -match '\S' -and $_ -notmatch '^\s*#' })
        if ($Raw.Count -eq 0) {
            Write-Host "Server file is empty: $ServerFile" -ForegroundColor Red
            exit 1
        }

        # A CSV may or may not carry a header. Treat the first row as data when
        # its second field is already an IP address, or when it is a single
        # field that is not a known column name.
        $FirstFields = @(ConvertFrom-CsvLine -Line $Raw[0])
        $First = "$($FirstFields[0])".ToLowerInvariant()
        $FirstIsHostHeader = $First -in @('rhost', 'hostname', 'host', 'computer name', 'name', 'server name')
        $SecondIsIp = ($FirstFields.Count -ge 2) -and ($FirstFields[1] -match '^\d{1,3}(\.\d{1,3}){3}$')
        $Headerless = $SecondIsIp -or (($FirstFields.Count -eq 1) -and (-not $FirstIsHostHeader))

        if ($Headerless) {
            # Headerless: positional RHOST,IP (or a bare hostname list).
            $Lookup = $null
            foreach ($Line in $Raw) {
                $Parts = @(ConvertFrom-CsvLine -Line $Line)
                if ($Parts.Count -ge 2) {
                    Add-Server -Rhost "$($Parts[0])" -Ip "$($Parts[1])"
                } elseif ($Parts.Count -eq 1) {
                    if ($null -eq $Lookup) { $Lookup = Get-IpLookup -Path $ExcelLookupFile }
                    $Rhost = "$($Parts[0])"
                    $Key = $Rhost.ToLowerInvariant()
                    if ($Lookup.ContainsKey($Key)) {
                        Add-Server -Rhost $Rhost -Ip $Lookup[$Key]
                    } else {
                        Write-Warning "Host '$Rhost' not found in reference Excel lookup."
                        $script:Failed = $true
                    }
                }
            }
        } else {
            # Headed CSV: find the hostname and IP columns by name, any order.
            $HostIdx = -1
            $IpIdx = -1
            for ($i = 0; $i -lt $FirstFields.Count; $i++) {
                $Name = "$($FirstFields[$i])".ToLowerInvariant()
                if (($HostIdx -lt 0) -and ($Name -in @('rhost', 'hostname', 'host', 'computer name', 'name', 'server name'))) { $HostIdx = $i }
                if (($IpIdx -lt 0) -and ($Name -in @('ip', 'ip address', 'private ip address', 'private_ip', 'address'))) { $IpIdx = $i }
            }
            if ($HostIdx -lt 0) {
                Write-Host "Could not identify a hostname column in CSV header: $($Raw[0])" -ForegroundColor Red
                exit 1
            }

            if ($IpIdx -lt 0) {
                # Single-column hostname list: resolve IPs from the reference Excel file.
                $Lookup = Get-IpLookup -Path $ExcelLookupFile
                for ($i = 1; $i -lt $Raw.Count; $i++) {
                    $Fields = @(ConvertFrom-CsvLine -Line $Raw[$i])
                    if ($Fields.Count -le $HostIdx) { continue }
                    $Rhost = "$($Fields[$HostIdx])"
                    $Key = $Rhost.ToLowerInvariant()
                    if ($Lookup.ContainsKey($Key)) {
                        Add-Server -Rhost $Rhost -Ip $Lookup[$Key]
                    } else {
                        Write-Warning "Host '$Rhost' not found in reference Excel lookup."
                        $script:Failed = $true
                    }
                }
            } else {
                for ($i = 1; $i -lt $Raw.Count; $i++) {
                    $Fields = @(ConvertFrom-CsvLine -Line $Raw[$i])
                    if (($Fields.Count -le $HostIdx) -or ($Fields.Count -le $IpIdx)) { continue }
                    Add-Server -Rhost "$($Fields[$HostIdx])" -Ip "$($Fields[$IpIdx])"
                }
            }
        }
    }

    ".xlsx" {
        if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
            Write-Host "ImportExcel module is not installed. Install using: Install-Module ImportExcel -Scope CurrentUser" -ForegroundColor Red
            exit 1
        }

        foreach ($Row in (Import-Excel -Path $ServerFile)) {
            $Entry = ConvertTo-ServerRow -Row $Row
            if ($Entry) {
                Add-Server -Rhost $Entry.RHOST -Ip $Entry.IP
            }
        }
    }

    default {
        Write-Host "Unsupported file type '$Extension'. Supported: .txt, .csv, .xlsx" -ForegroundColor Red
        exit 1
    }
}

if ($Servers.Count -eq 0) {
    Write-Host "No valid servers found to process." -ForegroundColor Red
    exit 1
}

# Verify parsed list
$Servers | Format-Table -AutoSize

# Password: use -Password when supplied, otherwise prompt once.
if ([string]::IsNullOrWhiteSpace($Password)) {
    $SecurePassword = Read-Host "Enter password for $Username" -AsSecureString
} else {
    $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $Password = $null
}
$Cred = [pscredential]::new($Username, $SecurePassword)

# Create local output folder
$OutputDir = ".\JAVA"
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

foreach ($Server in $Servers) {
    $Rhost = "$($Server.RHOST)"
    $Ip = "$($Server.IP)"
    $HostFailed = $false

    Write-Host ""
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "Connecting to $Rhost [$Ip]" -ForegroundColor Yellow
    Write-Host "====================================================" -ForegroundColor Cyan

    $Session = $null
    try {
        $Session = New-SSHSession -ComputerName $Ip -Credential $Cred -AcceptKey -ConnectionTimeout 15 -ErrorAction Stop
        Write-Host "SSH connected successfully." -ForegroundColor Green

        Write-Host "Uploading java.sh to remote /tmp..." -ForegroundColor Green
        Set-SFTPItem -SessionId $Session.SessionId -Path ".\Data\BashScripts\java.sh" -Destination "/tmp" -Force -ErrorAction Stop

        Write-Host "Executing java.sh..." -ForegroundColor Green
        # Target hosts are assumed to grant this account passwordless sudo.
        # -n keeps it non-interactive: it fails immediately instead of blocking
        # if NOPASSWD is not actually configured.
        $Command = "chmod +x /tmp/java.sh && sudo -n /tmp/java.sh"
        $Result = Invoke-SSHCommand -SessionId $Session.SessionId -TimeOut 300 -Command $Command -ErrorAction Stop

        if ($Result.Output) { Write-Host ($Result.Output -join [Environment]::NewLine) }
        if ($Result.ExitStatus -ne 0) {
            Write-Host "java.sh exited with status $($Result.ExitStatus)." -ForegroundColor Red
            $HostFailed = $true
        }

        $HostnameResult = Invoke-SSHCommand -SessionId $Session.SessionId -TimeOut 30 -Command "hostname" -ErrorAction SilentlyContinue
        $Hostname = "$($HostnameResult.Output)".Trim()
        if ($Hostname) { Write-Host "Hostname: $Hostname" -ForegroundColor Cyan }

        # Copy the zip report(s) java.sh dropped in /tmp. The /tmp listing is the
        # source of truth, so the download no longer depends on guessing the
        # remote file name from the hostname.
        $RemoteFiles = Get-SFTPChildItem -SessionId $Session.SessionId -Path "/tmp" -ErrorAction Stop
        $Zips = @($RemoteFiles | Where-Object { [System.IO.Path]::GetFileName("$($_.FullName)") -like 'Java_*.zip' })
        if ($Zips.Count -eq 0) {
            $Zips = @($RemoteFiles | Where-Object { [System.IO.Path]::GetFileName("$($_.FullName)") -like '*.zip' })
        }

        if ($Zips.Count -eq 0) {
            Write-Host "No zip report found in /tmp on this host." -ForegroundColor Red
            $HostFailed = $true
        } else {
            $LocalDir = Join-Path $OutputDir $Rhost
            New-Item -ItemType Directory -Path $LocalDir -Force | Out-Null
            foreach ($Zip in $Zips) {
                $RemotePath = "$($Zip.FullName)"
                $ZipName = Split-Path -Leaf $RemotePath
                Get-SFTPItem -SessionId $Session.SessionId -Path $RemotePath -Destination $LocalDir -Force -ErrorAction Stop
                Write-Host "Saved: $(Join-Path $LocalDir $ZipName)" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Host "Failed to process $Rhost [$Ip]: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Error    : $($_.Exception.Message)"
        if ($null -ne $_.InvocationInfo) {
            Write-Host "Line     : $($_.InvocationInfo.ScriptLineNumber)"
            Write-Host "Command  : $($_.InvocationInfo.Line)"
        }
        $HostFailed = $true
    }
    finally {
        if ($null -ne $Session) {
            Remove-SSHSession -SessionId $Session.SessionId | Out-Null
        }
    }

    if ($HostFailed) { $script:Failed = $true }
}

if ($script:Failed) {
    Write-Host ""
    Write-Host "One or more servers failed. See the messages above." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "All servers processed. Reports saved under $OutputDir" -ForegroundColor Green
exit 0
