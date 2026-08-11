# 빌드 및 QA 근거

## 권위 릴리스

- 버전: `1.0.0-savepath-v3`
- asset: `Dies_irae_Kaziklu_Bey_KR_1.0.0-savepath-v3.zip`
- 크기: 22,576,035 bytes
- SHA-256: `D9334A5D106CA40B3D5E8694E3A49DFA80FFC527E91BABDC03B5E1E5AF242860`
- 상태: `payload-bound-static-pass`

ZIP 및 게임용 payload는 GitHub Release asset 전용이며 worktree에 추적하지 않습니다.

## payload 결박

| 역할 | 파일 | 크기 | SHA-256 |
|---|---:|---:|---|
| 한국어 Malie overlay | `files/data3.dat` | 23,890,944 | `10F96750CEDA0C8854FFBD4E03E20D603355B30E3E7738F1F7ACB02E79C23C9D` |
| 저장 경로 TITLE 수정 | `files/malie.ini` | 2,880 | `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70` |

원본 `malie.ini`는 2,882 bytes, SHA-256 `ADE7C6BCBD11B741F7FEA34EAFFB48E7E4375AFF73F2D2354907206B3F129712`입니다.

## 저장 경로 수정 계약

`malie.ini`는 CP932로 유지합니다. `TITLE` 행 안의 CP932 `81 60` 두 곳만 ASCII `7E`로 바꿉니다.

- 원본: `TITLE=Dies irae ～Interview with Kaziklu Bey～`
- 수정: `TITLE=Dies irae ~Interview with Kaziklu Bey~`
- 원본 offsets: 111, 139
- unrelated comment의 `81 60`은 보존
- TITLE 밖 모든 bytes exact

설치기는 쓰기 전에 원본 12파일의 크기·SHA-256, 두 payload, 실행 중인 정확한 대상 프로세스, 기존 state를 검사합니다. 원본 INI는 `%LOCALAPPDATA%\DiesIraeKazikluBeyKR` 아래에 bytes와 manifest/transaction/path/hash/size가 결박된 상태로 백업됩니다. 일반 제거는 관리 파일이나 백업이 변조되면 fail-close하며, 강제 복원도 검증된 원본 INI 백업만 사용합니다.

## 정적 QA

- 원본 baseline: 12/12 PASS
- payload binding: 2/2 PASS
- Windows PowerShell 5.1 synthetic: **10/10 PASS**
- production wrong-baseline wrapper: 쓰기 전 거부 PASS
- ZIP exact extraction: 15 files, byte/hash 일치 PASS
- payload 내 금지 EXE/DLL/MSI: 0
- 원본 `malie.exe` 및 `data.dat` 교체: 0
- 패키징 lane의 게임 실행·게임 쓰기·레지스트리 쓰기·오디오 조작: 0

Synthetic 10개 사례:

1. install/verify/uninstall exact lifecycle
2. double install fail-close
3. wrong 12-file baseline fail-close
4. tampered data3 payload fail-close
5. tampered patched INI payload fail-close
6. installed data3 tamper 후 force restore
7. installed INI tamper 후 force restore
8. tampered backup bytes fail-close
9. tampered backup manifest fail-close
10. canonical process 및 active-state contract guard

권위 결과는 `manifests/release_manifest.json`, `manifests/package_tree_manifest.json`, `manifests/malie_ini_patch_manifest.json`, `manifests/synthetic_test_report.json`에 고정되어 있습니다.

## Git 추적 범위

추적 대상은 작성한 PowerShell wrappers/core/test, 릴리스 manifests, 문서 및 글꼴 라이선스입니다. ZIP, `data3.dat`, patched `malie.ini` payload, 원작 데이터, EXE/DLL, 로컬 fixture와 QA 작업 트리는 추적하지 않습니다.

Git 초기화·remote·commit·push는 별도 게시 단계에서 수행합니다.
