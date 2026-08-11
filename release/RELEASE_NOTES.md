# Dies irae: Interview with Kaziklu Bey 한국어 패치 1.0.0-savepath-v3

## 주요 변경

- 시나리오·보조 텍스트·이미지 UI·한국어 글꼴을 포함한 최종 `data3.dat` 오버레이
- `malie.ini`의 TITLE에서 CP932 전각 물결표 두 곳만 ASCII `~`로 바꿔 Windows 저장 경로 생성 실패 수정
- 설치 전 원본 12파일 exact baseline 검증
- 원본 `malie.ini` 외부 exact 백업 및 제거/강제 복원 지원
- 원본 `malie.exe`와 `data.dat` 무수정

## QA

- Windows PowerShell 5.1 synthetic 10/10 PASS
- payload binding 2/2, baseline 12/12 PASS
- wrong baseline·double install·payload/설치본/백업/state tamper fail-close PASS
- ZIP exact 추출 및 라이선스 결박 PASS
- payload 내 EXE/DLL/MSI 0

## v2에서 갱신

data3-only v2가 설치되어 있다면 먼저 v2 제거 스크립트로 원본 12파일 상태를 복원한 뒤 v3를 설치하십시오.

## 배포 파일

- `Dies_irae_Kaziklu_Bey_KR_1.0.0-savepath-v3.zip`
- SHA-256: `D9334A5D106CA40B3D5E8694E3A49DFA80FFC527E91BABDC03B5E1E5AF242860`

ZIP과 `data3.dat`/patched `malie.ini` payload는 GitHub Release asset으로만 배포하며 Git 이력에는 포함하지 않습니다.
