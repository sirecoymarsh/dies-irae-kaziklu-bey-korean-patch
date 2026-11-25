# Dies irae ~Interview with Kaziklu Bey~ 한국어 패치 1.0.2

영문판을 기준으로 시나리오, 시스템 CSV, 글꼴 및 이미지 기반 UI를 한국어화한 패치입니다. 원본 `malie.exe`와 `data.dat`은 교체하지 않습니다.

## 주요 반영 사항

- 전체 시나리오 한국어화 및 헬가→빌헬름 친밀한 누나 말투 교정
- 로트 슈피네·리자 브렌나 등 인명 교정
- 타이틀, 설정, 저장/불러오기, 용어집, 음성 설정 등 이미지 UI 교정
- 용어집 목록을 `융합형·구현형·전개형·특수형`으로 정리하고 본문 정식 명칭 유지
- 설정 메뉴 활성/비활성 상태의 크기·정렬·영문 잔재 교정
- 사운드·텍스트·음성 설정의 조절 막대는 원본 픽셀을 보존
- 저장 폴더 생성 오류를 막기 위한 `malie.ini` TITLE 물결표 교정

## 설치

게임과 설정 도구를 종료한 뒤 실행하십시오.

```powershell
$d3 = '8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E'
$ini = '6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70'
.\install_ko.ps1 -GameDir '<게임 폴더>' -Data3Sha256 $d3 -PatchedIniSha256 $ini
.\verify_ko.ps1 -GameDir '<게임 폴더>' -Data3Sha256 $d3 -PatchedIniSha256 $ini
```

제거는 `uninstall_ko.ps1`, 손상된 관리 상태의 강제 복원은 `force_restore_ko.ps1`을 사용합니다.

- `data3.dat`: 23,725,056 bytes / `8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E`
- patched `malie.ini`: 2,880 bytes / `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`
