Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-KazikluFileBinding {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][long]$Size,
        [Parameter(Mandatory=$true)][string]$Sha256
    )
    [pscustomobject]@{
        Name = $Name
        Size = $Size
        Sha256 = $Sha256.ToUpperInvariant()
    }
}

function Get-KazikluProductionContract {
    $files = @(
        (New-KazikluFileBinding 'as.ini' 420 'B83563B88A41A07A31B10F8C6D6441DC393FFB1BE2C4054D969E2484C44F5CA9')
        (New-KazikluFileBinding 'data.dat' 1718971392 'BCF75746F4C2F550B070DE77B08E185AE79DFAD0A370F2611C6AF448257D31CB')
        (New-KazikluFileBinding 'ds.ini' 2749 '6EC9AA069244844EF18C1A77CD35D781CFE56653498F9D6374B3C9DD10F38C17')
        (New-KazikluFileBinding 'GameuxInstallHelper.dll' 106496 'A627788E649BCF0EC9122AB91DA1079399D267A0DB3132AB3B8FA56B0CD75A04')
        (New-KazikluFileBinding 'gdiplus.dll' 1645320 'F1DA32183B3DA19F75FA4EF0974A64895266B16D119BBB1DA9FE63867DBA0645')
        (New-KazikluFileBinding 'light_bana.bmp' 24056 '70509CBE95E4DCBAC69316B4B7FB34159E5347EB83739B096BE0C47832444C46')
        (New-KazikluFileBinding 'malie.exe' 4123648 '7DCF8ECA7288E787A93A405C2818B19BD3B367830B72D3188B09042E2304D963')
        (New-KazikluFileBinding 'malie.ini' 2882 'ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712')
        (New-KazikluFileBinding 'maliesetup.dll' 98304 '1C8034F3E140B0F8B0E6CCB6B4D3F043BFF54F9D39DA70ABA1E1EAD3AB6C0F1E')
        (New-KazikluFileBinding 'README.txt' 338 '7C28C990A190A0FD7CE7B47BE461E73078E5FC5A8E7EFEAAE9A64CC564FB6E0A')
        (New-KazikluFileBinding 'steam_api.dll' 1240064 '701E7DF41A6B16A9179716DC0A24956A8D80D0085BBF980829122AE576F8F6CF')
        (New-KazikluFileBinding 'unicows.dll' 258352 'F06F36FA03A5DB4980C9D1120ADA1D9E558515BE73EFF5B7CD34C48C0D9AFD35')
    )
    [pscustomobject]@{
        Schema = 'dies-irae-kaziklu-kr.savepath-contract.v3'
        ContractId = 'kaziklu-en-original-12files-data3-malieini-v8'
        ReleaseVersion = '1.0.2'
        OverlayName = 'data3.dat'
        ManagedIniName = 'malie.ini'
        Data3Size = 23725056
        Data3Sha256 = '8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E'
        PatchedIniSize = 2880
        PatchedIniSha256 = '6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70'
        BaselineFiles = $files
    }
}

function Assert-KazikluSha256Text {
    param([Parameter(Mandatory=$true)][string]$Value, [Parameter(Mandatory=$true)][string]$Label)
    if ($Value -notmatch '^[0-9A-Fa-f]{64}$') {
        throw "$Label 값은 64자리 SHA-256이어야 합니다."
    }
}

function Get-KazikluSha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Get-KazikluCanonicalDirectory {
    param([Parameter(Mandatory=$true)][string]$Path)
    $full = [IO.Path]::GetFullPath($Path)
    $root = [IO.Path]::GetPathRoot($full)
    $trimChars = [char[]]@([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    $trimmed = $full.TrimEnd($trimChars)
    $rootTrimmed = $root.TrimEnd($trimChars)
    if ([string]::Equals($trimmed, $rootTrimmed, [StringComparison]::OrdinalIgnoreCase)) {
        return $root
    }
    return $trimmed
}

function Get-KazikluDirectoryPrefix {
    param([Parameter(Mandatory=$true)][string]$Path)
    $canonical = Get-KazikluCanonicalDirectory $Path
    $root = [IO.Path]::GetPathRoot($canonical)
    if ([string]::Equals($canonical, $root, [StringComparison]::OrdinalIgnoreCase)) {
        return $root
    }
    return $canonical + [IO.Path]::DirectorySeparatorChar
}

function Test-KazikluPathOverlap {
    param([Parameter(Mandatory=$true)][string]$Left, [Parameter(Mandatory=$true)][string]$Right)
    $leftCanonical = Get-KazikluCanonicalDirectory $Left
    $rightCanonical = Get-KazikluCanonicalDirectory $Right
    $leftPrefix = Get-KazikluDirectoryPrefix $Left
    $rightPrefix = Get-KazikluDirectoryPrefix $Right
    return [string]::Equals($leftCanonical, $rightCanonical, [StringComparison]::OrdinalIgnoreCase) -or
        $leftPrefix.StartsWith($rightPrefix, [StringComparison]::OrdinalIgnoreCase) -or
        $rightPrefix.StartsWith($leftPrefix, [StringComparison]::OrdinalIgnoreCase)
}

function Assert-KazikluNoReparseAncestry {
    param([Parameter(Mandatory=$true)][string]$Path, [Parameter(Mandatory=$true)][string]$Label)
    $current = [IO.Path]::GetFullPath($Path)
    while (-not (Test-Path -LiteralPath $current)) {
        $parent = Split-Path -Parent $current
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $current) { break }
        $current = $parent
    }
    while (-not [string]::IsNullOrWhiteSpace($current)) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "$Label 경로의 상위 요소가 링크 또는 재분석 지점입니다: $current"
            }
        }
        $parent = Split-Path -Parent $current
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $current) { break }
        $current = $parent
    }
}

