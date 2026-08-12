# Dies irae: Interview with Kaziklu Bey 한국어 패치

*Dies irae ~Interview with Kaziklu Bey~* 영문판용 비공식 한국어 패치입니다.

## 최신 버전

- 버전: `1.0.2`
- GitHub Release asset: `Dies_irae_Kaziklu_Bey_KR_1.0.2.zip`
- ZIP: 22,413,427 bytes / `B05E2819A96AEC288000C4261E875969124711A6E457191A20B74AACF75610A5`

ZIP과 게임 payload는 GitHub **Release asset으로만** 배포합니다. `data3.dat`, patched `malie.ini`, ZIP, EXE, DLL 및 원작 데이터는 Git 이력에 포함하지 않습니다.

## 1.0.2 변경 사항

- 전체 시나리오 한국어화 및 헬가→빌헬름 친밀한 누나 말투 교정
- 로트 슈피네·리자 브렌나 등 인명 교정
- 타이틀 메뉴, 설정, 저장/불러오기, 용어집, 음성 설정 등 이미지 기반 UI 교정
- 용어집 목록은 `융합형·구현형·전개형·특수형`, 본문은 정식 명칭 `인기융합형·무장구현형·사상전개형·특수발현형` 유지
- 활성/비활성/마우스 오버 상태의 크기·정렬·영문 잔재 교정
- 사운드·텍스트·음성 설정 조절 막대는 원본 픽셀을 보존하도록 복원
- 저장 폴더 생성 오류를 막기 위한 `malie.ini` TITLE 물결표 교정
- 원본 `malie.exe`와 `data.dat`은 교체하지 않음

## 설치

1. [GitHub Releases](https://github.com/sirecoymarsh/dies-irae-kaziklu-bey-korean-patch/releases)에서 `Dies_irae_Kaziklu_Bey_KR_1.0.2.zip`을 내려받습니다.
2. 게임과 설정 도구를 모두 종료합니다.
3. ZIP을 풀고 패키지 루트에서 다음 명령을 실행합니다.

```powershell
$d3 = '8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E'
$ini = '6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70'
.\install_ko.ps1 -GameDir 'D:\Games\Kaziklu' -Data3Sha256 $d3 -PatchedIniSha256 $ini
.\verify_ko.ps1 -GameDir 'D:\Games\Kaziklu' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

제거:

```powershell
.\uninstall_ko.ps1 -GameDir 'D:\Games\Kaziklu' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

설치된 관리 파일이 손상되어 일반 제거가 거부될 때만 `force_restore_ko.ps1`을 사용합니다. 설치·검증·제거는 정확한 게임 경로의 `malie.exe`가 실행 중이면 거부합니다.

## 고정 해시

- original `malie.exe`: 4,123,648 bytes / `7DCF8ECA7288E787A93A405C2818B19BD3B367830B72D3188B09042E2304D963`
- original `malie.ini`: 2,882 bytes / `ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712`
- patched `malie.ini`: 2,880 bytes / `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`
- `data3.dat`: 23,725,056 bytes / `8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E`

## 저장소 구성

- 루트 PowerShell wrappers: 설치·검증·제거·강제 복원
- `lib/`: 해시 결박 설치/복원 공통 모듈
- `tests/`: Windows PowerShell 합성 수명주기 시험
- `manifests/`: 릴리스·패키지 트리·INI 수정·QA 결과
- `licenses/`, `THIRD_PARTY_NOTICES.md`: 포함 글꼴 고지
- `docs/`: 빌드 및 QA 근거
- `release/`: 릴리스 노트와 체크섬 목록
