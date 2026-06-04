#!/usr/bin/env bash
set -euo pipefail

config_dir="$HOME/.config/polybar"
source_config="$config_dir/config.ini"
runtime_config="$config_dir/config.runtime.ini"

cp "$source_config" "$runtime_config"

battery=""
if [ -d /sys/class/power_supply/BAT0 ]; then
    battery="BAT0"
elif [ -d /sys/class/power_supply/BAT1 ]; then
    battery="BAT1"
fi

if [ -n "$battery" ]; then
    sed -i "s/^battery = .*/battery = $battery/" "$runtime_config"
else
    sed -i 's/^modules-right = pulseaudio memory cpu battery tray/modules-right = pulseaudio memory cpu tray/' "$runtime_config"
fi

polybar-msg cmd quit >/dev/null 2>&1 || true
pkill -x polybar >/dev/null 2>&1 || true

while pgrep -x polybar >/dev/null 2>&1; do
    sleep 0.2
done

nohup polybar main -c "$runtime_config" --reload >/tmp/polybar-main.log 2>&1 </dev/null &
