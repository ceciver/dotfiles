#!/bin/sh

# Keep the lower pen button configured for drag-to-scroll, including after
# unplugging and reconnecting the tablet.
command -v xinput >/dev/null 2>&1 || exit 0
command -v xsetwacom >/dev/null 2>&1 || exit 0

device_name='Wacom One by Wacom M Pen stylus'
last_device_id=''

while :; do
    device_id=$(xinput list --id-only "$device_name" 2>/dev/null || true)

    if [ -n "$device_id" ] && [ "$device_id" != "$last_device_id" ]; then
        xsetwacom set "$device_name" Button 2 pan
        xsetwacom set "$device_name" PanScrollThreshold 600
        last_device_id=$device_id
    elif [ -z "$device_id" ]; then
        last_device_id=''
    fi

    sleep 2
done
