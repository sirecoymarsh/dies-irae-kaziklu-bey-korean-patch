# Dies irae ~Interview with Kaziklu Bey~ 한국어 패치 1.0.1 (savepath v4)

이 버전은 다음 두 파일만 관리합니다.

- `files/data3.dat`: 한국어 번역·UI·글꼴·Unicode 실행 오버레이
- `files/malie.ini`: 저장 경로 생성을 막던 `TITLE`의 CP932 `81 60` 두 곳만 ASCII `~`로 바꾼 설정 파일

원본 `malie.exe`와 `data.dat`는 절대 교체하지 않습니다. 설치 전 원본 12파일을 크기와 SHA-256으로 모두 확인하고, 원본 `malie.ini`를 게임/패키지 밖 상태 폴더에 exact 백업한 뒤 두 관리 파일을 설치합니다.

## 1.0.1 변경 사항

- 공식 관계(`ヴィルヘルムの母であり、姉`)와 사용자 확정에 맞춰 Helga→Wilhelm 대사를 다정하고 모성적·집착적인 누나 반말로 교정했습니다.
- `v_hrg*` 85좌표를 전수 검토해 61좌표를 수정하고 24좌표를 유지했으며, 동일 문장 연속 슬롯 1좌표를 함께 수정했습니다.
- Claudia 대상 격노 반말, 웃음·비명, 독일어 노래·영창은 문맥에 맞게 유지했습니다.
- 저장 경로 수정 `malie.ini`와 네 개 wrapper의 bytes/동작은 1.0.0과 같습니다. 공통 core는 새 `data3.dat`의 version/size/SHA 계약만 갱신했습니다.

## 고정 해시

- `data3.dat` (23,890,944 bytes): `B7F46AEB1A5E9AAA31B255C102863FC366A7F4973BFABA56EE854D656D1145DF`
- patched `malie.ini` (2,880 bytes): `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`
- original `malie.ini` (2,882 bytes): `ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712`

## 이전 버전에서 갱신

v3가 설치되어 있으면 **v3 패키지의 제거 스크립트와 v3 data3 SHA로 먼저 원본 12파일 상태를 복원한 뒤** v4를 설치하십시오. v2 이하도 해당 버전의 제거 절차로 먼저 원본 상태를 복원해야 합니다. 새 패키지를 기존 활성 설치 위에 덮어쓰는 방식은 double-install 보호로 거부됩니다.

## 설치·검증·제거

먼저 게임과 설정 도구를 모두 종료하십시오.

```powershell
$d3 = 'B7F46AEB1A5E9AAA31B255C102863FC366A7F4973BFABA56EE854D656D1145DF'
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
