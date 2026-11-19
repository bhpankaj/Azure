[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, HelpMessage = "Path to a TXT, CSV or XLSX file containing hostnames and IPs. Defaults to the bundled Linux server list.")]
    [string]$ServerFile = ".\Data\LinuxServers\LinuxServersListLatest.xlsx",

    [string]$Username = "ansiblesrv",

    [Parameter(HelpMessage = "Enable CSV parsing for -ServerFile. CSV files are also auto-detected by header/content.")]
    [switch]$Csv,

    [Parameter(HelpMessage = "Optional path to a local shell script (.sh) copied to every reachable target before the connectivity test.")]
    [string]$ScriptFile,

    [Parameter(HelpMessage = "Optional remote path of a file to download from every reachable target (e.g. /var/log/syslog).")]
    [string]$RemoteFile,

    [Parameter(HelpMessage = "Local folder for -RemoteFile downloads. Defaults to .\Downloads.")]
    [string]$DownloadDir = ".\Downloads",

    [Parameter(HelpMessage = "Local name for a downloaded file. Same name is reused for every host unless -UseHostname is set.")]
    [string]$OutFile,

    [Parameter(HelpMessage = "Name each downloaded file '<RHOST>_<remote filename>' so hosts cannot overwrite each other.")]
    [switch]$UseHostname,

    [Parameter(HelpMessage = "SSH password for -Username. If omitted you are prompted.")]
    [string]$Password
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------- helpers

function Write-Step {
    param([string]$Text)
    Write-Host ''
    Write-Host ">>> $Text" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Text)
    Write-Host "    [OK] $Text" -ForegroundColor Green
}

function Write-Bad {
    param([string]$Text)
    Write-Host "    [FAIL] $Text" -ForegroundColor Red
}

function Write-Skip {
    param([string]$Text)
    Write-Host "    [SKIP] $Text" -ForegroundColor DarkGray
}

# Reads the private (unshared) fields of a PSCustomObject on every PowerShell version,
# including pwsh 7.4+ where $obj.PSObject.Properties no longer exposes NoteProperty values.
function Get-ObjectFields {
    param([object]$Object)
    $Fields = [ordered]@{}
    if ($null -eq $Object) { return $Fields }
    foreach ($Prop in $Object.PSObject.Properties) {
        if ($Prop.MemberType -notin @('NoteProperty', 'Property')) { continue }
        try   { $Fields[$Prop.Name] = $Prop.GetValue($Object) }
        catch { $Fields[$Prop.Name] = $Prop.Value }
    }
    return $Fields
}

# Case-insensitive lookup of a column name that may be quoted or padded.
function Get-RowValue {
    param([object]$Row, [string[]]$Names)

    $Fields = Get-ObjectFields -Object $Row
    foreach ($Name in $Names) {
        foreach ($Key in $Fields.Keys) {
            $Clean = ($Key -replace '["'']', '').Trim()
            if ($Clean -ieq $Name) { return [string]$Fields[$Key] }
        }
    }
    return $null
}

function Test-PoshSshAvailable {
    if (-not (Get-Module -ListAvailable -Name Posh-SSH)) {
        Write-Error "Posh-SSH module is not installed. Install it with: Install-Module Posh-SSH -Scope CurrentUser -Force"
        exit 1
    }
    if (-not (Get-Command New-SSHSession -ErrorAction SilentlyContinue)) {
        try { Import-Module Posh-SSH -ErrorAction Stop }
        catch {
            Write-Error "Posh-SSH module is installed but could not be imported: $($_.Exception.Message)"
            exit 1
        }
    }
}

# Normalises a host value (optionally "user@host" or "host:port") to its hostname part.
function Get-HostNamePart {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return '' }
    $HostPart = $Value.Trim()
    if ($HostPart -match '^[^@/]+@(.+)$') { $HostPart = $Matches[1] }
    if ($HostPart -match '^\[(.+)\]:\d+$') { return $Matches[1] }   # [v6]:port
    if ($HostPart -match '^([^:]+):\d+$') { return $Matches[1] }    # host:port
    return $HostPart
}

# Remote path of the copied script, used for both the upload target and the exec command.
function Get-RemoteScriptPath {
    param([string]$LocalPath)
    $Name = Split-Path -Leaf $LocalPath
    if ([string]::IsNullOrWhiteSpace($Name)) { $Name = 'sshcheck-script.sh' }
    return "/tmp/$Name"
}

# ---------------------------------------------------------------- prerequisites

