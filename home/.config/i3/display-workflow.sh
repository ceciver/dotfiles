#!/bin/sh

# Apply the display layout whenever the connector state changes. flock makes
# this safe across i3 reloads, which otherwise could start duplicate watchers.
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/i3-display-workflow.$(id -u).lock"
WALLPAPER="$HOME/.config/i3/backgrounds/archwave.png"
exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

set_wallpaper() {
    if command -v feh >/dev/null 2>&1 && [ -r "$WALLPAPER" ]; then
        feh --no-fehbg --bg-fill "$WALLPAPER"
    fi
}

start_bar() {
    if command -v polybar >/dev/null 2>&1 && [ -x "$HOME/.config/polybar/launch.sh" ]; then
        # Do not let the long-lived Polybar process inherit the watcher lock.
        "$HOME/.config/polybar/launch.sh" 9>&-
    fi
}

command -v xrandr >/dev/null 2>&1 || exit 0

last_state=""
while :; do
    connected_outputs=$(xrandr --query 2>/dev/null | awk '$2 == "connected" { print $1 }')
    if [ -n "$connected_outputs" ] && [ "$connected_outputs" != "$last_state" ]; then
        has_output() {
            printf '%s\n' "$connected_outputs" | grep -Fxq "$1"
        }

        if has_output HDMI-1 && has_output eDP-1; then
            # Mirror a 2560x1440 desktop at the external monitor's native
            # resolution on this laptop. Other hardware uses auto detection.
            xrandr --fb 2560x1440 \
                   --output HDMI-1 --mode 2560x1440 --rate 59.95 --pos 0x0 \
                   --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --scale-from 2560x1440 || xrandr --auto
        elif [ "$connected_outputs" = eDP-1 ]; then
            xrandr --output HDMI-1 --off \
                   --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --scale 1x1 || xrandr --auto
            for ws in 1 2 3 4 5 6 7 8 9 10; do
                i3-msg "workspace number $ws; move workspace to output eDP-1" >/dev/null
            done
        else
            xrandr --auto
        fi

        set_wallpaper
        # Polybar caches monitor geometry, so refresh it after xrandr.
        start_bar
    fi
    last_state="$connected_outputs"
    sleep 2
done
