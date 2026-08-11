# Dies irae: Interview with Kaziklu Bey 한국어 패치 1.0.1-savepath-v4

## 주요 변경

- Helga가 Wilhelm의 생모이자 혈연상 누나라는 공식 관계와 사용자 확정에 맞춰, Wilhelm 상대 대사를 다정하고 모성적·집착적인 누나 반말로 교정
- `v_hrg*` 85좌표 전수 검토: 61 수정, 24 유지, 동일 문장 연속 슬롯 1 추가 수정(총 62 target delta)
- Claudia 대상 격노 반말과 웃음·비명·독일어 노래·영창은 문맥에 맞게 유지
- 저장 경로 `malie.ini`, wrapper 4개, 라이선스/고지는 1.0.0과 byte-identical
- 공통 core는 새 data3를 fail-close 결박하기 위한 version/contract/size/SHA 값만 최소 갱신
- 원본 `malie.exe`와 `data.dat` 무수정

## 이전 버전에서 갱신

v3가 설치되어 있으면 v3 패키지의 제거 스크립트와 v3 data3 SHA로 원본 12파일 상태를 먼저 복원한 뒤 v4를 설치하십시오. 활성 설치 위 덮어쓰기는 double-install 보호로 거부됩니다.

## payload

- `data3.dat`: 23,890,944 bytes / `B7F46AEB1A5E9AAA31B255C102863FC366A7F4973BFABA56EE854D656D1145DF`
- patched `malie.ini`: 2,880 bytes / `6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`

## QA

- 원본 baseline 12/12, payload 2/2 hash binding PASS
- Windows PowerShell 5.1 synthetic 10/10 PASS (fresh v4 report)
- wrong baseline·double install·payload/설치본/백업/state tamper fail-close 계약 유지
- ZIP deterministic rebuild 및 exact entry byte/hash 일치 PASS
- payload 내 EXE/DLL/MSI 0
- 패키징 lane의 게임 실행·게임 쓰기·레지스트리 쓰기·오디오 조작 0

## 배포 파일

- `Dies_irae_Kaziklu_Bey_KR_1.0.1-savepath-v4.zip` (22,575,659 bytes)
- SHA-256: `3787FF1F46558A0DED9A17CFA2DB30F92679322F2EFF1E072AE7474D57B5977D`

ZIP과 `data3.dat`/patched `malie.ini` payload는 GitHub Release asset으로만 배포하며 Git 이력에는 포함하지 않습니다.