$PoshSshReady = [bool](Get-Command New-SSHSession -ErrorAction SilentlyContinue)
if (-not $PoshSshReady) {
    if (-not (Get-Module -ListAvailable -Name Posh-SSH)) {
        Write-Host "Posh-SSH module is not installed; SSH connectivity tests will be skipped." -ForegroundColor Yellow
        Write-Host "Install it with: Install-Module Posh-SSH -Scope CurrentUser -Force" -ForegroundColor Yellow
    }
    else {
        try {
            Import-Module Posh-SSH -ErrorAction Stop
            $PoshSshReady = $true
        }
        catch {
            Write-Host "Posh-SSH could not be imported ($($_.Exception.Message)); SSH connectivity tests will be skipped." -ForegroundColor Yellow
        }
    }
}

# ---------------------------------------------------------------- server list

if (-not (Test-Path -Path $ServerFile)) {
    Write-Error "Server file not found: $ServerFile"
    exit 1
}

$ExcelLookupFile = ".\Data\LinuxServers\LinuxServersListLatest.xlsx"
$Servers         = [System.Collections.Generic.List[PSCustomObject]]::new()
$Extension       = [System.IO.Path]::GetExtension($ServerFile).ToLower()

$HostHeaders  = @('COMPUTER NAME', 'HOSTNAME', 'HOST NAME', 'NAME', 'SERVER NAME', 'SERVERNAME', 'RHOST', 'SERVER', 'HOST')
$IpHeaders    = @('PRIVATE IP ADDRESS', 'IP ADDRESS', 'PRIVATE_IP', 'PRIVATEIP', 'IP', 'IPADDR', 'ADDRESS')
$HostAliases  = @('computer name', 'hostname', 'host name', 'name', 'server name', 'servername', 'rhost', 'server', 'host')
$IpAliases    = @('private ip address', 'ip address', 'private_ip', 'privateip', 'ip', 'ipaddr', 'address')

function Add-ServerEntry {
    param([string]$Rhost, [string]$Ip)

    $Rhost = [string]$Rhost
    if ($Rhost) { $Rhost = $Rhost.Trim() }
    $Ip = [string]$Ip
    if ($Ip) { $Ip = $Ip.Trim() }

    if ([string]::IsNullOrWhiteSpace($Rhost) -and [string]::IsNullOrWhiteSpace($Ip)) { return }

    if ([string]::IsNullOrWhiteSpace($Rhost)) { $Rhost = Get-HostNamePart -Value $Ip }
    if ([string]::IsNullOrWhiteSpace($Ip))     { $Ip    = Get-HostNamePart -Value $Rhost }

    if ([string]::IsNullOrWhiteSpace($Rhost) -and [string]::IsNullOrWhiteSpace($Ip)) { return }

    foreach ($Existing in $Servers) {
        if (($Existing.RHOST -ieq $Rhost) -and ($Existing.IP -ieq $Ip)) { return }
    }

    $Servers.Add([PSCustomObject]@{ RHOST = $Rhost; IP = $Ip })
}

function Test-HeaderLine {
    param([string[]]$Parts)
    if (-not $Parts -or $Parts.Count -eq 0) { return $false }
    foreach ($Part in $Parts) {
        $Token = ($Part -replace '["'']', '').Trim()
        if ($HostAliases -icontains $Token) { return $true }
    }
    return $false
}

function Test-LooksLikeCsv {
    param([string]$Path)
    try {
        $Sample = Get-Content -Path $Path -TotalCount 5 -ErrorAction Stop
    }
    catch { return $false }
    if (-not $Sample) { return $false }
    foreach ($Line in $Sample) {
        if ($Line -match '\s*,\s*') { return $true }
    }
    return $false
}

