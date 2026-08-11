# QA STATUS — savepath v3

- 설치 형식: `data3.dat` 추가 + 원본 `malie.ini` exact 외부 백업 후 patched `malie.ini` 교체
- final data3 SHA-256/size: PASS (`10F96750CEDA0C8854FFBD4E03E20D603355B30E3E7738F1F7ACB02E79C23C9D`, 23,890,944 bytes)
- patched malie.ini SHA-256/size: PASS (`6F46E60A92B92FA36DBAE7962D0848C6A8EDA5132818AD1481CE03A1D054AD70`, 2,880 bytes)
- INI delta: TITLE 내 CP932 `81 60` 두 곳만 ASCII `7E`로 변경; unrelated comment의 `81 60` 보존 PASS
- 원본 12파일 계약: 12/12 크기·SHA-256 결박 PASS
- 원본 `malie.exe`/`data.dat` 교체: 0
- payload 내 EXE/DLL/MSI: 0
- 원본 malie.ini 백업 bytes + manifest/transaction/path integrity: PASS
- Windows PowerShell 5.1 synthetic 회귀: 10/10 PASS
- wrong baseline production wrapper: 쓰기 전 거부 PASS
- ZIP 추출 트리 byte/hash 일치: PASS
- `THIRD_PARTY_NOTICES.md` + `licenses/OFL.txt`: 포함/해시 PASS
- 실제 게임 실행·설치·설정·레지스트리·오디오 조작: 0