function Get-KazikluSafeChildPath {
    param([Parameter(Mandatory=$true)][string]$Root, [Parameter(Mandatory=$true)][string]$Relative)
    if ([string]::IsNullOrWhiteSpace($Relative) -or [IO.Path]::IsPathRooted($Relative)) {
        throw "안전하지 않은 상대 경로입니다: $Relative"
    }
    $parts = @($Relative -split '[\\/]')
    if ($parts.Count -eq 0 -or @($parts | Where-Object { $_ -eq '' -or $_ -eq '.' -or $_ -eq '..' }).Count -gt 0) {
        throw "안전하지 않은 상대 경로입니다: $Relative"
    }
    $rootCanonical = Get-KazikluCanonicalDirectory $Root
    $rootPrefix = Get-KazikluDirectoryPrefix $Root
    $target = [IO.Path]::GetFullPath((Join-Path $rootCanonical $Relative))
    if (-not $target.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "관리 경로가 루트를 벗어났습니다: $target"
    }
    Assert-KazikluNoReparseAncestry $target 'managed'
    return $target
}

function Get-KazikluPathId {
    param([Parameter(Mandatory=$true)][string]$Path)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [Text.Encoding]::UTF8.GetBytes(([IO.Path]::GetFullPath($Path)).ToUpperInvariant())
        $digest = $sha.ComputeHash($bytes)
    } finally {
        $sha.Dispose()
    }
    (-join ($digest | ForEach-Object { $_.ToString('x2') })).Substring(0, 24)
}

function Get-KazikluDefaultStateRoot {
    $localAppData = [Environment]::GetFolderPath('LocalApplicationData')
    if ([string]::IsNullOrWhiteSpace($localAppData)) {
        throw 'LocalApplicationData를 확인할 수 없습니다. 게임과 패키지 밖의 -StateRoot를 지정하십시오.'
    }
    Join-Path $localAppData 'DiesIraeKazikluBeyKR'
}

function Get-KazikluStatePaths {
    param([Parameter(Mandatory=$true)][string]$GameDir, [Parameter(Mandatory=$true)][string]$StateRoot)
    $gameStateRoot = Join-Path $StateRoot (Get-KazikluPathId $GameDir)
    [pscustomobject]@{
        GameStateRoot = $gameStateRoot
        BackupRoot = Join-Path $gameStateRoot 'backups'
        ActiveManifest = Join-Path $gameStateRoot 'active_manifest.json'
        Journal = Join-Path $gameStateRoot 'transaction_in_progress.json'
    }
}

function Assert-KazikluFileBinding {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$ExpectedSha256,
        [Nullable[long]]$ExpectedSize = $null,
        [string]$Label = 'file'
    )
    Assert-KazikluSha256Text $ExpectedSha256 "$Label SHA-256"
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Label 파일이 없습니다: $Path"
    }
    Assert-KazikluNoReparseAncestry $Path $Label
    $item = Get-Item -LiteralPath $Path -Force
    if ($null -ne $ExpectedSize -and [long]$item.Length -ne [long]$ExpectedSize) {
        throw "$Label 크기 불일치: $Path (예상=$ExpectedSize 실제=$($item.Length))"
    }
    $actual = Get-KazikluSha256 $Path
    if ($actual -ne $ExpectedSha256.ToUpperInvariant()) {
        throw "$Label 해시 불일치: $Path (예상=$($ExpectedSha256.ToUpperInvariant()) 실제=$actual)"
    }
}

function Get-KazikluBindingByName {
    param([Parameter(Mandatory=$true)][object]$Contract, [Parameter(Mandatory=$true)][string]$Name)
    $matches = @($Contract.BaselineFiles | Where-Object { [string]$_.Name -ieq $Name })
    if ($matches.Count -ne 1) { throw "계약에 정확히 하나의 $Name 항목이 필요합니다." }
    return $matches[0]
}

