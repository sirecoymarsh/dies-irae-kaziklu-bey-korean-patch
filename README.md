# Dies irae: Interview with Kaziklu Bey 한국어 패치

*Dies irae ~Interview with Kaziklu Bey~* 영문판용 비공식 한국어 패치입니다.

## 최신 버전

- 버전: `1.0.2`
- GitHub Release asset: `Dies_irae_Kaziklu_Bey_KR_1.0.2.zip`
- ZIP: 22,413,427 bytes / `B05E2819A96AEC288000C4261E875969124711A6E457191A20B74AACF75610A5`

ZIP과 게임 payload는 GitHub **Release asset으로만** 배포합니다. `data3.dat`, patched `malie.ini`, ZIP, EXE, DLL 및 원작 데이터는 Git 이력에 포함하지 않습니다.

## 추가·변경 사항

이 절은 원본 영문판과 비교해 이 패치가 무엇을 바꾸는지 커밋 기록, 릴리스 노트, 매니페스트, 설치 스크립트를 근거로 정리한 것입니다. 괄호 안은 근거(커밋 해시, 파일, 릴리스 태그)이며, 확실하지 않은 내용은 「(추정)」으로 표시했습니다.

### 번역 범위

- **번역 기준**: 영문판(*Dies irae ~Interview with Kaziklu Bey~* English)을 기준으로 한국어화했습니다. 음성은 원본 그대로입니다 (`README_KO.md`, `manifests/release_manifest.json`의 `baseline.contractId` 「kaziklu-en-original-12files」).
- **시나리오**: 전체 시나리오를 한국어로 옮겼습니다. 보조 텍스트와 시스템 CSV도 포함됩니다 (`v1.0.0`, `v1.0.2` 릴리스 노트, `README_KO.md`).
- **인물명**: 로트 슈피네, 리자 브렌나 등 인명 표기를 시나리오와 음성 설정 UI에서 하나로 맞췄습니다 (`v1.0.2`).
- **말투 교정**: 헬가가 빌헬름에게 하는 대사를, 생모이자 혈연상 누나라는 관계에 맞춰 다정하고 모성적·집착적인 누나 반말로 고쳤습니다. 헬가 음성 대사(`v_hrg*`) 85곳을 모두 검토해 61곳을 고치고 24곳을 그대로 두었으며, 같은 문장이 이어지는 음성 없는 슬롯 1곳을 더 고쳐 모두 62곳이 바뀌었습니다. 클라우디아를 향한 격노 반말, 웃음·비명, 독일어 노래·영창은 문맥에 맞게 그대로 두었습니다 (`v1.0.1`, `1acffd0`).
- **용어집**: 목록에서는 `융합형·구현형·전개형·특수형`으로 줄여 쓰고, 본문에서는 정식 명칭 `인기융합형·무장구현형·사상전개형·특수발현형`을 씁니다. 영문판의 「목록은 축약, 본문은 정식 명칭」 구조를 따른 것입니다 (`v1.0.2`).
- **이미지 UI**: 타이틀 메뉴, 설정 화면(사운드·텍스트·음성 등), 저장/불러오기 화면, 용어집, 음성 설정의 인물명 같은 그림 글자를 한국어로 바꿨습니다. 한국어 오버레이 `data3.dat`에 1,417개 파일이 들어 있습니다 (`v1.0.2`, `docs/BUILD_AND_QA.md`).
- **글꼴**: Noto Sans KR에서 파생한 한국어 글꼴(패밀리 이름 `Dies Irae KR`)을 게임이 찾는 원래 글꼴 이름 `anticcezannepro.otf`, `tsukugopro-m.otf`로 바꿔 `data3.dat` 안에 넣었습니다. SIL Open Font License 1.1을 따릅니다 (`THIRD_PARTY_NOTICES.md`, `licenses/OFL.txt`).

### 편의 기능

원판에 없던 편의 기능은 추가하지 않았습니다.

### 화면·그래픽 개선

