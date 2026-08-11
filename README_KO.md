# Dies irae ~Interview with Kaziklu Bey~ 한국어 패치 v3

이 버전은 다음 두 파일만 관리합니다.

- `files/data3.dat`: 한국어 번역·UI·글꼴·Unicode 실행 오버레이
- `files/malie.ini`: 저장 경로 생성을 막던 `TITLE`의 CP932 `81 60` 두 곳만 ASCII `~`로 바꾼 설정 파일

원본 `malie.exe`와 `data.dat`는 절대 교체하지 않습니다. 설치 전 원본 12파일을 크기와 SHA-256으로 모두 확인하고, 원본 `malie.ini`를 게임/패키지 밖 상태 폴더에 exact 백업한 뒤 두 관리 파일을 설치합니다.

## 고정 해시

- `data3.dat` (23,890,944 bytes): `10F96750CEDA0C8854FFBD4E03E20D603355B30E3E7738F1F7ACB02E79C23C9D`
- patched `malie.ini` (2,880 bytes): `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`
- original `malie.ini` (2,882 bytes): `ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712`

## 설치·검증·제거

먼저 게임과 설정 도구를 모두 종료하십시오. v2 data3-only판이 설치되어 있으면 **v2 제거를 먼저 실행해 원본 12파일 상태로 돌아온 뒤** v3를 설치하십시오.

```powershell
$d3 = '10F96750CEDA0C8854FFBD4E03E20D603355B30E3E7738F1F7ACB02E79C23C9D'
$ini = '6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70'
.\install_ko.ps1 -GameDir 'D:\Games\Kaziklu' -Data3Sha256 $d3 -PatchedIniSha256 $ini
.\verify_ko.ps1 -GameDir 'D:\Games\Kaziklu' -Data3Sha256 $d3 -PatchedIniSha256 $ini
.\uninstall_ko.ps1 -GameDir 'D:\Games\Kaziklu' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

설치된 `data3.dat` 또는 `malie.ini`가 변경되거나 누락되어 일반 제거가 거부될 때만 아래를 사용합니다.

```powershell
.\force_restore_ko.ps1 -GameDir 'D:\Games\Kaziklu' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

설치·제거·강제 복원은 **지정한 게임 폴더의 정확한 `malie.exe`가 실행 중이면 거부**됩니다. 상태·백업은 기본적으로 `%LOCALAPPDATA%\DiesIraeKazikluBeyKR`에 저장됩니다. double install, wrong baseline, payload/설치본/백업/state tamper는 쓰기 전에 fail-close합니다.

## 제3자 글꼴 라이선스

`data3.dat`에는 Noto Sans KR 파생 글꼴 사본이 포함됩니다. 고지는 `THIRD_PARTY_NOTICES.md`, 전체 SIL OFL 1.1 본문은 `licenses/OFL.txt`를 확인하십시오.