function Assert-KazikluBaselineContract {
    param([Parameter(Mandatory=$true)][object]$Contract)
    $files = @($Contract.BaselineFiles)
    if ($files.Count -ne 12) { throw 'baseline 계약은 정확히 12개 파일이어야 합니다.' }
    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($binding in $files) {
        $name = [string]$binding.Name
        if ([string]::IsNullOrWhiteSpace($name) -or [IO.Path]::IsPathRooted($name) -or $name -match '[\\/]') {
            throw "baseline 계약의 파일명이 안전하지 않습니다: $name"
        }
        if (-not $seen.Add($name)) { throw "baseline 계약에 중복 파일명이 있습니다: $name" }
        if ([long]$binding.Size -lt 0) { throw "baseline 크기가 잘못되었습니다: $name" }
        Assert-KazikluSha256Text ([string]$binding.Sha256) "$name baseline"
    }
    if (-not $seen.Contains([string]$Contract.ManagedIniName)) { throw 'baseline에 malie.ini가 없습니다.' }
    if (-not $seen.Contains('data.dat')) { throw 'baseline에 data.dat가 없습니다.' }
    if ($seen.Contains([string]$Contract.OverlayName)) { throw 'baseline에 data3.dat가 있어서는 안 됩니다.' }
}

function Assert-KazikluPristineBaseline {
    param([Parameter(Mandatory=$true)][string]$GameDir, [Parameter(Mandatory=$true)][object]$Contract)
    Assert-KazikluBaselineContract $Contract
    if (-not (Test-Path -LiteralPath $GameDir -PathType Container)) {
        throw "게임 폴더가 없습니다: $GameDir"
    }
    $actualFiles = @(Get-ChildItem -LiteralPath $GameDir -File -Force)
    $expectedNames = @($Contract.BaselineFiles | ForEach-Object { [string]$_.Name })
    $actualNames = @($actualFiles | ForEach-Object { [string]$_.Name })
    $difference = @(Compare-Object -ReferenceObject $expectedNames -DifferenceObject $actualNames -CaseSensitive:$false)
    if ($actualFiles.Count -ne 12 -or $difference.Count -ne 0) {
        throw "게임 폴더가 정확한 원본 12파일 baseline이 아닙니다. 예상=12 실제=$($actualFiles.Count) 차이=$($difference.Count)"
    }
    foreach ($binding in $Contract.BaselineFiles) {
        $path = Get-KazikluSafeChildPath $GameDir ([string]$binding.Name)
        Assert-KazikluFileBinding $path ([string]$binding.Sha256) ([long]$binding.Size) "baseline/$($binding.Name)"
    }
}

function Assert-KazikluPayload {
    param(
        [Parameter(Mandatory=$true)][string]$Data3Path,
        [Parameter(Mandatory=$true)][string]$Data3Sha256,
        [Parameter(Mandatory=$true)][string]$PatchedIniPath,
        [Parameter(Mandatory=$true)][string]$PatchedIniSha256,
        [Parameter(Mandatory=$true)][object]$Contract
    )
    Assert-KazikluBaselineContract $Contract
    Assert-KazikluSha256Text $Data3Sha256 'data3 payload'
    Assert-KazikluSha256Text $PatchedIniSha256 'patched malie.ini payload'
    if ($Data3Sha256.ToUpperInvariant() -ne ([string]$Contract.Data3Sha256).ToUpperInvariant()) { throw 'CLI data3 SHA-256이 v8 release 계약과 다릅니다.' }
    if ($PatchedIniSha256.ToUpperInvariant() -ne ([string]$Contract.PatchedIniSha256).ToUpperInvariant()) { throw 'CLI patched malie.ini SHA-256이 v8 release 계약과 다릅니다.' }
    if (-not [string]::Equals([IO.Path]::GetFileName($Data3Path), [string]$Contract.OverlayName, [StringComparison]::OrdinalIgnoreCase)) { throw "overlay basename은 반드시 $($Contract.OverlayName)여야 합니다." }
    if (-not [string]::Equals([IO.Path]::GetFileName($PatchedIniPath), [string]$Contract.ManagedIniName, [StringComparison]::OrdinalIgnoreCase)) { throw "INI basename은 반드시 $($Contract.ManagedIniName)여야 합니다." }
    $originalIni = Get-KazikluBindingByName $Contract ([string]$Contract.ManagedIniName)
    if ($PatchedIniSha256.ToUpperInvariant() -eq ([string]$originalIni.Sha256).ToUpperInvariant()) { throw 'patched malie.ini가 원본과 동일합니다.' }
    Assert-KazikluFileBinding ([IO.Path]::GetFullPath($Data3Path)) $Data3Sha256 ([long]$Contract.Data3Size) 'payload/data3.dat'
    Assert-KazikluFileBinding ([IO.Path]::GetFullPath($PatchedIniPath)) $PatchedIniSha256 ([long]$Contract.PatchedIniSize) 'payload/malie.ini'
}

