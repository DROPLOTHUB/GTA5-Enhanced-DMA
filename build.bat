@echo off
setlocal EnableExtensions EnableDelayedExpansion

cd /d "%~dp0"

echo ========================================
echo  GTA5 Enhanced DMA - Build
echo ========================================
echo.

:: Prefer vswhere (ships with VS Installer)
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
set "MSBUILD="

if exist "%VSWHERE%" (
    for /f "usebackq delims=" %%i in (`"%VSWHERE%" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do (
        set "MSBUILD=%%i"
    )
)

:: Fallbacks
if not defined MSBUILD if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD=%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
if not defined MSBUILD if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD=%ProgramFiles%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
if not defined MSBUILD if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD=%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
if not defined MSBUILD if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD=%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"

if not defined MSBUILD (
    echo [ERROR] MSBuild not found.
    echo Install Visual Studio 2022 with "Desktop development with C++".
    echo https://visualstudio.microsoft.com/downloads/
    goto :fail
)

echo Using MSBuild:
echo   %MSBUILD%
echo.

if not exist "GTA5_DMA.sln" (
    echo [ERROR] GTA5_DMA.sln not found. Run this bat from the repo root.
    goto :fail
)

:: Runtime deps check (post-build copies these next to the exe)
for %%F in (vmm.dll leechcore.dll FTD3XX.dll vmm.lib) do (
    if not exist "MemProcFS\%%F" (
        echo [ERROR] Missing MemProcFS\%%F
        echo See MemProcFS\README.md
        goto :fail
    )
)

if not exist "GTA5_DMA\Offsets.txt" (
    echo [ERROR] Missing GTA5_DMA\Offsets.txt
    goto :fail
)

echo Building Release ^| x64 ...
echo.
"%MSBUILD%" "GTA5_DMA.sln" /m /p:Configuration=Release /p:Platform=x64 /v:minimal
if errorlevel 1 (
    echo.
    echo [ERROR] Build failed.
    goto :fail
)

set "OUTDIR=%~dp0x64\Release"
echo.
echo Checking output folder:
echo   %OUTDIR%
echo.

set "MISSING=0"
for %%F in (GTA5_DMA.exe Offsets.txt vmm.dll leechcore.dll FTD3XX.dll) do (
    if exist "%OUTDIR%\%%F" (
        echo   [OK] %%F
    ) else (
        echo   [MISSING] %%F
        set "MISSING=1"
    )
)

if "!MISSING!"=="1" (
    echo.
    echo [WARN] Build finished but some runtime files are missing.
    echo Copy anything missing from MemProcFS\ into x64\Release\
    goto :fail
)

echo.
echo ========================================
echo  Done.
echo ========================================
echo.
echo Run:  x64\Release\GTA5_DMA.exe
echo Edit: x64\Release\Offsets.txt  ^(next to the EXE^)
echo.
echo FPGA must be plugged into this PC. Press END in-app to quit.
echo.
explorer "%OUTDIR%"
pause
exit /b 0

:fail
echo.
pause
exit /b 1
