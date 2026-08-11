[CmdletBinding()]
param([string]$OutputRoot = '')

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\KazikluSavePath.Core.ps1')

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path ([IO.Path]::GetTempPath()) ('kaziklu_savepath_v3_fixture_' + [Guid]::NewGuid().ToString('N'))
}
$OutputRoot = [IO.Path]::GetFullPath($OutputRoot)
New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
$results = @()

function Add-Result([string]$Name, [string]$Status, [string]$Detail) {
    $script:results += [pscustomobject]@{ name=$Name; status=$Status; detail=$Detail }
}

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

function Expect-Throw([scriptblock]$Action, [string]$Pattern) {
    $thrown = $false
    try { & $Action } catch {
        $thrown = $true
        if (-not ([string]$_.Exception.Message -match $Pattern)) {
            throw "예상 오류 패턴 '$Pattern'과 다릅니다: $($_.Exception.Message)"
        }
    }
    if (-not $thrown) { throw "예상한 오류가 발생하지 않았습니다: $Pattern" }
}

function Append-Ascii([string]$Path, [string]$Text='tamper') {
    $encoding = New-Object Text.UTF8Encoding($false)
    [IO.File]::AppendAllText($Path, $Text, $encoding)
}

function New-SyntheticCase([string]$Name) {
    $root = Join-Path $OutputRoot $Name
    $game = Join-Path $root 'game'
    $package = Join-Path $root 'package'
    $state = Join-Path $root 'state'
    New-Item -ItemType Directory -Force -Path $game,$package | Out-Null
    $names = @('as.ini','data.dat','ds.ini','GameuxInstallHelper.dll','gdiplus.dll','light_bana.bmp','malie.exe','malie.ini','maliesetup.dll','README.txt','steam_api.dll','unicows.dll')
    foreach ($fileName in $names) {
        if ($fileName -eq 'malie.ini') {
            $originalIni = New-Object 'System.Collections.Generic.List[byte]'
            $originalIni.AddRange([byte[]][Text.Encoding]::ASCII.GetBytes("HEADER`r`nTITLE=Dies irae "))
            $originalIni.Add([byte]0x81); $originalIni.Add([byte]0x60)
            $originalIni.AddRange([byte[]][Text.Encoding]::ASCII.GetBytes('Interview with Kaziklu Bey'))
            $originalIni.Add([byte]0x81); $originalIni.Add([byte]0x60)
            $originalIni.AddRange([byte[]][Text.Encoding]::ASCII.GetBytes("`r`nCOMMENT=0"))
            $originalIni.Add([byte]0x81); $originalIni.Add([byte]0x60)
            $originalIni.AddRange([byte[]][Text.Encoding]::ASCII.GetBytes("100`r`n"))
            [IO.File]::WriteAllBytes((Join-Path $game $fileName), $originalIni.ToArray())
        } else {
            [IO.File]::WriteAllBytes((Join-Path $game $fileName), [Text.Encoding]::UTF8.GetBytes("synthetic-baseline::$fileName::v3"))
        }
    }

    $bindings = @()
    foreach ($fileName in $names) {
        $path = Join-Path $game $fileName
        $bindings += New-KazikluFileBinding $fileName ((Get-Item -LiteralPath $path).Length) (Get-KazikluSha256 $path)
    }

    $files = Join-Path $package 'files'
    New-Item -ItemType Directory -Force -Path $files | Out-Null
    $data3 = Join-Path $files 'data3.dat'
    [IO.File]::WriteAllBytes($data3, [Text.Encoding]::UTF8.GetBytes('synthetic data3 overlay payload v3'))

    $patchedIni = Join-Path $files 'malie.ini'
    [byte[]]$sourceIni = [IO.File]::ReadAllBytes((Join-Path $game 'malie.ini'))
    $titleStart = [Text.Encoding]::ASCII.GetByteCount("HEADER`r`n")
    $titleEnd = $titleStart
    while ($titleEnd -lt $sourceIni.Length -and $sourceIni[$titleEnd] -ne 0x0D) { $titleEnd++ }
    $patchedList = New-Object 'System.Collections.Generic.List[byte]'
    $replaced = 0
    for ($i = 0; $i -lt $sourceIni.Length; $i++) {
        if ($i -ge $titleStart -and $i -lt ($titleEnd - 1) -and $sourceIni[$i] -eq 0x81 -and $sourceIni[$i + 1] -eq 0x60) {
            $patchedList.Add([byte]0x7E)
            $i++
            $replaced++
        } else {
            $patchedList.Add($sourceIni[$i])
        }
    }
    Assert-True ($replaced -eq 2) 'synthetic TITLE patch count가 2가 아닙니다.'
    [IO.File]::WriteAllBytes($patchedIni, $patchedList.ToArray())

    $data3Hash = Get-KazikluSha256 $data3
    $patchedIniHash = Get-KazikluSha256 $patchedIni
    $contract = [pscustomobject]@{
        Schema='dies-irae-kaziklu-kr.savepath-contract.synthetic.v3'
        ContractId=('synthetic-savepath-v3-' + $Name)
        ReleaseVersion='synthetic-savepath-v3'
        OverlayName='data3.dat'
        ManagedIniName='malie.ini'
        Data3Size=[long](Get-Item -LiteralPath $data3).Length
        Data3Sha256=$data3Hash
        PatchedIniSize=[long](Get-Item -LiteralPath $patchedIni).Length
        PatchedIniSha256=$patchedIniHash
        BaselineFiles=$bindings
    }
    [pscustomobject]@{
        Root=$root; Game=$game; Package=$package; State=$state; Contract=$contract
        Data3=$data3; Data3Hash=$data3Hash
        PatchedIni=$patchedIni; PatchedIniHash=$patchedIniHash
        OriginalIniHash=(Get-KazikluSha256 (Join-Path $game 'malie.ini'))
    }
}