switch ($Extension) {
    { $_ -in @('.txt', '.csv', '.list', '.hosts') -or $Csv -or (($_ -eq '.txt') -and (Test-LooksLikeCsv -Path $ServerFile)) } {
        $Lines = @(Get-Content -Path $ServerFile -ErrorAction Stop | Where-Object { $_ -match '\S' -and $_ -notmatch '^\s*#' })
        if ($Lines.Count -eq 0) {
            Write-Error "Server file is empty or contains no usable lines: $ServerFile"
            exit 1
        }

        $FirstParts = @($Lines[0] -split '\s+|,')
        $HasHeader  = Test-HeaderLine -Parts $FirstParts
        if ($HasHeader) {
            Write-Host "Header row detected in '$([System.IO.Path]::GetFileName($ServerFile))'; it will be skipped." -ForegroundColor DarkGray
        }
        $DataLines = if ($HasHeader) { $Lines | Select-Object -Skip 1 } else { $Lines }

        # A file where no line carries a second field is a hostname-only list; the IP
        # then has to come from the reference Excel lookup below.
        $SingleColumn = $true
        foreach ($Line in $DataLines) {
            $Parts = @(($Line -split '\s+|,') | Where-Object { $_ -ne '' })
            if ($Parts.Count -ge 2) { $SingleColumn = $false; break }
        }

        foreach ($Line in $DataLines) {
            $Parts = @(($Line -split '\s+|,') | Where-Object { $_ -ne '' })
            if ($Parts.Count -eq 0) { continue }

            if ($SingleColumn) {
                $RhostOnly = $Parts[0].Trim()
                if ($RhostOnly) {
                    $Dup = $false
                    foreach ($Existing in $Servers) { if ($Existing.RHOST -ieq $RhostOnly) { $Dup = $true; break } }
                    if (-not $Dup) { $Servers.Add([PSCustomObject]@{ RHOST = $RhostOnly; IP = '' }) }
                }
                continue
            }

            if ($Parts.Count -eq 1) {
                Add-ServerEntry -Rhost $Parts[0] -Ip ''
                continue
            }

            # A multi-column row is only split into RHOST/IP when no header row announced the layout.
            if (-not $HasHeader) {
                Add-ServerEntry -Rhost $Parts[0] -Ip $Parts[1]
                continue
            }

            # Header-driven CSV layout: map columns by name, fall back to position.
            $HeaderParts = @(($Lines[0] -split '\s+|,') | Where-Object { $_ -ne '' })
            $Rhost = ''
            $Ip    = ''
            for ($i = 0; $i -lt [Math]::Min($HeaderParts.Count, $Parts.Count); $i++) {
                $Col = ($HeaderParts[$i] -replace '["'']', '').Trim()
                if ($HostAliases -icontains $Col) { $Rhost = $Parts[$i] }
                if ($IpAliases   -icontains $Col) { $Ip    = $Parts[$i] }
            }
            if (-not $Rhost) { $Rhost = $Parts[0] }
            if (-not $Ip)    { $Ip    = if ($Parts.Count -ge 2) { $Parts[1] } else { '' } }
            Add-ServerEntry -Rhost $Rhost -Ip $Ip
        }
    }

    '.xlsx' {
        if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
            Write-Error "ImportExcel module is not installed. Install using: Install-Module ImportExcel -Scope CurrentUser"
            exit 1
        }
        try {
            $ImportedData = Import-Excel -Path $ServerFile -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to read Excel file '$ServerFile': $($_.Exception.Message)"
            exit 1
        }
        foreach ($Row in $ImportedData) {
            $Rhost = Get-RowValue -Row $Row -Names $HostHeaders
            $Ip    = Get-RowValue -Row $Row -Names $IpHeaders
            if ($Rhost -or $Ip) {
                Add-ServerEntry -Rhost $Rhost -Ip $Ip
            }
        }
    }

    default {
        Write-Error "Unsupported file type '$Extension'. Supported: .txt, .csv, .xlsx (use -Csv to force CSV parsing)."
        exit 1
    }
}

if ($Servers.Count -eq 0) {
    Write-Error "No valid servers found to process in: $ServerFile"
    exit 1
}

# A single-column list (hostname only, no IP) resolves against the reference Excel file.
$NeedsLookup = @($Servers | Where-Object { [string]::IsNullOrWhiteSpace($_.IP) })
if ($NeedsLookup.Count -gt 0) {
    if (-not (Test-Path -Path $ExcelLookupFile)) {
        Write-Error "IP lookup needed for $($NeedsLookup.Count) host(s) but the reference Excel file was not found: $ExcelLookupFile"
        exit 1
    }
    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        Write-Error "ImportExcel module is required for hostname lookups. Install using: Install-Module ImportExcel -Scope CurrentUser"
        exit 1
    }

    Write-Host "Loading reference Excel data for IP lookup..." -ForegroundColor Cyan
    try {
        $ExcelData = Import-Excel -Path $ExcelLookupFile -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to read reference Excel file '$ExcelLookupFile': $($_.Exception.Message)"
        exit 1
    }

    $Lookup = @{}
    foreach ($Row in $ExcelData) {
        $HostName = Get-RowValue -Row $Row -Names $HostHeaders
        $IpAddr   = Get-RowValue -Row $Row -Names $IpHeaders
        if ($HostName -and $IpAddr) {
            $Lookup[(Get-HostNamePart -Value $HostName).ToLowerInvariant()] = (Get-HostNamePart -Value $IpAddr)
        }
    }

    $Resolved = [System.Collections.Generic.List[PSCustomObject]]::new()
    foreach ($Server in $Servers) {
        if (-not [string]::IsNullOrWhiteSpace($Server.IP)) {
            $Resolved.Add($Server)
            continue
        }
        $Key = (Get-HostNamePart -Value $Server.RHOST).ToLowerInvariant()
        if ($Lookup.ContainsKey($Key)) {
            $Server.IP = $Lookup[$Key]
            $Resolved.Add($Server)
        }
        else {
            Write-Warning "Host '$($Server.RHOST)' not found in reference Excel lookup; entry skipped."
        }
    }
    $Servers = $Resolved
}

