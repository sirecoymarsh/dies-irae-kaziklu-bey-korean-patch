[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$GameDir,
    [Parameter(Mandatory=$true)][ValidatePattern('^[0-9A-Fa-f]{64}$')][string]$Data3Sha256,
    [Parameter(Mandatory=$true)][ValidatePattern('^[0-9A-Fa-f]{64}$')][string]$PatchedIniSha256,
    [string]$StateRoot=''
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\KazikluSavePath.Core.ps1')
if ([string]::IsNullOrWhiteSpace($StateRoot)) { $StateRoot = Get-KazikluDefaultStateRoot }
$result = Invoke-KazikluRestore -GameDir $GameDir -PackageRoot $PSScriptRoot -StateRoot $StateRoot -Data3Sha256 $Data3Sha256 -PatchedIniSha256 $PatchedIniSha256 -Contract (Get-KazikluProductionContract)
Write-Host 'data3.dat를 제거하고 백업된 원본 malie.ini를 복구하여 정확한 원본 12파일 상태로 복원했습니다.'
Write-Host "보존된 백업 기록: $($result.BackupDir)"
