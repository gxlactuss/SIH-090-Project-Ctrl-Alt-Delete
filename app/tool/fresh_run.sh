#!/usr/bin/env bash
set -euo pipefail

SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
ADB="$SDK/platform-tools/adb"
EMULATOR="$SDK/emulator/emulator"
AVD="${KAARIGAR_AVD:-kaarigar_720p}"
PKG="com.kaarigar.kaarigar"

cd "$(dirname "$0")/.."

if ! "$ADB" devices | grep -q "^emulator-.*device$"; then
  echo "Booting $AVD (cold, no snapshot)…"
  "$EMULATOR" -avd "$AVD" \
    -no-snapshot-load -no-snapshot-save -allow-host-audio >/dev/null 2>&1 &
else
  echo "Emulator already running."
fi

echo "Waiting for boot…"
"$ADB" wait-for-device
until [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
  sleep 2
done

"$ADB" shell pm clear "$PKG" >/dev/null 2>&1 || true

echo "Starting Kaarigar at screen 1.2…"
exec flutter run --dart-define=fresh=true
