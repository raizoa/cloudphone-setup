#!/data/data/com.termux/files/usr/bin/bash

set -u

URL="https://github.com/raizoa/cloudphone-setup/releases/download/V1.0/CloudKit.zip"

WORK_DIR="$HOME/CloudKit"
ZIP_FILE="$WORK_DIR/CloudKit.zip"
EXTRACT_DIR="$WORK_DIR/extracted"
ANDROID_DIR="/sdcard/Download/CloudKit"

echo ""
echo "=========================================="
echo "       CLOUDKIT AUTO SETUP"
echo "=========================================="
echo ""

mkdir -p "$WORK_DIR"
mkdir -p "$ANDROID_DIR"

echo "[1/4] Download CloudKit.zip..."

curl -fL \
    -C - \
    --retry 5 \
    --retry-delay 3 \
    --progress-bar \
    "$URL" \
    -o "$ZIP_FILE"

if [ ! -f "$ZIP_FILE" ]; then
    echo "ERROR: CloudKit.zip tidak ditemukan."
    exit 1
fi

echo ""
echo "[2/4] Memeriksa ZIP..."

if ! unzip -t "$ZIP_FILE" >/dev/null 2>&1; then
    echo "ERROR: ZIP rusak atau belum lengkap."
    exit 1
fi

echo "ZIP OK."

echo ""
echo "[3/4] Extract..."

rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"

echo ""
echo "[4/4] Menyalin semua APK..."

rm -f "$ANDROID_DIR"/*.apk 2>/dev/null || true

APK_COUNT=0

while IFS= read -r APK_FILE
do
    APK_NAME=$(basename "$APK_FILE")

    echo "Ditemukan: $APK_NAME"

    cp -f "$APK_FILE" "$ANDROID_DIR/$APK_NAME"

    APK_COUNT=$((APK_COUNT + 1))

done < <(find "$EXTRACT_DIR" -type f -iname "*.apk")

echo ""
echo "=========================================="
echo "           SELESAI"
echo "=========================================="

echo "Jumlah APK: $APK_COUNT"
echo ""

ls -lh "$ANDROID_DIR"

echo ""
echo "Lokasi:"
echo "$ANDROID_DIR"
