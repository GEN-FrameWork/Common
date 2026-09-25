:: Run this in your Windows CMD
adb forward tcp:5039 tcp:5039
adb shell "/data/local/tmp/lldb-server g *:5039"