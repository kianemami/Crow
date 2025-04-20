#!/bin/bash

# Configuration
PROGRAM="./Crow"       # Replace with your program path
ARGS=("5000" "127.0.0.1" "5001")   # Replace with your program arguments
OUT_LOG="out.log"              # Stdout log file
ERR_LOG="error.log"            # Stderr log file
RETRY_DELAY=1                 # Seconds to wait before restart (success or crash)

# Initialize logs (append mode)
echo "===== [$(date)] Starting super loop =====" | tee -a "$OUT_LOG" >> "$ERR_LOG"

# Super loop (runs forever)
while true; do
    # Log program start
    echo "[$(date)] Starting: $PROGRAM ${ARGS[@]}" | tee -a "$OUT_LOG" >> "$ERR_LOG"

    # Run the program (stdout & stderr redirected)
    "$PROGRAM" "${ARGS[@]}" >> "$OUT_LOG" 2>> "$ERR_LOG"
    EXIT_CODE=$?

    # Log exit status
    if [ $EXIT_CODE -eq 0 ]; then
        echo "[$(date)] Program finished successfully (Exit: $EXIT_CODE)" | tee -a "$OUT_LOG" >> "$ERR_LOG"
    else
        echo "[$(date)] Program CRASHED (Exit: $EXIT_CODE)" | tee -a "$OUT_LOG" >> "$ERR_LOG"
    fi

    # Wait before restarting (regardless of exit status)
    echo "[$(date)] Restarting in $RETRY_DELAY second(s)..." | tee -a "$OUT_LOG" >> "$ERR_LOG"
    sleep "$RETRY_DELAY"
done