function Get-KazikluLiveProcessRecords {
    $records = @()
    foreach ($process in @(Get-Process -Name 'malie' -ErrorAction SilentlyContinue)) {
        try {
            $records += [pscustomobject]@{ Id = $process.Id; Path = [string]$process.Path }
        } catch {
            continue
        }
    }
    return $records
}

function Assert-KazikluGameStopped {
    param(
        [Parameter(Mandatory=$true)][string]$GameDir,
        [AllowNull()][object[]]$ProcessRecords = $null
    )
    if ($null -eq $ProcessRecords) { $ProcessRecords = @(Get-KazikluLiveProcessRecords) }
    $targetPath = [IO.Path]::GetFullPath((Join-Path $GameDir 'malie.exe'))
    foreach ($record in @($ProcessRecords)) {
        try { $processPath = [IO.Path]::GetFullPath([string]$record.Path) } catch { continue }
        if ([string]::Equals($processPath, $targetPath, [StringComparison]::OrdinalIgnoreCase)) {
            throw "대상 malie.exe가 실행 중입니다: $processPath"
        }
    }
}

function Write-KazikluJsonAtomic {
    param([Parameter(Mandatory=$true)][string]$Path, [Parameter(Mandatory=$true)][object]$Value)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    $temporary = $Path + '.tmp-' + [Guid]::NewGuid().ToString('N')
    $json = $Value | ConvertTo-Json -Depth 12
    $utf8 = New-Object Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($temporary, $json, $utf8)
    Move-Item -LiteralPath $temporary -Destination $Path -Force
}

function Install-KazikluVerifiedFile {
    param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][string]$Destination,
        [Parameter(Mandatory=$true)][string]$ExpectedSha256,
        [Nullable[long]]$ExpectedSize = $null
    )
    Assert-KazikluFileBinding $Source $ExpectedSha256 $ExpectedSize 'incoming source'
    $parent = Split-Path -Parent $Destination
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    $incoming = $Destination + '.kaziklu-kr.incoming'
    if (Test-Path -LiteralPath $incoming -PathType Leaf) { Remove-Item -LiteralPath $incoming -Force }
    Copy-Item -LiteralPath $Source -Destination $incoming -Force
    Assert-KazikluFileBinding $incoming $ExpectedSha256 $ExpectedSize 'incoming staged'
    Move-Item -LiteralPath $incoming -Destination $Destination -Force
    Assert-KazikluFileBinding $Destination $ExpectedSha256 $ExpectedSize 'installed'
}

function Assert-KazikluExternalRoots {
    param(
        [Parameter(Mandatory=$true)][string]$GameDir,
        [Parameter(Mandatory=$true)][string]$PackageRoot,
        [Parameter(Mandatory=$true)][string]$StateRoot
    )
    foreach ($pair in @(@($GameDir, 'GameDir'), @($PackageRoot, 'PackageRoot'), @($StateRoot, 'StateRoot'))) {
        Assert-KazikluNoReparseAncestry ([string]$pair[0]) ([string]$pair[1])
    }
    if (Test-KazikluPathOverlap $GameDir $PackageRoot) { throw '게임 폴더와 패키지 폴더는 서로 겹치지 않아야 합니다.' }
    if ((Test-KazikluPathOverlap $StateRoot $GameDir) -or (Test-KazikluPathOverlap $StateRoot $PackageRoot)) {
        throw 'StateRoot는 게임 및 패키지 폴더 밖에 있어야 합니다.'
    }
}