if ($Servers.Count -eq 0) {
    Write-Error "No valid servers found to process after IP lookup."
    exit 1
}

# Verify parsed list
$Servers | Format-Table -AutoSize

# ---------------------------------------------------------------- validate optional features

$DoCopy = -not [string]::IsNullOrWhiteSpace($ScriptFile)
if ($DoCopy) {
    if (-not (Test-Path -Path $ScriptFile)) {
        Write-Error "Script file not found: $ScriptFile"
        exit 1
    }
    $ScriptFile = (Resolve-Path -Path $ScriptFile).Path
}

$DoDownload = -not [string]::IsNullOrWhiteSpace($RemoteFile)
if ($DoDownload) {
    if (-not (Test-Path -Path $DownloadDir)) {
        try {
            New-Item -ItemType Directory -Path $DownloadDir -Force -ErrorAction Stop | Out-Null
        }
        catch {
            Write-Error "Download directory '$DownloadDir' does not exist and could not be created: $($_.Exception.Message)"
            exit 1
        }
    }
    $DownloadDir = (Resolve-Path -Path $DownloadDir).Path
    $RemoteLeaf   = Split-Path -Leaf ($RemoteFile -replace '\\', '/')
    if ([string]::IsNullOrWhiteSpace($RemoteLeaf)) { $RemoteLeaf = 'download' }

    if ($UseHostname) {
        # <RHOST>_<remote filename>
    }
    elseif ([string]::IsNullOrWhiteSpace($OutFile)) {
        $UseHostname = $true   # no name given -> per-host naming
    }
    elseif ($Servers.Count -gt 1) {
        Write-Warning "Static -OutFile '$OutFile' will be overwritten by each of the $($Servers.Count) hosts. Use -UseHostname for per-host filenames."
    }
}

# ---------------------------------------------------------------- credentials

# Password: use -Password when supplied, otherwise prompt once.
if ([string]::IsNullOrWhiteSpace($Password)) {
    $SecurePassword = Read-Host "Enter password for $Username" -AsSecureString
} else {
    $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $Password = $null
}
$Cred     = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

# ---------------------------------------------------------------- run

$Successful     = [System.Collections.Generic.List[PSCustomObject]]::new()
$TimeoutServers = [System.Collections.Generic.List[PSCustomObject]]::new()
$AuthFailed     = [System.Collections.Generic.List[PSCustomObject]]::new()
$OtherFailed    = [System.Collections.Generic.List[PSCustomObject]]::new()
$Copied         = [System.Collections.Generic.List[PSCustomObject]]::new()
$CopyFailed     = [System.Collections.Generic.List[PSCustomObject]]::new()
$Downloaded     = [System.Collections.Generic.List[PSCustomObject]]::new()
$DownloadFailed = [System.Collections.Generic.List[PSCustomObject]]::new()

$script:Failed  = $false
$Timestamp      = Get-Date -Format "yyyyMMdd_HHmmss"
$SuccessfulFile = "${Username}_Successful_${Timestamp}.txt"
$TimeoutFile    = "${Username}_Timeout_${Timestamp}.txt"
$AuthFailFile   = "${Username}_AuthFailed_${Timestamp}.txt"
$OtherFailFile  = "${Username}_OtherFailed_${Timestamp}.txt"

Write-Host ''
Write-Host "Starting SSH connectivity tests for $($Servers.Count) host(s)..." -ForegroundColor Cyan
if ($DoCopy)     { Write-Host "Will copy: $ScriptFile" -ForegroundColor Cyan }
if ($DoDownload) { Write-Host "Will download: $RemoteFile" -ForegroundColor Cyan }

