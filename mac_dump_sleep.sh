#!/usr/bin/env bash
# dump sleep process

APP="sleep_test"

# cleanup
rm *.dmp
rm *.lldb
rm *.cpp
rm "$APP"

cat > source.cpp << EOF
#include <unistd.h>
int main() {
    sleep( 60 );
    return 0;
}
EOF
clang++ source.cpp -o "$APP"

./"$APP" &
PID=$(ps aux | ggrep "$APP" | tail -n 1 | awk '{print $2}')

echo "Dumping PID $PID to ${APP}_${PID}.dmp"
echo "process save-core \"${APP}_${PID}.dmp\"" > dump.lldb
echo -e "q\n" | lldb --attach-pid "$PID" --source dump.lldb

strings -n 25 - "${APP}_${PID}.dmp" > "strings_$APP.txt"
