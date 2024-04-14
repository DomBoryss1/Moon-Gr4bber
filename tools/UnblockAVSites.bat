@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if not %errorlevel% == 0 (
    echo Administrator privileges required. Re-running as administrator...
    set "cmdargs=%*"
    set "runscript=%0"
    powershell -Command "Start-Process '%runscript%' -ArgumentList '%cmdargs%' -Verb RunAs"
    exit /b
)

set "hostfilepath=%SystemRoot%\System32\drivers\etc\hosts"

set "BANNED_URLS=virustotal.com avast.com totalav.com scanguard.com totaladblock.com pcprotect.com mcafee.com bitdefender.com us.norton.com avg.com malwarebytes.com pandasecurity.com avira.com norton.com eset.com zillya.com kaspersky.com usa.kaspersky.com sophos.com home.sophos.com adaware.com bullguard.com clamav.net drweb.com emsisoft.com f-secure.com zonealarm.com trendmicro.com ccleaner.com"

type nul > "%hostfilepath%.tmp"
for /f "tokens=*" %%i in ('type "%hostfilepath%"') do (
    set "line=%%i"
    set "skipLine="
    for %%b in (!BANNED_URLS!) do (
        echo !line! | find /i "%%b" >nul && set "skipLine=1"
    )
    if not defined skipLine echo %%i >> "%hostfilepath%.tmp"
)

copy /y "%hostfilepath%.tmp" "%hostfilepath%" >nul

del "%hostfilepath%.tmp" >nul 2>&1

echo Unblocked sites
pause
