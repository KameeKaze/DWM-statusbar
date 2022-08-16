#!/bin/bash


Time() {
    echo "  $(date "+%H:%M" )"
}

WiFi() {
    IP=$(ip -f inet addr show wlan0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') 
    if [ -n "$IP" ]; then
        SSID=$(iw dev wlan0 link | awk -F: '/SSID/ {print $NF}')
        echo " $SSID $IP |"
    fi
}

Internet(){
    IP=$(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') 
    if [ -n "$IP" ]; then
        echo "  $IP |"
    fi   

}

Battery(){
    BAT0=$(cat /sys/class/power_supply/BAT0/capacity)
    BAT1=$(cat /sys/class/power_supply/BAT1/capacity)
    echo "   $BAT0   $BAT1 |"

}

Memory(){
    RAM=$(free -g -h -t | grep Mem | awk '{print $3}')
    echo " $RAM |"
}

Processor(){
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "  $CPU% |"
}

while true
do
    xsetroot -name "$(Processor)$(Memory)$(Battery)$(Internet)$(WiFi)$(Time) "
    sleep 1
done