function Read-KazikluActiveState {
    param(
        [Parameter(Mandatory=$true)][string]$GameDir,
        [Parameter(Mandatory=$true)][string]$StateRoot,
        [Parameter(Mandatory=$true)][object]$Contract,
        [Parameter(Mandatory=$true)][string]$Data3Sha256,
        [Parameter(Mandatory=$true)][string]$PatchedIniSha256
    )
    Assert-KazikluSha256Text $Data3Sha256 'data3 payload'
    Assert-KazikluSha256Text $PatchedIniSha256 'patched malie.ini payload'
    if ($Data3Sha256.ToUpperInvariant() -ne ([string]$Contract.Data3Sha256).ToUpperInvariant()) { throw 'CLI data3 SHA-256이 v8 release 계약과 다릅니다.' }
    if ($PatchedIniSha256.ToUpperInvariant() -ne ([string]$Contract.PatchedIniSha256).ToUpperInvariant()) { throw 'CLI patched malie.ini SHA-256이 v8 release 계약과 다릅니다.' }
    $paths = Get-KazikluStatePaths $GameDir $StateRoot
    if (-not (Test-Path -LiteralPath $paths.ActiveManifest -PathType Leaf)) {
        throw "활성 설치 기록이 없습니다: $($paths.ActiveManifest)"
    }
    Assert-KazikluNoReparseAncestry $paths.ActiveManifest 'ActiveManifest'
    $state = Get-Content -LiteralPath $paths.ActiveManifest -Raw -Encoding UTF8 | ConvertFrom-Json
    if ([string]$state.schema -ne 'dies-irae-kaziklu-kr.savepath-install-state.v3') { throw '활성 설치 기록 스키마가 다릅니다.' }
    if ([string]$state.contractId -ne [string]$Contract.ContractId) { throw '활성 설치 기록의 baseline 계약이 다릅니다.' }
    if (-not [string]::Equals([IO.Path]::GetFullPath([string]$state.gameDir), [IO.Path]::GetFullPath($GameDir), [StringComparison]::OrdinalIgnoreCase)) { throw '활성 설치 기록의 게임 경로가 다릅니다.' }
    if (-not [string]::Equals([IO.Path]::GetFullPath([string]$state.stateRoot), [IO.Path]::GetFullPath($StateRoot), [StringComparison]::OrdinalIgnoreCase)) { throw '활성 설치 기록의 StateRoot가 다릅니다.' }
    if (-not [string]::Equals([IO.Path]::GetFullPath([string]$state.gameStateRoot), [IO.Path]::GetFullPath($paths.GameStateRoot), [StringComparison]::OrdinalIgnoreCase)) { throw '활성 설치 기록의 gameStateRoot가 다릅니다.' }
    if ([string]$state.overlayName -ne [string]$Contract.OverlayName -or [string]$state.managedIniName -ne [string]$Contract.ManagedIniName) {
        throw '활성 설치 기록의 관리 파일명이 다릅니다.'
    }
    if ([string]$state.data3Sha256 -ne $Data3Sha256.ToUpperInvariant()) { throw 'CLI data3 SHA-256과 활성 설치 기록이 다릅니다.' }
    if ([string]$state.patchedIniSha256 -ne $PatchedIniSha256.ToUpperInvariant()) { throw 'CLI patched malie.ini SHA-256과 활성 설치 기록이 다릅니다.' }
    $backupRootCanonical = Get-KazikluCanonicalDirectory $paths.BackupRoot
    $backupRootPrefix = Get-KazikluDirectoryPrefix $paths.BackupRoot
    $backupDirCanonical = Get-KazikluCanonicalDirectory ([string]$state.backupDir)
    if (-not $backupDirCanonical.StartsWith($backupRootPrefix, [StringComparison]::OrdinalIgnoreCase)) { throw '활성 설치 기록의 백업 경로가 관리 범위 밖입니다.' }
    if ((Get-KazikluCanonicalDirectory (Split-Path -Parent $backupDirCanonical)) -ne $backupRootCanonical) { throw '활성 설치 기록의 백업 경로 깊이가 잘못되었습니다.' }
    Assert-KazikluNoReparseAncestry $backupDirCanonical 'BackupDir'
    $backupIni = Get-KazikluSafeChildPath $backupDirCanonical 'malie.ini'
    if (-not [string]::Equals([IO.Path]::GetFullPath([string]$state.backupIniPath), $backupIni, [StringComparison]::OrdinalIgnoreCase)) { throw '활성 설치 기록의 malie.ini 백업 경로가 다릅니다.' }
    $backupManifestPath = Get-KazikluSafeChildPath $backupDirCanonical 'backup_manifest.json'
    if (-not (Test-Path -LiteralPath $backupManifestPath -PathType Leaf)) { throw '백업 manifest가 없습니다.' }
    $backupManifest = Get-Content -LiteralPath $backupManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $originalIni = Get-KazikluBindingByName $Contract ([string]$Contract.ManagedIniName)
    if ([string]$backupManifest.schema -ne 'dies-irae-kaziklu-kr.savepath-backup.v3' -or
        [string]$backupManifest.contractId -ne [string]$Contract.ContractId -or
        [string]$backupManifest.transactionId -ne [string]$state.transactionId -or
        -not [string]::Equals([IO.Path]::GetFullPath([string]$backupManifest.gameDir), [IO.Path]::GetFullPath($GameDir), [StringComparison]::OrdinalIgnoreCase) -or
        [bool]$backupManifest.originalData3Exists -or
        [string]$backupManifest.originalIniSha256 -ne ([string]$originalIni.Sha256).ToUpperInvariant() -or
        [long]$backupManifest.originalIniSize -ne [long]$originalIni.Size) { throw '백업 manifest가 변경되었습니다.' }
    [pscustomobject]@{ State = $state; Paths = $paths; BackupDir = $backupDirCanonical; BackupIni = $backupIni; BackupManifest = $backupManifestPath }
}

