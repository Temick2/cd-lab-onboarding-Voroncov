@echo off
chcp 65001 >nul

set "REPORT=%~dp0pc_report.txt"
if exist "%REPORT%" del "%REPORT%"

echo ============================================================
echo              Diagnostika kompjutera
echo ============================================================
echo.
echo ============================================================ > "%REPORT%"
echo              Diagnostika kompjutera >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"

echo Operacionnaja sistema
echo --------------------
echo Operacionnaja sistema >> "%REPORT%"
echo -------------------- >> "%REPORT%"

for /f "tokens=1,* delims==" %%A in ('wmic os get Caption /value 2^>nul') do (
    if /i "%%A"=="Caption" (
        echo Nazvanie: %%B
        echo Nazvanie: %%B >> "%REPORT%"
    )
)
for /f "tokens=1,* delims==" %%A in ('wmic os get Version /value 2^>nul') do (
    if /i "%%A"=="Version" (
        echo Versija:   %%B
        echo Versija:   %%B >> "%REPORT%"
    )
)
echo.
echo. >> "%REPORT%"

echo Processor
echo ---------
echo Processor >> "%REPORT%"
echo --------- >> "%REPORT%"

for /f "skip=1 delims=" %%A in ('wmic cpu get Name 2^>nul') do (
    if not "%%A"=="" (
        echo %%A
        echo %%A >> "%REPORT%"
        goto :cpu_done
    )
)
:cpu_done
echo.
echo. >> "%REPORT%"

echo Operativnaja pamjat
echo ------------------
echo Operativnaja pamjat >> "%REPORT%"
echo ------------------ >> "%REPORT%"

for /f "tokens=1,* delims==" %%A in ('wmic OS get TotalVisibleMemorySize /value 2^>nul') do (
    if /i "%%A"=="TotalVisibleMemorySize" set "TOTAL_KB=%%B"
)
for /f "tokens=1,* delims==" %%A in ('wmic OS get FreePhysicalMemory /value 2^>nul') do (
    if /i "%%A"=="FreePhysicalMemory" set "FREE_KB=%%B"
)

set /a TOTAL_GB=%TOTAL_KB% / 1048576
set /a FREE_GB=%FREE_KB% / 1048576

echo Vsego pamjati:   %TOTAL_GB% GB
echo Svobodno pamjati: %FREE_GB% GB
echo Vsego pamjati:   %TOTAL_GB% GB >> "%REPORT%"
echo Svobodno pamjati: %FREE_GB% GB >> "%REPORT%"
echo.
echo. >> "%REPORT%"

echo Disk C
echo ------
echo Disk C >> "%REPORT%"
echo ------ >> "%REPORT%"

for /f "tokens=1,* delims==" %%A in ('wmic logicaldisk where "DeviceID='C:'" get Size /value 2^>nul') do (
    if /i "%%A"=="Size" set "SIZE_B=%%B"
)
for /f "tokens=1,* delims==" %%A in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value 2^>nul') do (
    if /i "%%A"=="FreeSpace" set "FREE_B=%%B"
)

set /a SIZE_GB=%SIZE_B% / 1073741824
set /a FREE_DISK_GB=%FREE_B% / 1073741824

echo Obshhij razmer:   %SIZE_GB% GB
echo Svobodno:       %FREE_DISK_GB% GB
echo Obshhij razmer:   %SIZE_GB% GB >> "%REPORT%"
echo Svobodno:       %FREE_DISK_GB% GB >> "%REPORT%"
echo.
echo. >> "%REPORT%"

echo Ustanovlennye programmy
echo -----------------------
echo (poluchenie spiska cherez reestr...)
echo.
echo Ustanovlennye programmy >> "%REPORT%"
echo ----------------------- >> "%REPORT%"
echo. >> "%REPORT%"

for /f "tokens=2,*" %%A in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    echo %%B
    echo %%B >> "%REPORT%"
)

for /f "tokens=2,*" %%A in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    echo %%B
    echo %%B >> "%REPORT%"
)

echo.
echo. >> "%REPORT%"

echo ============================================================
echo Otchet sohranjon: %REPORT%
echo ============================================================
echo ============================================================ >> "%REPORT%"
echo Otchet sohranjon: %REPORT% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"

echo.
pause
pause
