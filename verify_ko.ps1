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
$result = Invoke-KazikluVerify -GameDir $GameDir -PackageRoot $PSScriptRoot -StateRoot $StateRoot -Data3Sha256 $Data3Sha256 -PatchedIniSha256 $PatchedIniSha256 -Contract (Get-KazikluProductionContract)
Write-Host 'data3.dat, patched malie.ini, 원본 11파일 및 백업 무결성 검증 완료.'
Write-Host "백업 상태: $($result.BackupDir)"