function Assert-KazikluInstalledTree {
    param(
        [Parameter(Mandatory=$true)][string]$GameDir,
        [Parameter(Mandatory=$true)][object]$Contract,
        [Parameter(Mandatory=$true)][string]$Data3Sha256,
        [Parameter(Mandatory=$true)][string]$PatchedIniSha256
    )
    $actualFiles = @(Get-ChildItem -LiteralPath $GameDir -File -Force)
    $expectedNames = @($Contract.BaselineFiles | ForEach-Object { [string]$_.Name }) + @([string]$Contract.OverlayName)
    $actualNames = @($actualFiles | ForEach-Object { [string]$_.Name })
    $difference = @(Compare-Object -ReferenceObject $expectedNames -DifferenceObject $actualNames -CaseSensitive:$false)
    if ($actualFiles.Count -ne 13 -or $difference.Count -ne 0) { throw '설치 후 파일 집합이 정확한 13파일 상태가 아닙니다.' }
    foreach ($binding in $Contract.BaselineFiles) {
        $name = [string]$binding.Name
        $path = Get-KazikluSafeChildPath $GameDir $name
        if ($name -ieq [string]$Contract.ManagedIniName) {
            Assert-KazikluFileBinding $path $PatchedIniSha256 ([long]$Contract.PatchedIniSize) 'installed/malie.ini'
        } else {
            Assert-KazikluFileBinding $path ([string]$binding.Sha256) ([long]$binding.Size) "unchanged/$name"
        }
    }
    $data3 = Get-KazikluSafeChildPath $GameDir ([string]$Contract.OverlayName)
    Assert-KazikluFileBinding $data3 $Data3Sha256 ([long]$Contract.Data3Size) 'installed/data3.dat'
}

function Assert-KazikluForceRestorePreflight {
    param([Parameter(Mandatory=$true)][string]$GameDir, [Parameter(Mandatory=$true)][object]$Contract)
    $allowedNames = @($Contract.BaselineFiles | ForEach-Object { [string]$_.Name }) + @([string]$Contract.OverlayName)
    $actualNames = @(Get-ChildItem -LiteralPath $GameDir -File -Force | ForEach-Object { [string]$_.Name })
    $unexpected = @($actualNames | Where-Object { $allowedNames -inotcontains $_ })
    if ($unexpected.Count -ne 0) { throw "강제 복원에서도 비허용 파일은 거부합니다: $($unexpected -join ', ')" }
    foreach ($binding in $Contract.BaselineFiles) {
        $name = [string]$binding.Name
        if ($name -ieq [string]$Contract.ManagedIniName) { continue }
        $path = Get-KazikluSafeChildPath $GameDir $name
        Assert-KazikluFileBinding $path ([string]$binding.Sha256) ([long]$binding.Size) "force-preflight/$name"
    }
}

