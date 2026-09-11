#!/usr/bin/env bash
#
# Boots the emulator and runs Kaarigar from a clean slate, so the app always
# opens on the language picker (screen 1.2).
#
# Three things have to be true for that, and forgetting any one of them lands
# you on the finished setup instead:
#   * the emulator must cold boot, or it restores a snapshot taken mid-flow;
#   * the app's saved profile must be gone; and
#   * the running app must not re-read one that a hot restart left behind.
#
# Usage:  ./tool/fresh_run.sh
set -euo pipefail

SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
ADB="$SDK/platform-tools/adb"
EMULATOR="$SDK/emulator/emulator"
AVD="${KAARIGAR_AVD:-kaarigar_720p}"
PKG="com.kaarigar.kaarigar"

cd "$(dirname "$0")/.."

if ! "$ADB" devices | grep -q "^emulator-.*device$"; then
  echo "Booting $AVD (cold, no snapshot)…"
  # -no-snapshot-load forces a cold boot; -no-snapshot-save stops this run
  # from being restored next time. -allow-host-audio wires the Mac's
  # microphone through to the guest, without which the emulator feeds the
  # speech recogniser pure silence and dictation can never transcribe.
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

# Harmless when the app was never installed.
"$ADB" shell pm clear "$PKG" >/dev/null 2>&1 || true

echo "Starting Kaarigar at screen 1.2…"
exec flutter run --dart-define=fresh=true