- 타이틀 메뉴와 설정 화면 왼쪽 메뉴에서 활성·비활성·마우스오버 상태 이미지의 크기와 정렬을 맞추고, 남아 있던 영어 글자를 지웠습니다 (`v1.0.2`).
- 음성 설정의 인물명에 남아 있던 영어를 지우고, `최소/최대` 글자 위치를 고쳤습니다 (`v1.0.2`).
- 저장/불러오기 화면의 코멘트 영역과 설정 메뉴에 남아 있던 흔적이나 빈 구멍을 고쳤습니다 (`v1.0.2`).
- 사운드·텍스트·음성 설정의 조절 막대 18개 이미지는 원본 픽셀(팔레트 번호까지 같게)로 되돌렸습니다. 막대 밖의 부분은 사용자가 승인한 UI v7 그대로입니다 (`docs/BUILD_AND_QA.md`의 「UI v8 검증」, `QA_STATUS.md`).
- 해상도·전체화면 같은 화면 설정은 바꾸지 않았습니다.

### 버그 수정

- **저장 폴더 생성 실패**: 원본 `malie.ini`의 `TITLE`에 CP932 전각 물결표(`～`, 바이트 `81 60`)가 두 개 있어 Windows에서 저장 폴더를 만들지 못하는 문제가 있었습니다. 이 두 곳만 ASCII `~`(`7E`)로 바꿨습니다. `TITLE=Dies irae ～Interview with Kaziklu Bey～`가 `TITLE=Dies irae ~Interview with Kaziklu Bey~`가 되며, 다른 줄의 바이트(주석 안의 `～` 포함)는 그대로입니다 (`v1.0.0`, `manifests/malie_ini_patch_manifest.json`).
- 이전 작업본에서 막대 영역이 원본과 달라졌던 문제를 1.0.2에서 원본 픽셀로 복원해 고쳤습니다 (`v1.0.2`, `manifests/runtime_user_approval.json`).

### 설치·제거 방식

- **설치하는 파일**: 게임 폴더에 `data3.dat`(한국어 오버레이)를 새로 넣고 `malie.ini`를 고친 판으로 바꿉니다. 원본 `malie.exe`와 `data.dat`는 고치지 않고, 배포 파일에는 EXE·DLL·MSI가 없습니다 (`manifests/release_manifest.json`의 `installMode`, `forbiddenPayloads`).
- **원본 확인**: 설치 전에 게임 폴더 최상위가 원본 영문판 12개 파일(`as.ini`, `data.dat`, `ds.ini`, `GameuxInstallHelper.dll`, `gdiplus.dll`, `light_bana.bmp`, `malie.exe`, `malie.ini`, `maliesetup.dll`, `README.txt`, `steam_api.dll`, `unicows.dll`)과 정확히 같은지 크기와 SHA-256으로 확인합니다. 파일이 더 있거나 모자라도 거부합니다. `steam_api.dll`이 있으므로 Steam 영문판 기준으로 보입니다 (추정) (`release_manifest.json`의 `baseline`).
- **해시 지정**: 설치·검증·제거 때 `-Data3Sha256`과 `-PatchedIniSha256`을 직접 넘겨야 하고, 값이 릴리스 기록과 다르면 거부합니다 (`lib/KazikluSavePath.Core.ps1`).
- **백업·복원**: 원본 `malie.ini`는 게임·패키지 밖인 `%LOCALAPPDATA%\DiesIraeKazikluBeyKR` 아래에 백업하고, 백업 기록(경로·해시·크기)과 진행 중 작업 기록을 남깁니다. `-StateRoot`로 위치를 바꿀 수 있습니다 (`lib/KazikluSavePath.Core.ps1`).
- **안전장치**: 해당 게임 폴더의 `malie.exe`가 실행 중이면 설치·검증·제거를 거부합니다. 원본이 다를 때, 두 번 설치할 때, 패치 파일·설치본·백업·상태 기록이 변조됐을 때도 쓰기 전에 멈춥니다.
- **스크립트**: `install_ko.ps1`(설치), `verify_ko.ps1`(검증), `uninstall_ko.ps1`(제거, 원본 12개 파일 상태로 정확히 복원), `force_restore_ko.ps1`(관리 파일이 손상돼 일반 제거가 거부될 때 `data3.dat`와 고친 `malie.ini`를 버리고 백업한 원본으로 강제 복원).
- **판 올리기**: 이미 설치된 상태에서 새 판을 덮어 설치하면 거부됩니다. 먼저 이전 판의 제거 스크립트와 그 판의 `data3.dat` 해시로 제거한 뒤 새 판을 설치합니다 (`v1.0.0`, `v1.0.1` 릴리스 노트).
- **시험**: Windows PowerShell 5.1에서 가짜 게임 폴더로 설치·검증·제거 전 과정, 중복 설치 거부, 원본 불일치 거부, 패치 파일 변조 거부, 설치본 변조 뒤 강제 복원, 백업·백업 기록 변조 거부, 실행 중 프로세스 확인 등 10개 사례를 돌려 10/10 통과했습니다 (`tests/run_synthetic_fixture_tests.ps1`, `manifests/synthetic_test_report.json`).

