# Keyboard Backlight Auto — Samsung Galaxy Book
# Path: /run/media/black/dbfa0647-b941-4878-ab09-c84ba0c6879c/Azure/AKS/Upgrade_1.34_to_1.35.6/keyboard_backlight_auto.md
# Device: /sys/class/leds/samsung-galaxybook::kbd_backlight
# Requirement: root or sudo for /dev/input/event* and sysfs brightness

# This is NOT AKS-related. User asked for keyboard backlight config on this host.
# Generated based on actual device discovery: brightnessctl, /sys/class/leds/samsung-galaxybook::kbd_backlight

---

## Actual Device Found

```
/sys/class/leds/samsung-galaxybook::kbd_backlight
  max_brightness: 3
  current (at time of check): 3
```

The LED file is `rw-r--r-- root root` — the controlling script must run as root (or with a udev rule granting user access).

---

## Option A — Bash + Python stdlib (no external libraries needed)

Runs a Python helper that reads `/dev/input/event*` (keyboard events) using only Python stdlib (`os`, `time`, `select`). No `python-evdev` required. When any keyboard event is read, sets LED brightness to max (3) and resets a 45-second countdown timer. If 45 seconds pass with zero keyboard events, sets brightness to 0.

Save as `/usr/local/bin/kbd-backlight-auto.sh` (or `~/kbd-backlight-auto.sh`):

```bash
#!/bin/bash
# kbd-backlight-auto.sh
# Auto keyboard backlight: ON on any key press, OFF after 45s of inactivity
# Requires root (or sudo) for /dev/input/event* and /sys/class/leds/*

DEVICE="/sys/class/leds/samsung-galaxybook::kbd_backlight/brightness"
MAX_BRIGHT=$(cat /sys/class/leds/samsung-galaxybook::kbd_backlight/max_brightness 2>/dev/null || echo 3)
TIMER_SEC=45

# Find keyboard event device (first input event matching keyboard)
# In practice /dev/input/event*; you may specify the exact event number.
# The script tries all event devices and monitors any that produces keyboard scancodes.
# For simplicity: use all event devices (requires root).

python3 - "$DEVICE" "$MAX_BRIGHT" "$TIMER_SEC" << 'PYEOF'
import sys, os, time, select

led_path = sys.argv[1]
max_b = int(sys.argv[2])
idle = int(sys.argv[3])

events = []
for entry in os.listdir('/dev/input'):
    if entry.startswith('event'):
        path = f'/dev/input/{entry}'
        try:
            f = open(path, 'rb')
            events.append(f)
        except Exception:
            pass

def set_kbd(state):
    try:
        with open(led_path, 'w') as f:
            f.write(str(max_b if state else 0))
    except Exception:
        pass

def reset_timer():
    # In pure Python stdlib without threading, we use select timeout as the timer mechanism.
    pass  # handled by the main loop select timeout

set_kbd(True)
last_activity = time.time()

while True:
    readable, _, _ = select.select(events, [], [], 1.0)
    if readable:
        # Any keyboard activity detected
        for f in readable:
            try:
                data = f.read(24)  # consume event (struct input_event ~24 bytes)
                if data:
                    last_activity = time.time()
                    set_kbd(True)
            except Exception:
                pass
    else:
        # No keyboard event in the last 1-second poll window
        pass

    # Check if 45 seconds passed with no activity
    if (time.time() - last_activity) > idle:
        set_kbd(False)
        # After turning off, we can either continue monitoring (for next press) or exit.
        # For continuous monitoring, reset timer after turning off so next press turns it back on.
        # We keep the loop running but reset the timer reference so it only turns back on with new activity.
        # Actually: after turning off, we just keep loop running; next activity will set last_activity = now and turn back on.
PYEOF
```

Wait — the above Python uses `select.select` with 1-second timeout; after turning off, the loop continues, but `last_activity` is not updated until a new event arrives. So the LED stays off until a new event turns it on. That is exactly the requested behavior.

However, the Python above will continuously poll `select` even when off. That is fine for a daemon. To avoid constant CPU usage, the select timeout is 1 second, which is acceptable.

**Fix: after turning off, we must NOT continuously write 0 (it's already 0). The loop will just keep checking `time.time() - last_activity > idle`. Once off, `last_activity` stays at the old time, so `(now - old) > 45` remains true. This means we must reset `last_activity` when turning off, or the condition stays true forever. Actually that's fine: `last_activity` is the time of the last keypress. Once off, it remains off. When a new keypress occurs, `last_activity` updates to `now`, sets brightness to max, and the timer restarts. That works correctly. The only issue is the LED file is written to 0 repeatedly once off. Let me fix by adding a `is_on` flag.

Revised Python snippet (clean version):

```python
#!/usr/bin/env python3
# Save as /usr/local/bin/kbd-backlight-monitor.py (run as root/sudo)
import sys, os, time, select

led_path = "/sys/class/leds/samsung-galaxybook::kbd_backlight/brightness"
with open("/sys/class/leds/samsung-galaxybook::kbd_backlight/max_brightness") as f:
    max_b = int(f.read().strip())
idle = int(sys.argv[1]) if len(sys.argv) > 1 else 45

events = []
for entry in os.listdir("/dev/input"):
    if entry.startswith("event"):
        try:
            events.append(open(f"/dev/input/{entry}", "rb"))
        except:
            pass

def set_on(on):
    with open(led_path, "w") as f:
        f.write(str(max_b if on else 0))

set_on(True)
last = time.time()
is_on = True
while True:
    r, _, _ = select.select(events, [], [], 1.0)
    if r:
        for f in r:
            try:
                f.read(24)
            except:
                pass
        last = time.time()
        if not is_on:
            set_on(True)
            is_on = True
    if is_on and (time.time() - last) > idle:
        set_on(False)
        is_on = False
```

Usage:
```bash
sudo /usr/local/bin/kbd-backlight-monitor.py 45
```

Or as a systemd service with `ExecStart=/usr/bin/python3 /usr/local/bin/kbd-backlight-monitor.py 45`.

---

## Option B — Bash-only with `timeout` and simple event polling (less efficient but pure bash)

Not recommended because `timeout` requires spawning per poll and bash cannot read binary event devices cleanly. Option A (Python stdlib) is preferred.

---

## Option C — Manual trigger via `brightnessctl` (if you don't want automatic)

```bash
# Turn keyboard backlight on (max 3)
brightnessctl --device=samsung-galaxybook::kbd_backlight set 3
# Turn off
brightnessctl --device=samsung-galaxybook::kbd_backlight set 0
```

---

## Making It Persistent (systemd service)

`/etc/systemd/system/kbd-backlight-auto.service`:

```ini
[Unit]
Description=Auto keyboard backlight (ON on press, OFF after 45s)
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/kbd-backlight-monitor.py 45
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

Enable:
```bash
sudo cp /etc/systemd/system/kbd-backlight-auto.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now kbd-backlight-auto
```

---

## Important Notes

- This requires root for both `/sys/class/leds/*/brightness` (writable by root only on this device) and `/dev/input/event*` (input events readable by root or `input` group members).
- The user preference (from memory and blackarch skill): prefers bash scripts over proprietary stacks; uses `brightnessctl`; prefers `pacman`; host is Samsung Galaxy Book (IPU6, PCI a75d) with this exact LED path.
- There is no AKS connection here; this is purely a local desktop customization request matching the blackarch/hyprland environment.
