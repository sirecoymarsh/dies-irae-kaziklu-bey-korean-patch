# Dies irae: Interview with Kaziklu Bey 한국어 패치 1.0.2

## 주요 변경

- 전체 시나리오 및 이미지 기반 UI 한국어화 완성
- 헬가→빌헬름 말투를 생모이자 누나인 관계에 맞는 친밀한 반말로 교정
- 로트 슈피네·리자 브렌나 인명 표기를 시나리오와 음성 설정 UI에서 통일
- 타이틀 메뉴와 설정 좌측 메뉴의 활성/비활성 크기 및 정렬 통일
- 음성 설정 인물명 영문 잔재 제거, `최소/최대` 배치 교정
- 용어집 목록 축약명과 본문 정식 명칭의 구조를 영문판에 맞게 복원
- 저장/불러오기 화면 코멘트 영역과 설정 메뉴 잔재·구멍 교정
- 사운드·텍스트·음성 설정의 막대 영역을 원본 픽셀로 복원
- `malie.ini` 저장 경로 수정 유지

## payload

- `data3.dat`: 23,725,056 bytes / `8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E`
- patched `malie.ini`: 2,880 bytes / `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`

## QA

- data3 A/B deterministic build 및 독립 재개봉 PASS
- UI v8 막대 복원 18/18, 비대상 픽셀 불변 PASS
- Windows PowerShell 5.1 synthetic 10/10 PASS
- deterministic ZIP 및 exact entry bytes PASS
- 원본 EXE/DLL/data.dat 미포함·미교체

## 배포 파일

- `Dies_irae_Kaziklu_Bey_KR_1.0.2.zip` (22,413,427 bytes)
- SHA-256: `B05E2819A96AEC288000C4261E875969124711A6E457191A20B74AACF75610A5`