$Index = 0
foreach ($Server in $Servers) {
    $Index++
    $HostLabel = if ($Server.IP) { "$($Server.RHOST) [$($Server.IP)]" } else { $Server.RHOST }
    Write-Host ("[{0}/{1}] Testing {2}..." -f $Index, $Servers.Count, $HostLabel) -NoNewline
    $Session = $null

    if (-not $PoshSshReady) {
        Write-Host " [SKIPPED - no Posh-SSH]" -ForegroundColor DarkGray
        $OtherFailed.Add($Server)
        continue
    }

    try {
        $Session = New-SSHSession -ComputerName $Server.IP -Credential $Cred -AcceptKey -ConnectionTimeout 5 -ErrorAction Stop
        if ($null -ne $Session) {
            Write-Host " [SUCCESS]" -ForegroundColor Green
            $Successful.Add($Server)
        }
        else {
            Write-Host " [FAILED]" -ForegroundColor Red
            $OtherFailed.Add($Server)
            continue
        }
    }
    catch {
        $Ex     = $_.Exception
        $ExName = $Ex.GetType().Name
        $ExMsg  = $Ex.Message

        if ($ExMsg -match 'timed out|timeout' -or $ExName -match 'Timeout') {
            Write-Host " [TIMEOUT]" -ForegroundColor Yellow
            $TimeoutServers.Add($Server)
        }
        elseif ($ExMsg -match 'Authentication failed|Permission denied|credentials' -or $ExName -match 'Authentication') {
            Write-Host " [AUTH FAILED]" -ForegroundColor Magenta
            $AuthFailed.Add($Server)
        }
        else {
            Write-Host " [FAILED]" -ForegroundColor Red
            $OtherFailed.Add($Server)
        }
        $script:Failed = $true
        continue
    }

    # ---- optional: copy shell script to the target
    if ($DoCopy -and $null -ne $Session) {
        $RemoteScript = Get-RemoteScriptPath -LocalPath $ScriptFile
        try {
            $RemoteDir = Split-Path -Parent ($RemoteScript -replace '\\', '/')
            $SftpUp = New-SFTPSession -ComputerName $Server.IP -Credential $Cred -AcceptKey -ConnectionTimeout 5 -ErrorAction Stop
            try {
                Set-SFTPItem -SFTPSession $SftpUp -Path $ScriptFile -Destination $RemoteDir -Force -ErrorAction Stop
            }
            finally {
                Remove-SFTPSession -SFTPSession $SftpUp -ErrorAction SilentlyContinue | Out-Null
            }

            $Null = Invoke-SSHCommand -SSHSession $Session -Command "chmod +x '$RemoteScript'" -ErrorAction Stop -TimeOut 10
            Write-Host "      copied -> $RemoteScript" -ForegroundColor DarkGray
            $Copied.Add([PSCustomObject]@{ RHOST = $Server.RHOST; IP = $Server.IP; RemotePath = $RemoteScript })
        }
        catch {
            Write-Host "      copy failed: $($_.Exception.Message)" -ForegroundColor Yellow
            $CopyFailed.Add([PSCustomObject]@{ RHOST = $Server.RHOST; IP = $Server.IP; Error = $_.Exception.Message })
            $script:Failed = $true
        }
    }

    # ---- optional: download a file from the target
    if ($DoDownload -and $null -ne $Session) {
        $LocalName = if ($UseHostname) { "$($Server.RHOST)_$RemoteLeaf" } else { $OutFile }
        if ([string]::IsNullOrWhiteSpace($LocalName)) { $LocalName = "$($Server.RHOST)_$RemoteLeaf" }
        $LocalPath = Join-Path -Path $DownloadDir -ChildPath $LocalName

        try {
            # Remote file must exist before attempting a transfer.
            $Stat = Invoke-SSHCommand -SSHSession $Session -Command "test -f '$RemoteFile'" -ErrorAction Stop -TimeOut 10
            if ($Stat.ExitStatus -ne 0) {
                throw "Remote file not found: $RemoteFile"
            }

            $Sftp = New-SFTPSession -ComputerName $Server.IP -Credential $Cred -AcceptKey -ConnectionTimeout 5 -ErrorAction Stop
            try {
                Get-SFTPItem -SFTPSession $Sftp -Path $RemoteFile -Destination $DownloadDir -Force -ErrorAction Stop
            }
            finally {
                Remove-SFTPSession -SFTPSession $Sftp -ErrorAction SilentlyContinue | Out-Null
            }

            # Get-SFTPItem keeps the remote leaf name; rename to the requested local name.
            $Fetched = Join-Path -Path $DownloadDir -ChildPath $RemoteLeaf
            if (($LocalName -ne $RemoteLeaf) -and (Test-Path -Path $Fetched)) {
                Move-Item -Path $Fetched -Destination $LocalPath -Force -ErrorAction Stop
            }

            if (-not (Test-Path -Path $LocalPath)) {
                throw "Download finished but '$LocalPath' was not found."
            }
            $Size = (Get-Item -Path $LocalPath).Length
            Write-Host "      downloaded -> $LocalPath ($Size bytes)" -ForegroundColor DarkGray
            $Downloaded.Add([PSCustomObject]@{ RHOST = $Server.RHOST; IP = $Server.IP; RemotePath = $RemoteFile; LocalPath = $LocalPath; Size = $Size })
        }
        catch {
            Write-Host "      download failed: $($_.Exception.Message)" -ForegroundColor Yellow
            $DownloadFailed.Add([PSCustomObject]@{ RHOST = $Server.RHOST; IP = $Server.IP; RemotePath = $RemoteFile; Error = $_.Exception.Message })
            $script:Failed = $true
        }
    }

    if ($null -ne $Session) {
        Remove-SSHSession -SessionId $Session.SessionId -ErrorAction SilentlyContinue | Out-Null
    }
}

