#!/data/data/com.termux/files/usr/bin/bash

URL="https://github.com/raizoa/cloudphone-setup/releases/download/V1.0/CloudKit.zip"

echo "================================"
echo " CLOUDKIT AUTO INSTALLER"
echo "================================"

termux-setup-storage

pkg update -y
pkg install -y curl unzip

DOWNLOAD_DIR="$HOME/storage/downloads/CloudKit"
ZIP_FILE="$DOWNLOAD_DIR/CloudKit.zip"
EXTRACT_DIR="$DOWNLOAD_DIR/extracted"

mkdir -p "$DOWNLOAD_DIR"

echo "[1/4] Download CloudKit.zip..."

curl -L -C - \
  --retry 5 \
  --retry-delay 3 \
  "$URL" \
  -o "$ZIP_FILE"

echo "[2/4] Memeriksa ZIP..."

if ! unzip -t "$ZIP_FILE" >/dev/null; then
    echo "ERROR: ZIP rusak atau download belum selesai."
    exit 1
fi

echo "[3/4] Extract..."

rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"

echo "[4/4] Mencari APK..."

APK_FILE=$(find "$EXTRACT_DIR" -type f -iname "*.apk" | head -n 1)

if [ -z "$APK_FILE" ]; then
    echo "ERROR: APK tidak ditemukan."
    find "$EXTRACT_DIR" -type f
    exit 1
fi

echo "APK ditemukan:"
echo "$APK_FILE"

echo "Membuka installer..."
termux-open "$APK_FILE"
