@echo off
chcp 65001 >nul

REM ============================================================
REM Практическая работа: Диагностика клиентского компьютера
REM Тема: инструментальные средства ревьюирования, проверки на стороне клиента
REM Автор: Voroncov
REM Дата: 29.10.2026
REM ============================================================

REM Устанавливаем путь к отчёту рядом с bat-файлом
set "REPORT=%~dp0pc_report.txt"

REM Очищаем старый отчёт (если есть)
if exist "%REPORT%" del "%REPORT%"

echo ============================================================
echo              Диагностика компьютера
echo ============================================================
echo.
echo ============================================================ > "%REPORT%"
echo              Диагностика компьютера >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
echo. >> "%REPORT%"

REM -------------------- Операционная система --------------------
echo Операционная система
echo --------------------
echo Операционная система >> "%REPORT%"
echo -------------------- >> "%REPORT%"

for /f "tokens=1,* delims==" %%A in ('wmic os get Caption /value 2^>nul') do (
    if /i "%%A"=="Caption" (
        echo Название: %%B
        echo Название: %%B >> "%REPORT%"
    )
)
for /f "tokens=1,* delims==" %%A in ('wmic os get Version /value 2^>nul') do (
    if /i "%%A"=="Version" (
        echo Версия:   %%B
        echo Версия:   %%B >> "%REPORT%"
    )
)
echo.
echo. >> "%REPORT%"

REM -------------------- Процессор --------------------
echo Процессор
echo ---------
echo Процессор >> "%REPORT%"
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

REM -------------------- Оперативная память --------------------
echo Оперативная память
echo ------------------
echo Оперативная память >> "%REPORT%"
echo ------------------ >> "%REPORT%"

for /f "tokens=1,* delims==" %%A in ('wmic OS get TotalVisibleMemorySize /value 2^>nul') do (
    if /i "%%A"=="TotalVisibleMemorySize" set "TOTAL_KB=%%B"
)
for /f "tokens=1,* delims==" %%A in ('wmic OS get FreePhysicalMemory /value 2^>nul') do (
    if /i "%%A"=="FreePhysicalMemory" set "FREE_KB=%%B"
)

REM Переводим из КБ в ГБ (деление на 1048576)
set /a TOTAL_GB=%TOTAL_KB% / 1048576
set /a FREE_GB=%FREE_KB% / 1048576

echo Всего памяти:   %TOTAL_GB% ГБ
echo Свободно памяти: %FREE_GB% ГБ
echo Всего памяти:   %TOTAL_GB% ГБ >> "%REPORT%"
echo Свободно памяти: %FREE_GB% ГБ >> "%REPORT%"
echo.
echo. >> "%REPORT%"

REM -------------------- Диск C --------------------
echo Диск C
echo ------
echo Диск C >> "%REPORT%"
echo ------ >> "%REPORT%"

for /f "tokens=1,* delims==" %%A in ('wmic logicaldisk where "DeviceID='C:'" get Size /value 2^>nul') do (
    if /i "%%A"=="Size" set "SIZE_B=%%B"
)
for /f "tokens=1,* delims==" %%A in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value 2^>nul') do (
    if /i "%%A"=="FreeSpace" set "FREE_B=%%B"
)

REM Переводим из байт в ГБ (деление на 1073741824)
set /a SIZE_GB=%SIZE_B% / 1073741824
set /a FREE_DISK_GB=%FREE_B% / 1073741824

echo Общий размер:   %SIZE_GB% ГБ
echo Свободно:       %FREE_DISK_GB% ГБ
echo Общий размер:   %SIZE_GB% ГБ >> "%REPORT%"
echo Свободно:       %FREE_DISK_GB% ГБ >> "%REPORT%"
echo.
echo. >> "%REPORT%"

REM -------------------- Установленные программы --------------------
echo Установленные программы
echo -----------------------
echo (получение списка через реестр...)
echo.
echo Установленные программы >> "%REPORT%"
echo ----------------------- >> "%REPORT%"
echo. >> "%REPORT%"

REM 64-битные и нативные программы
for /f "tokens=2,*" %%A in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    echo %%B
    echo %%B >> "%REPORT%"
)

REM 32-битные программы на 64-битной системе
for /f "tokens=2,*" %%A in ('reg query

"HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    echo %%B
    echo %%B >> "%REPORT%"
)

echo.
echo. >> "%REPORT%"

REM -------------------- Сохранение отчёта --------------------
echo ============================================================
echo Отчёт сохранён: %REPORT%
echo ============================================================
echo ============================================================ >> "%REPORT%"
echo Отчёт сохранён: %REPORT% >> "%REPORT%"
echo ============================================================ >> "%REPORT%"

echo.
pause