function Invoke-KazikluInstall {
    param(
        [Parameter(Mandatory=$true)][string]$GameDir,
        [Parameter(Mandatory=$true)][string]$PackageRoot,
        [Parameter(Mandatory=$true)][string]$StateRoot,
        [Parameter(Mandatory=$true)][string]$Data3Path,
        [Parameter(Mandatory=$true)][string]$Data3Sha256,
        [Parameter(Mandatory=$true)][string]$PatchedIniPath,
        [Parameter(Mandatory=$true)][string]$PatchedIniSha256,
        [Parameter(Mandatory=$true)][object]$Contract,
        [AllowNull()][object[]]$ProcessRecords = $null
    )
    $GameDir = [IO.Path]::GetFullPath($GameDir)
    $PackageRoot = [IO.Path]::GetFullPath($PackageRoot)
    $StateRoot = [IO.Path]::GetFullPath($StateRoot)
    Assert-KazikluExternalRoots $GameDir $PackageRoot $StateRoot
    Assert-KazikluBaselineContract $Contract
    $paths = Get-KazikluStatePaths $GameDir $StateRoot
    if (Test-Path -LiteralPath $paths.ActiveManifest -PathType Leaf) { throw "이미 설치된 패치 상태가 있습니다: $($paths.ActiveManifest)" }
    if (Test-Path -LiteralPath $paths.Journal -PathType Leaf) { throw "미완료 설치 journal이 있습니다: $($paths.Journal)" }
    Assert-KazikluGameStopped $GameDir $ProcessRecords
    Assert-KazikluPayload $Data3Path $Data3Sha256 $PatchedIniPath $PatchedIniSha256 $Contract
    Assert-KazikluPristineBaseline $GameDir $Contract

    $transactionId = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ') + '-' + [Guid]::NewGuid().ToString('N')
    $backupDir = Join-Path $paths.BackupRoot $transactionId
    $backupIni = Join-Path $backupDir 'malie.ini'
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    $originalIni = Get-KazikluBindingByName $Contract ([string]$Contract.ManagedIniName)
    $liveIni = Get-KazikluSafeChildPath $GameDir ([string]$Contract.ManagedIniName)
    $liveData3 = Get-KazikluSafeChildPath $GameDir ([string]$Contract.OverlayName)
    Copy-Item -LiteralPath $liveIni -Destination $backupIni -Force
    Assert-KazikluFileBinding $backupIni ([string]$originalIni.Sha256) ([long]$originalIni.Size) 'backup/malie.ini'
    $backupManifest = [ordered]@{
        schema = 'dies-irae-kaziklu-kr.savepath-backup.v3'
        contractId = [string]$Contract.ContractId
        transactionId = $transactionId
        gameDir = $GameDir
        originalIniSha256 = ([string]$originalIni.Sha256).ToUpperInvariant()
        originalIniSize = [long]$originalIni.Size
        originalData3Exists = $false
    }
    Write-KazikluJsonAtomic (Join-Path $backupDir 'backup_manifest.json') $backupManifest
    $journal = [ordered]@{
        schema = 'dies-irae-kaziklu-kr.transaction-journal.v1'
        status = 'in_progress'
        transactionId = $transactionId
        gameDir = $GameDir
        backupDir = $backupDir
        planned = @('malie.ini', 'data3.dat')
    }
    Write-KazikluJsonAtomic $paths.Journal $journal

    try {
        Install-KazikluVerifiedFile ([IO.Path]::GetFullPath($PatchedIniPath)) $liveIni $PatchedIniSha256 ([long]$Contract.PatchedIniSize)
        Install-KazikluVerifiedFile ([IO.Path]::GetFullPath($Data3Path)) $liveData3 $Data3Sha256 ([long]$Contract.Data3Size)
        Assert-KazikluInstalledTree $GameDir $Contract $Data3Sha256 $PatchedIniSha256
        $state = [ordered]@{
            schema = 'dies-irae-kaziklu-kr.savepath-install-state.v3'
            contractId = [string]$Contract.ContractId
            releaseVersion = [string]$Contract.ReleaseVersion
            transactionId = $transactionId
            installedUtc = [DateTime]::UtcNow.ToString('o')
            gameDir = $GameDir
            stateRoot = $StateRoot
            gameStateRoot = $paths.GameStateRoot
            backupDir = $backupDir
            backupIniPath = $backupIni
            overlayName = [string]$Contract.OverlayName
            managedIniName = [string]$Contract.ManagedIniName
            data3Sha256 = $Data3Sha256.ToUpperInvariant()
            patchedIniSha256 = $PatchedIniSha256.ToUpperInvariant()
        }
        Write-KazikluJsonAtomic (Join-Path $backupDir 'install_state.json') $state
        Write-KazikluJsonAtomic $paths.ActiveManifest $state
        Remove-Item -LiteralPath $paths.Journal -Force
        return [pscustomobject]@{ Status='installed'; GameDir=$GameDir; BackupDir=$backupDir; ActiveManifest=$paths.ActiveManifest }
    } catch {
        $installError = $_
        foreach ($temporary in @($liveIni + '.kaziklu-kr.incoming', $liveData3 + '.kaziklu-kr.incoming')) {
            if (Test-Path -LiteralPath $temporary -PathType Leaf) { Remove-Item -LiteralPath $temporary -Force }
        }
        Copy-Item -LiteralPath $backupIni -Destination $liveIni -Force
        if (Test-Path -LiteralPath $liveData3 -PathType Leaf) { Remove-Item -LiteralPath $liveData3 -Force }
        Assert-KazikluPristineBaseline $GameDir $Contract
        if (Test-Path -LiteralPath $paths.ActiveManifest -PathType Leaf) { Remove-Item -LiteralPath $paths.ActiveManifest -Force }
        $journal.status = 'rolled_back'
        $journal.error = [string]$installError.Exception.Message
        Write-KazikluJsonAtomic $paths.Journal $journal
        throw $installError
    }
}

function Invoke-KazikluVerify {
    param(
        [Parameter(Mandatory=$true)][string]$GameDir,
        [Parameter(Mandatory=$true)][string]$PackageRoot,
        [Parameter(Mandatory=$true)][string]$StateRoot,
        [Parameter(Mandatory=$true)][string]$Data3Sha256,
        [Parameter(Mandatory=$true)][string]$PatchedIniSha256,
        [Parameter(Mandatory=$true)][object]$Contract
    )
    $GameDir = [IO.Path]::GetFullPath($GameDir)
    $PackageRoot = [IO.Path]::GetFullPath($PackageRoot)
    $StateRoot = [IO.Path]::GetFullPath($StateRoot)
    Assert-KazikluExternalRoots $GameDir $PackageRoot $StateRoot
    $active = Read-KazikluActiveState $GameDir $StateRoot $Contract $Data3Sha256 $PatchedIniSha256
    $originalIni = Get-KazikluBindingByName $Contract ([string]$Contract.ManagedIniName)
    Assert-KazikluFileBinding $active.BackupIni ([string]$originalIni.Sha256) ([long]$originalIni.Size) 'backup/malie.ini'
    Assert-KazikluInstalledTree $GameDir $Contract $Data3Sha256 $PatchedIniSha256
    return [pscustomobject]@{ Status='verified'; GameDir=$GameDir; BackupDir=$active.BackupDir }
}

