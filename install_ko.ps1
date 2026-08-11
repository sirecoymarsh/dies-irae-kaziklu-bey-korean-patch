[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$GameDir,
    [string]$Data3Path=(Join-Path $PSScriptRoot 'files\data3.dat'),
    [Parameter(Mandatory=$true)][ValidatePattern('^[0-9A-Fa-f]{64}$')][string]$Data3Sha256,
    [string]$PatchedIniPath=(Join-Path $PSScriptRoot 'files\malie.ini'),
    [Parameter(Mandatory=$true)][ValidatePattern('^[0-9A-Fa-f]{64}$')][string]$PatchedIniSha256,
    [string]$StateRoot=''
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\KazikluSavePath.Core.ps1')
if ([string]::IsNullOrWhiteSpace($StateRoot)) { $StateRoot = Get-KazikluDefaultStateRoot }
$result = Invoke-KazikluInstall -GameDir $GameDir -PackageRoot $PSScriptRoot -StateRoot $StateRoot -Data3Path $Data3Path -Data3Sha256 $Data3Sha256 -PatchedIniPath $PatchedIniPath -PatchedIniSha256 $PatchedIniSha256 -Contract (Get-KazikluProductionContract)
Write-Host 'Kaziklu Bey 한국어 패치 v3 설치 완료 (data3.dat + 저장 경로 수정 malie.ini).'
Write-Host "원본 malie.ini 백업: $($result.BackupDir)"