### 판(버전)별 변경 기록

- **v2 (data3 전용, GitHub 릴리스 없음)**: `malie.ini`를 고치지 않고 `data3.dat`만 넣던 이전 판입니다. v3로 올릴 때 v2 제거 스크립트로 먼저 원래대로 되돌리라는 안내만 남아 있습니다 (`v1.0.0` 릴리스 노트).
- **2026-08-12 · `v1.0.0` (`1.0.0-savepath-v3`)** (`2a892ba`): 첫 공개판입니다. 시나리오·보조 텍스트·이미지 UI·한국어 글꼴을 담은 `data3.dat`, 저장 폴더 생성 실패를 고친 `malie.ini`, 원본 12개 파일 확인, 원본 `malie.ini` 외부 백업과 제거·강제 복원을 넣었습니다. (릴리스 게시 시각은 2026-08-11 UTC)
- **2026-08-12 · `v1.0.1` (`1.0.1-savepath-v4`)** (`1acffd0`): 헬가→빌헬름 말투를 누나 반말로 고쳤습니다(62곳). `malie.ini`, 스크립트 4개, 라이선스는 1.0.0과 바이트까지 같고, 공통 모듈은 새 `data3.dat`의 판 번호·크기·해시만 바꿨습니다.
- **2026-08-12 · `v1.0.2`** (`714ff84`): 이미지 UI를 크게 손봤습니다(UI v7→v8). 인명 통일, 용어집 축약명·정식 명칭 구조 복원, 메뉴 활성·비활성 크기·정렬 통일, 음성 설정 영어 잔재 제거, 저장/불러오기 화면 수정, 조절 막대 원본 픽셀 복원이 들어갔습니다. 실제 실행(소리 켬)에서 사용자가 「모든 막대 정상」으로 승인했습니다. `data3.dat` 크기가 23,890,944바이트에서 23,725,056바이트로 바뀌었습니다.

### 알려진 문제

- `install_ko.ps1`은 1.0.2에서도 끝날 때 「v3 설치 완료」라고 표시합니다. 표시 문구만 옛 판 이름이고 설치되는 파일은 1.0.2입니다 (`install_ko.ps1`).
- 원본 영문판 12개 파일과 정확히 같은 폴더에서만 설치됩니다. 다른 판(다른 빌드나 파일이 추가된 폴더)은 시험하지 않았고 설치도 거부됩니다.
- 실제 실행 검토는 UI 조절 막대와 이미 승인한 타이틀·공통 메뉴·저장/불러오기·음성 인물명·용어집 화면 범위였습니다. 시나리오 전체를 실제로 끝까지 실행해 확인한 기록은 저장소에 없습니다 (`manifests/runtime_user_approval.json`).

## 설치

1. [GitHub Releases](https://github.com/sirecoymarsh/dies-irae-kaziklu-bey-korean-patch/releases)에서 `Dies_irae_Kaziklu_Bey_KR_1.0.2.zip`을 내려받습니다.
2. 게임과 설정 도구를 모두 종료합니다.
3. ZIP을 풀고 패키지 루트에서 다음 명령을 실행합니다. `<게임 폴더>`에는 게임이 설치된 폴더 경로를 넣습니다.

```powershell
$d3 = '8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E'
$ini = '6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70'
.\install_ko.ps1 -GameDir '<게임 폴더>' -Data3Sha256 $d3 -PatchedIniSha256 $ini
.\verify_ko.ps1 -GameDir '<게임 폴더>' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

제거:

```powershell
.\uninstall_ko.ps1 -GameDir '<게임 폴더>' -Data3Sha256 $d3 -PatchedIniSha256 $ini
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