function Invoke-KazikluRestore {
    param(
        [Parameter(Mandatory=$true)][string]$GameDir,
        [Parameter(Mandatory=$true)][string]$PackageRoot,
        [Parameter(Mandatory=$true)][string]$StateRoot,
        [Parameter(Mandatory=$true)][string]$Data3Sha256,
        [Parameter(Mandatory=$true)][string]$PatchedIniSha256,
        [Parameter(Mandatory=$true)][object]$Contract,
        [switch]$Force,
        [AllowNull()][object[]]$ProcessRecords = $null
    )
    $GameDir = [IO.Path]::GetFullPath($GameDir)
    $PackageRoot = [IO.Path]::GetFullPath($PackageRoot)
    $StateRoot = [IO.Path]::GetFullPath($StateRoot)
    Assert-KazikluExternalRoots $GameDir $PackageRoot $StateRoot
    Assert-KazikluGameStopped $GameDir $ProcessRecords
    $active = Read-KazikluActiveState $GameDir $StateRoot $Contract $Data3Sha256 $PatchedIniSha256
    $originalIni = Get-KazikluBindingByName $Contract ([string]$Contract.ManagedIniName)
    Assert-KazikluFileBinding $active.BackupIni ([string]$originalIni.Sha256) ([long]$originalIni.Size) 'backup/malie.ini'
    if ($Force) {
        Assert-KazikluForceRestorePreflight $GameDir $Contract
    } else {
        Assert-KazikluInstalledTree $GameDir $Contract $Data3Sha256 $PatchedIniSha256
    }

    $liveIni = Get-KazikluSafeChildPath $GameDir ([string]$Contract.ManagedIniName)
    $liveData3 = Get-KazikluSafeChildPath $GameDir ([string]$Contract.OverlayName)
    $recoveryDir = Join-Path $active.BackupDir ('restore_recovery_' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Force -Path $recoveryDir | Out-Null
    $recoveryStates = @()
    foreach ($managed in @($liveIni, $liveData3)) {
        $exists = Test-Path -LiteralPath $managed -PathType Leaf
        $state = [ordered]@{ path=$managed; exists=[bool]$exists; sha256=$null; copy=$null }
        if ($exists) {
            $state.sha256 = Get-KazikluSha256 $managed
            $state.copy = Join-Path $recoveryDir ([IO.Path]::GetFileName($managed))
            Copy-Item -LiteralPath $managed -Destination $state.copy -Force
            Assert-KazikluFileBinding $state.copy $state.sha256 $null 'restore recovery'
        }
        $recoveryStates += [pscustomobject]$state
    }
    $restoreJournal = Join-Path $active.Paths.GameStateRoot 'restore_in_progress.json'
    Write-KazikluJsonAtomic $restoreJournal ([ordered]@{
        schema='dies-irae-kaziklu-kr.restore-journal.v1'; status='in_progress'; gameDir=$GameDir; recoveryDir=$recoveryDir
    })
    try {
        Install-KazikluVerifiedFile $active.BackupIni $liveIni ([string]$originalIni.Sha256) ([long]$originalIni.Size)
        if (Test-Path -LiteralPath $liveData3 -PathType Leaf) { Remove-Item -LiteralPath $liveData3 -Force }
        Assert-KazikluPristineBaseline $GameDir $Contract
        $marker = Join-Path $active.BackupDir 'uninstalled.txt'
        $utf8 = New-Object Text.UTF8Encoding($false)
        [IO.File]::WriteAllText($marker, ([DateTime]::UtcNow.ToString('o') + "`r`n"), $utf8)
        if (Test-Path -LiteralPath $restoreJournal -PathType Leaf) { Remove-Item -LiteralPath $restoreJournal -Force }
        Remove-Item -LiteralPath $active.Paths.ActiveManifest -Force
        return [pscustomobject]@{ Status='restored'; Force=[bool]$Force; GameDir=$GameDir; BackupDir=$active.BackupDir }
    } catch {
        $restoreError = $_
        foreach ($state in $recoveryStates) {
            if ([bool]$state.exists) {
                Install-KazikluVerifiedFile ([string]$state.copy) ([string]$state.path) ([string]$state.sha256) $null
            } elseif (Test-Path -LiteralPath ([string]$state.path) -PathType Leaf) {
                Remove-Item -LiteralPath ([string]$state.path) -Force
            }
        }
        throw $restoreError
    }
}
