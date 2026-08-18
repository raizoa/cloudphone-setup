#!/data/data/com.termux/files/usr/bin/bash

set -u

URL="https://github.com/raizoa/cloudphone-setup/releases/download/V1.0/CloudKit.zip"

WORK_DIR="$HOME/CloudKit"
ARCHIVE="$WORK_DIR/CloudKit.zip"
EXTRACT_DIR="$WORK_DIR/extracted"
ANDROID_DIR="/sdcard/Download/CloudKit"

echo ""
echo "=========================================="
echo " CLOUDKIT - 3 APK AUTO SETUP"
echo "=========================================="

echo "[1/7] Update Termux..."
pkg update -y

echo "[2/7] Install kebutuhan..."
pkg install -y curl unzip

echo "[3/7] Setup folder..."

mkdir -p "$WORK_DIR"
mkdir -p "$EXTRACT_DIR"
mkdir -p "$ANDROID_DIR"

echo ""
echo "[4/7] Download CloudKit.zip..."

curl -fL \
    -C - \
    --retry 5 \
    --retry-delay 3 \
    --progress-bar \
    "$URL" \
    -o "$ARCHIVE"

if [ ! -f "$ARCHIVE" ]; then
    echo "ERROR: File tidak ditemukan."
    exit 1
fi

echo ""
echo "[5/7] Memeriksa arsip..."

if ! unzip -t "$ARCHIVE" >/dev/null 2>&1; then
    echo "ERROR: ZIP rusak atau belum selesai."
    exit 1
fi

echo "ZIP OK."

echo ""
echo "[6/7] Extract semua file..."

rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

unzip -o "$ARCHIVE" -d "$EXTRACT_DIR"

echo ""
echo "[7/7] Mencari semua APK..."

APK_COUNT=0

find "$EXTRACT_DIR" -type f -iname "*.apk" | while read -r APK; do

    APK_NAME=$(basename "$APK")

    echo "Ditemukan: $APK_NAME"

    cp -f "$APK" "$ANDROID_DIR/$APK_NAME"

    APK_COUNT=$((APK_COUNT + 1))

done

echo ""
echo "=========================================="
echo " SEMUA APK TELAH DISALIN"
echo "=========================================="

echo ""
ls -lh "$ANDROID_DIR"

echo ""
echo "Lokasi:"
echo "$ANDROID_DIR"

echo ""
echo "Silakan install APK dari folder Download/CloudKit"