function Invoke-InstallCase([object]$Case, [object[]]$ProcessRecords=@()) {
    Invoke-KazikluInstall -GameDir $Case.Game -PackageRoot $Case.Package -StateRoot $Case.State -Data3Path $Case.Data3 -Data3Sha256 $Case.Data3Hash -PatchedIniPath $Case.PatchedIni -PatchedIniSha256 $Case.PatchedIniHash -Contract $Case.Contract -ProcessRecords $ProcessRecords
}

function Invoke-VerifyCase([object]$Case) {
    Invoke-KazikluVerify -GameDir $Case.Game -PackageRoot $Case.Package -StateRoot $Case.State -Data3Sha256 $Case.Data3Hash -PatchedIniSha256 $Case.PatchedIniHash -Contract $Case.Contract
}

function Invoke-RestoreCase([object]$Case, [switch]$Force) {
    Invoke-KazikluRestore -GameDir $Case.Game -PackageRoot $Case.Package -StateRoot $Case.State -Data3Sha256 $Case.Data3Hash -PatchedIniSha256 $Case.PatchedIniHash -Contract $Case.Contract -Force:$Force -ProcessRecords @()
}

try {
    $case = New-SyntheticCase '01_lifecycle'
    $install = Invoke-InstallCase $case
    Assert-KazikluFileBinding (Join-Path $install.BackupDir 'malie.ini') $case.OriginalIniHash $null 'backup/malie.ini'
    [void](Invoke-VerifyCase $case)
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')) -eq $case.PatchedIniHash) 'installed malie.ini 해시가 다릅니다.'
    [void](Invoke-RestoreCase $case)
    Assert-KazikluPristineBaseline $case.Game $case.Contract
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $case.Game 'data3.dat'))) 'restore 뒤 data3.dat가 남았습니다.'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')) -eq $case.OriginalIniHash) '원본 malie.ini가 exact 복구되지 않았습니다.'
    $paths = Get-KazikluStatePaths $case.Game $case.State
    Assert-True (-not (Test-Path -LiteralPath $paths.ActiveManifest)) 'restore 뒤 active manifest가 남았습니다.'
    Add-Result 'install/verify/uninstall exact lifecycle' 'PASS' 'patched INI + data3 installed; backup-bound original INI and exact 12-file baseline restored'

    $case = New-SyntheticCase '02_double_install'
    [void](Invoke-InstallCase $case)
    $iniBefore = Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')
    $data3Before = Get-KazikluSha256 (Join-Path $case.Game 'data3.dat')
    Expect-Throw { [void](Invoke-InstallCase $case) } '이미 설치된 패치 상태'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')) -eq $iniBefore) 'double install 거부 뒤 malie.ini가 바뀌었습니다.'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'data3.dat')) -eq $data3Before) 'double install 거부 뒤 data3.dat가 바뀌었습니다.'
    Add-Result 'double install fail-close' 'PASS' 'active state rejected before managed-file write'

    $case = New-SyntheticCase '03_wrong_baseline'
    Append-Ascii (Join-Path $case.Game 'data.dat')
    Expect-Throw { [void](Invoke-InstallCase $case) } 'baseline/data.dat (크기|해시) 불일치'
    $paths = Get-KazikluStatePaths $case.Game $case.State
    Assert-True (-not (Test-Path -LiteralPath $paths.GameStateRoot)) 'wrong baseline 거부 전에 상태 폴더가 생성됐습니다.'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $case.Game 'data3.dat'))) 'wrong baseline 거부 뒤 data3.dat가 생겼습니다.'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')) -eq $case.OriginalIniHash) 'wrong baseline 거부 뒤 malie.ini가 바뀌었습니다.'
    Add-Result 'wrong 12-file baseline fail-close' 'PASS' 'data.dat drift rejected before state/game write'

    $case = New-SyntheticCase '04_data3_payload_tamper'
    Append-Ascii $case.Data3
    Expect-Throw { [void](Invoke-InstallCase $case) } 'payload/data3.dat (크기|해시) 불일치'
    Assert-KazikluPristineBaseline $case.Game $case.Contract
    $paths = Get-KazikluStatePaths $case.Game $case.State
    Assert-True (-not (Test-Path -LiteralPath $paths.GameStateRoot)) 'data3 payload 거부 전에 상태 폴더가 생성됐습니다.'
    Add-Result 'tampered data3 payload fail-close' 'PASS' 'fixed contract + CLI SHA rejected before state/game write'

    $case = New-SyntheticCase '05_ini_payload_tamper'
    Append-Ascii $case.PatchedIni
    Expect-Throw { [void](Invoke-InstallCase $case) } 'payload/malie.ini (크기|해시) 불일치'
    Assert-KazikluPristineBaseline $case.Game $case.Contract
    $paths = Get-KazikluStatePaths $case.Game $case.State
    Assert-True (-not (Test-Path -LiteralPath $paths.GameStateRoot)) 'INI payload 거부 전에 상태 폴더가 생성됐습니다.'
    Add-Result 'tampered patched INI payload fail-close' 'PASS' 'fixed contract + CLI SHA rejected before state/game write'

    $case = New-SyntheticCase '06_installed_data3_tamper'
    [void](Invoke-InstallCase $case)
    Append-Ascii (Join-Path $case.Game 'data3.dat')
    $iniBefore = Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')
    Expect-Throw { [void](Invoke-RestoreCase $case) } 'installed/data3.dat (크기|해시) 불일치'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')) -eq $iniBefore) 'normal uninstall 거부 전에 malie.ini가 바뀌었습니다.'
    [void](Invoke-RestoreCase $case -Force)
    Assert-KazikluPristineBaseline $case.Game $case.Contract
    Add-Result 'installed data3 tamper then force restore' 'PASS' 'normal uninstall refused; force restore recovered original INI and removed overlay'

    $case = New-SyntheticCase '07_installed_ini_tamper'
    [void](Invoke-InstallCase $case)
    Append-Ascii (Join-Path $case.Game 'malie.ini')
    $data3Before = Get-KazikluSha256 (Join-Path $case.Game 'data3.dat')
    Expect-Throw { [void](Invoke-RestoreCase $case) } 'installed/malie.ini (크기|해시) 불일치'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'data3.dat')) -eq $data3Before) 'normal uninstall 거부 전에 data3.dat가 바뀌었습니다.'
    [void](Invoke-RestoreCase $case -Force)
    Assert-KazikluPristineBaseline $case.Game $case.Contract
    Add-Result 'installed INI tamper then force restore' 'PASS' 'normal uninstall refused; force restore used verified original INI backup'

    $case = New-SyntheticCase '08_backup_bytes_tamper'
    $install = Invoke-InstallCase $case
    $liveIniBefore = Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')
    $liveData3Before = Get-KazikluSha256 (Join-Path $case.Game 'data3.dat')
    Append-Ascii (Join-Path $install.BackupDir 'malie.ini')
    Expect-Throw { [void](Invoke-RestoreCase $case -Force) } 'backup/malie.ini (크기|해시) 불일치'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')) -eq $liveIniBefore) 'backup tamper 거부 전에 live malie.ini가 바뀌었습니다.'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'data3.dat')) -eq $liveData3Before) 'backup tamper 거부 전에 live data3.dat가 바뀌었습니다.'
    Add-Result 'tampered backup bytes fail-close' 'PASS' 'backup bytes verified before first restore write'

    $case = New-SyntheticCase '09_backup_manifest_tamper'
    $install = Invoke-InstallCase $case
    $liveIniBefore = Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')
    $manifestPath = Join-Path $install.BackupDir 'backup_manifest.json'
    $backupManifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $backupManifest.originalIniSize = [long]$backupManifest.originalIniSize + 1
    Write-KazikluJsonAtomic $manifestPath $backupManifest
    Expect-Throw { [void](Invoke-RestoreCase $case -Force) } '백업 manifest가 변경'
    Assert-True ((Get-KazikluSha256 (Join-Path $case.Game 'malie.ini')) -eq $liveIniBefore) 'backup manifest tamper 거부 전에 live malie.ini가 바뀌었습니다.'
    Add-Result 'tampered backup manifest fail-close' 'PASS' 'transaction, path, original hash/size metadata are contract-bound'

    $case = New-SyntheticCase '10_process_and_state_guard'
    $foreign = Join-Path $case.Root 'foreign\malie.exe'
    [void](Assert-KazikluGameStopped $case.Game @([pscustomobject]@{Id=101;Path=$foreign}))
    Expect-Throw { [void](Assert-KazikluGameStopped $case.Game @([pscustomobject]@{Id=102;Path=(Join-Path $case.Game 'malie.exe')})) } '실행 중'
    [void](Invoke-InstallCase $case)
    $paths = Get-KazikluStatePaths $case.Game $case.State
    $state = Get-Content -LiteralPath $paths.ActiveManifest -Raw -Encoding UTF8 | ConvertFrom-Json
    $state.data3Sha256 = ('0' * 64)
    Write-KazikluJsonAtomic $paths.ActiveManifest $state
    Expect-Throw {
        [void](Invoke-KazikluVerify -GameDir $case.Game -PackageRoot $case.Package -StateRoot $case.State -Data3Sha256 ('0' * 64) -PatchedIniSha256 $case.PatchedIniHash -Contract $case.Contract)
    } 'v3 release 계약'
    Add-Result 'canonical process and active-state contract guard' 'PASS' 'foreign same-name path allowed; exact target and state+CLI hash substitution rejected'

    $summary = [ordered]@{
        schema='dies-irae-kaziklu-kr.synthetic-savepath-package-tests.v3'
        createdUtc=[DateTime]::UtcNow.ToString('o')
        powershellVersion=$PSVersionTable.PSVersion.ToString()
        gameLaunches=0
        registryWrites=0
        audioOperations=0
        cases=$results
        passed=@($results | Where-Object { $_.status -eq 'PASS' }).Count
        failed=@($results | Where-Object { $_.status -ne 'PASS' }).Count
        valid=(@($results | Where-Object { $_.status -ne 'PASS' }).Count -eq 0)
    }
    $report = Join-Path $OutputRoot 'synthetic_test_report.json'
    Write-KazikluJsonAtomic $report $summary
    $summary | ConvertTo-Json -Depth 8
} catch {
    Add-Result 'test harness' 'FAIL' ([string]$_.Exception.Message)
    $summary = [ordered]@{
        schema='dies-irae-kaziklu-kr.synthetic-savepath-package-tests.v3'
        createdUtc=[DateTime]::UtcNow.ToString('o')
        powershellVersion=$PSVersionTable.PSVersion.ToString()
        gameLaunches=0; registryWrites=0; audioOperations=0
        cases=$results
        passed=@($results | Where-Object { $_.status -eq 'PASS' }).Count
        failed=@($results | Where-Object { $_.status -ne 'PASS' }).Count
        valid=$false
    }
    $report = Join-Path $OutputRoot 'synthetic_test_report.json'
    Write-KazikluJsonAtomic $report $summary
    $summary | ConvertTo-Json -Depth 8
    throw
}
