
:: 1. Create a script inside the phone that ONLY runs the server and ignores everything else
adb shell "echo '#!/system/bin/sh' > /data/local/tmp/start_lldb.sh"
adb shell "echo '/data/local/tmp/lldb-server g *:5039' >> /data/local/tmp/start_lldb.sh"

:: 2. Give it execution permissions
adb shell "chmod 777 /data/local/tmp/start_lldb.sh"