# ---------------------------------------------------------------- report

Write-Host "`n"
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "                 CONNECTION REPORT                  " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

Write-Host "`n[+] Successful Connections ($($Successful.Count)):" -ForegroundColor Green
if ($Successful.Count -gt 0) {
    $Successful | Format-Table -AutoSize
    $Successful | Out-File $SuccessfulFile
    Write-Host "Saved to: $SuccessfulFile" -ForegroundColor Green
}
else { Write-Host "  (None)" -ForegroundColor Gray }

Write-Host "`n[!] Timeout / Unreachable Servers ($($TimeoutServers.Count)):" -ForegroundColor Yellow
if ($TimeoutServers.Count -gt 0) {
    $TimeoutServers | Format-Table -AutoSize
    $TimeoutServers | Out-File $TimeoutFile
    Write-Host "Saved to: $TimeoutFile" -ForegroundColor Yellow
}
else { Write-Host "  (None)" -ForegroundColor Gray }

Write-Host "`n[x] Authentication / Invalid Password ($($AuthFailed.Count)):" -ForegroundColor Magenta
if ($AuthFailed.Count -gt 0) {
    $AuthFailed | Format-Table -AutoSize
    $AuthFailed | Out-File $AuthFailFile
    Write-Host "Saved to: $AuthFailFile" -ForegroundColor Magenta
}
else { Write-Host "  (None)" -ForegroundColor Gray }

Write-Host "`n[-] Other Failures ($($OtherFailed.Count)):" -ForegroundColor Red
if ($OtherFailed.Count -gt 0) {
    $OtherFailed | Format-Table -AutoSize
    $OtherFailed | Out-File $OtherFailFile
    Write-Host "Saved to: $OtherFailFile" -ForegroundColor Red
}
else { Write-Host "  (None)" -ForegroundColor Gray }

if ($DoCopy) {
    Write-Host "`n[^] Script Copied ($($Copied.Count)):" -ForegroundColor Cyan
    if ($Copied.Count -gt 0) {
        $Copied | Format-Table -AutoSize
    }
    else { Write-Host "  (None)" -ForegroundColor Gray }

    Write-Host "`n[v] Script Copy Failures ($($CopyFailed.Count)):" -ForegroundColor Yellow
    if ($CopyFailed.Count -gt 0) { $CopyFailed | Format-Table -AutoSize }
    else { Write-Host "  (None)" -ForegroundColor Gray }
}

if ($DoDownload) {
    Write-Host "`n[<] Files Downloaded ($($Downloaded.Count)):" -ForegroundColor Cyan
    if ($Downloaded.Count -gt 0) {
        $Downloaded | Format-Table -AutoSize
    }
    else { Write-Host "  (None)" -ForegroundColor Gray }

    Write-Host "`n[>] Download Failures ($($DownloadFailed.Count)):" -ForegroundColor Yellow
    if ($DownloadFailed.Count -gt 0) { $DownloadFailed | Format-Table -AutoSize }
    else { Write-Host "  (None)" -ForegroundColor Gray }
}

Write-Host "====================================================" -ForegroundColor Cyan

if ($script:Failed) { exit 1 } else { exit 0 }
