@echo off
setlocal enabledelayedexpansion

:: Configuration
set "PROGRAM=Crow.exe"  :: Your program
set "ARGS=5000 127.0.0.1 5001"       :: Arguments
set "OUT_LOG=out.log"           :: Stdout log
set "ERR_LOG=error.log"         :: Stderr log
set "RETRY_DELAY=1"             :: Delay before restart (seconds)

:: Initialize logs (append mode)
echo ===== [%date% %time%] Starting super loop ===== >> "%OUT_LOG%"
echo ===== [%date% %time%] Starting super loop ===== >> "%ERR_LOG%"

:: Super loop (runs forever)
:super_loop
    :: Log program start
    echo [%date% %time%] Starting: %PROGRAM% %ARGS% >> "%OUT_LOG%"
    echo [%date% %time%] Starting: %PROGRAM% %ARGS% >> "%ERR_LOG%"

    :: Run the program (redirect stdout/stderr)
    call "%PROGRAM%" %ARGS% >> "%OUT_LOG%" 2>> "%ERR_LOG%"
    set "EXIT_CODE=!errorlevel!"

    :: Log exit status
    if !EXIT_CODE! equ 0 (
        echo [%date% %time%] Program finished successfully (Exit: !EXIT_CODE!) >> "%OUT_LOG%"
        echo [%date% %time%] Program finished successfully (Exit: !EXIT_CODE!) >> "%ERR_LOG%"
    ) else (
        echo [%date% %time%] Program CRASHED (Exit: !EXIT_CODE!) >> "%OUT_LOG%"
        echo [%date% %time%] Program CRASHED (Exit: !EXIT_CODE!) >> "%ERR_LOG%"
    )

    :: Wait before restarting (regardless of exit status)
    echo [%date% %time%] Restarting in %RETRY_DELAY% second(s)... >> "%OUT_LOG%"
    echo [%date% %time%] Restarting in %RETRY_DELAY% second(s)... >> "%ERR_LOG%"
    timeout /t %RETRY_DELAY% /nobreak > nul

    goto :super_loop
