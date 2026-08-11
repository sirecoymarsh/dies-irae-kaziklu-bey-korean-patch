# Dies irae: Interview with Kaziklu Bey 한국어 패치

*Dies irae: Interview with Kaziklu Bey* 영문판용 비공식 한국어 패치입니다.

## 현재 릴리스

- 버전: `1.0.1-savepath-v4`
- GitHub Release asset: `Dies_irae_Kaziklu_Bey_KR_1.0.1-savepath-v4.zip`
- ZIP: 22,575,659 bytes / `3787FF1F46558A0DED9A17CFA2DB30F92679322F2EFF1E072AE7474D57B5977D`

ZIP과 게임용 payload는 GitHub **Release asset으로만** 배포합니다. `data3.dat`, `malie.ini` payload, ZIP, EXE, DLL 및 원작 데이터는 Git 이력에 포함하지 않습니다.

## 1.0.1 변경 사항

- Helga→Wilhelm 대사를 공식 생모·누나 관계에 맞는 다정하고 모성적·집착적인 누나 반말로 교정
- v_hrg 85좌표 전수 검토, 61 수정·24 유지·연속 슬롯 1 수정(총 62 target delta)
- Claudia 대상 격노 반말, 웃음·비명, 독일어 노래·영창 유지
- 저장 경로 수정 `malie.ini`와 wrapper 4개는 1.0.0과 byte-identical
- 새 data3에 맞춰 core의 release/contract/size/SHA binding만 갱신

## 설치

1. GitHub Releases에서 1.0.1 ZIP을 내려받고 SHA-256을 확인합니다.
2. 게임과 설정 도구를 모두 종료합니다.
3. 이전 버전이 설치되어 있다면 해당 버전의 제거 스크립트로 먼저 원본 상태를 복원합니다.
4. ZIP을 풀고 패키지 루트에서 다음을 실행합니다.

```powershell
$d3 = 'B7F46AEB1A5E9AAA31B255C102863FC366A7F4973BFABA56EE854D656D1145DF'
$ini = '6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70'
.\install_ko.ps1 -GameDir 'F:\DOWN\[Ryuugames] Dies irae Interview with Kaziklu Bey - ENG' -Data3Sha256 $d3 -PatchedIniSha256 $ini
.\verify_ko.ps1 -GameDir 'F:\DOWN\[Ryuugames] Dies irae Interview with Kaziklu Bey - ENG' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

제거:

```powershell
.\uninstall_ko.ps1 -GameDir 'F:\DOWN\[Ryuugames] Dies irae Interview with Kaziklu Bey - ENG' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

설치된 관리 파일이 변조되어 일반 제거가 거부될 때만 `force_restore_ko.ps1`을 사용합니다. 상태와 원본 INI 백업은 기본적으로 `%LOCALAPPDATA%\DiesIraeKazikluBeyKR`에 저장됩니다.

## 고정 기준

- original `malie.exe`: 4,123,648 bytes / `7DCF8ECA7288E787A93A405C2818B19BD3B367830B72D3188B09042E2304D963`
- original `malie.ini`: 2,882 bytes / `ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712`
- patched `malie.ini`: 2,880 bytes / `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`
- `data3.dat`: 23,890,944 bytes / `B7F46AEB1A5E9AAA31B255C102863FC366A7F4973BFABA56EE854D656D1145DF`

## 저장소 구성

- 루트 PowerShell wrappers: 설치·검증·제거·강제 복원
- `lib/`: hash-bound 설치/복원 공통 모듈
- `tests/`: Windows PowerShell synthetic 회귀 테스트
- `manifests/`: 릴리스·패키지 트리·INI delta·QA 결과
- `licenses/`, `THIRD_PARTY_NOTICES.md`: Noto Sans KR 파생 글꼴 고지
- `docs/`: 빌드 및 QA 근거
- `release/`: 릴리스 노트와 checksum 목록

정적 릴리스 QA는 PASS입니다. 자세한 내용은 `docs/BUILD_AND_QA.md`를 확인하십시오.
