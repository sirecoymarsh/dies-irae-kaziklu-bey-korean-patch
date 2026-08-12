# 빌드 및 QA 근거

## 권위 릴리스

- 버전: `1.0.2`
- asset: `Dies_irae_Kaziklu_Bey_KR_1.0.2.zip`
- 크기: 22,413,427 bytes
- SHA-256: `B05E2819A96AEC288000C4261E875969124711A6E457191A20B74AACF75610A5`
- 상태: `approved-for-release`

ZIP 및 게임 payload는 GitHub Release asset 전용이며 worktree에는 추적하지 않습니다.

## payload 결박

| 역할 | 파일 | 크기 | SHA-256 |
|---|---|---:|---|
| 한국어 Malie overlay | `files/data3.dat` | 23,725,056 | `8AE1A0A900BD8BE87B59BA32B1FDF1137C77576B112FA8B3E2B4A18026A4A69E` |
| 저장 경로 TITLE 수정 | `files/malie.ini` | 2,880 | `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70` |

원본 `malie.ini`은 2,882 bytes, SHA-256 `ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712`입니다.

## UI v8 검증

- overlay: 1,417 files
- A/B deterministic archive build: PASS
- 양쪽 독립 disk reopen: PASS
- 조절 막대 복원 대상: 18/18 DZI
- 대상 사각형 내부: 원본 palette index exact
- 대상 사각형 외부: 사용자 승인 v7 byte/pixel exact
- 타이틀·공통 메뉴·저장/불러오기·인물명·용어집 수정 불변: PASS

## 설치기 QA

- original baseline: 12/12 size/SHA 결박
- payload: 2/2 size/SHA 결박
- Windows PowerShell 5.1 synthetic: 10/10 PASS
- install → verify → uninstall exact lifecycle: PASS
- wrong baseline, double install, payload/live/backup/state tamper: fail-close PASS
- deterministic ZIP rebuild and exact entry bytes: PASS
- payload 내 EXE/DLL/MSI: 0
- 원본 `malie.exe` 및 `data.dat` 교체: 0

권위 결과는 `manifests/release_manifest.json`, `manifests/package_tree_manifest.json`, `manifests/malie_ini_patch_manifest.json`, `manifests/synthetic_test_report.json`에 결박돼 있습니다.
