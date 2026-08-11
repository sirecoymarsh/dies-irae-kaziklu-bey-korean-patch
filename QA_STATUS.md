# QA STATUS — 1.0.1 savepath v4

- 설치 형식: `data3.dat` 추가 + 원본 `malie.ini` exact 외부 백업 후 patched `malie.ini` 교체
- final data3 SHA-256/size: PASS (`B7F46AEB1A5E9AAA31B255C102863FC366A7F4973BFABA56EE854D656D1145DF`, 23,890,944 bytes)
- Helga register correction: v_hrg 85/85 audited, 61 modified + 24 kept, continuation dependency 1; effective 62 target deltas PASS
- patched malie.ini SHA-256/size: PASS (`6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`, 2,880 bytes)
- v3 대비 wrapper 4개 + patched malie.ini byte-identical: PASS
- core delta allowlist: ReleaseVersion, ContractId, Data3Size, Data3Sha256, v4 오류문만 변경 PASS
- INI delta: TITLE 내 CP932 `81 60` 두 곳만 ASCII `7E`로 변경; unrelated comment의 `81 60` 보존 PASS
- 원본 12파일 계약: 12/12 크기·SHA-256 결박 PASS
- 원본 `malie.exe`/`data.dat` 교체: 0
- payload 내 EXE/DLL/MSI: 0
- 원본 malie.ini 백업 bytes + manifest/transaction/path integrity: PASS
- Windows PowerShell 5.1 synthetic 회귀: PASS
- wrong baseline/payload/설치본/백업/state/double-install: fail-close 계약 유지
- ZIP deterministic rebuild 및 exact entry byte/hash 일치: PASS
- `THIRD_PARTY_NOTICES.md` + `licenses/OFL.txt`: 포함/해시 PASS
- 실제 게임 실행·설치·설정·레지스트리·오디오 조작: 0
- Fresh v4 Windows PowerShell 5.1 synthetic suite: 10/10 PASS (`DC1D508C04EC56E7B617CF1EF2E20496DB6667D63A1D4E66011F58140B7D4B91`, `2026-08-11T17:47:05.1620746Z`)
