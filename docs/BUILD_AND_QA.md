# 빌드 및 QA 근거

## 권위 릴리스

- 버전: `1.0.1-savepath-v4`
- asset: `Dies_irae_Kaziklu_Bey_KR_1.0.1-savepath-v4.zip`
- 크기: 22,575,659 bytes
- SHA-256: `3787FF1F46558A0DED9A17CFA2DB30F92679322F2EFF1E072AE7474D57B5977D`
- 상태: `payload-bound-static-pass`

ZIP 및 게임용 payload는 GitHub Release asset 전용이며 worktree에 추적하지 않습니다.

## payload 결박

| 역할 | 파일 | 크기 | SHA-256 |
|---|---:|---:|---|
| 한국어 Malie overlay | `files/data3.dat` | 23,890,944 | `B7F46AEB1A5E9AAA31B255C102863FC366A7F4973BFABA56EE854D656D1145DF` |
| 저장 경로 TITLE 수정 | `files/malie.ini` | 2,880 | `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70` |

원본 `malie.ini`는 2,882 bytes, SHA-256 `ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712`입니다.

## 1.0.1 content delta

- v_hrg 85/85 전수 검토
- voice-bound 61 수정 + 24 유지
- v_hrg0080 동일 문장 무음성 연속 슬롯 1 수정
- effective target delta 62
- Claudia 대상 격노/비어휘/독일어 노래·영창 보존

## 설치기 delta

- wrapper 4개와 patched `malie.ini`: 1.0.0과 byte-identical
- `lib/KazikluSavePath.Core.ps1`: ReleaseVersion, ContractId, Data3Size, Data3Sha256, v4 오류문만 변경
- baseline 12파일, 백업/복원, process guard, fail-close 로직: 동일

## 저장 경로 수정 계약

`malie.ini`는 CP932로 유지합니다. `TITLE` 행 안의 CP932 `81 60` 두 곳만 ASCII `7E`로 바꿉니다. TITLE 밖 모든 bytes는 exact입니다.

## 정적 QA

- 원본 baseline: 12/12 PASS
- payload binding: 2/2 PASS
- Windows PowerShell 5.1 synthetic 10/10: PASS (fresh v4 report)
- wrong baseline 및 tamper/double-install fail-close 계약 유지
- ZIP deterministic rebuild + exact entry hash: PASS
- payload 내 금지 EXE/DLL/MSI: 0
- 원본 `malie.exe` 및 `data.dat` 교체: 0
- 패키징 lane의 게임 실행·게임 쓰기·레지스트리 쓰기·오디오 조작: 0

권위 결과는 `manifests/release_manifest.json`, `manifests/package_tree_manifest.json`, `manifests/malie_ini_patch_manifest.json`, `manifests/synthetic_test_report.json`에 고정되어 있습니다.

## Git 추적 범위

추적 대상은 PowerShell wrappers/core/test, 릴리스 manifests, 문서 및 글꼴 라이선스입니다. ZIP, `data3.dat`, patched `malie.ini` payload, 원작 데이터, EXE/DLL, 로컬 fixture와 QA 작업 트리는 추적하지 않습니다.
