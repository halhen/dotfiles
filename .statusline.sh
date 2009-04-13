loadavg="`cat /proc/loadavg | awk '{print $1, $2, $3}'`"
mempercent="`free -b | awk 'NR == 2 { print int(0.5 + 1000 * ($3 - ($6 + $7)) / $2)/10}'`"
batperstring="`acpi | awk '{print $4}' | sed s/,//g`"

echo "[load ${loadavg}] [mem ${mempercent}%] [bat $batperstring]   `date +'%R'`"