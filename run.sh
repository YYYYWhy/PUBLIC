#!/bin/bash

if [ $# -eq 0 ]; then
    echo "provide the c-file name"
    exit 1
fi

SOURCE_FILE=$1
EXE_FILE="${SOURCE_FILE%.c}"
LOG_FILE="compile_log.txt"

clang "$SOURCE_FILE" -o "$EXE_FILE" -Wall -Wextra -Wfloat-equal -Wvla -pedantic -std=c99 -g3 -fsanitize=address -fsanitize=undefined -lm

if [ $? -ne 0 ]; then
    echo "compile failed。"
    exit 1
fi
if [ ! -f "$LOG_FILE" ]; then
    touch compile_log.txt
fi
echo "warnings and wrongs when compiling:"
grep -i -E "warning|error" "$LOG_FILE"

valgrind --leak-check=full ./"$EXE_FILE"
echo "warnings and wrongs when check memory:"
grep -i -E "warning|error|ERROR|WARNING" "$LOG_FILE"

./"$EXE_FILE" -Wall -Wextra -Wfloat-equal -Wvla -pedantic -std=c99 -g3 -fsanitize=address -fsanitize=undefined -lm
grep -i -E "warning|error" "$LOG_FILE"