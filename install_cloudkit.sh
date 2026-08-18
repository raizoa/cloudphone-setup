#!/data/data/com.termux/files/usr/bin/bash

set -e

URL="https://github.com/raizoa/cloudphone-setup/releases/download/V1.0/CloudKit.zip"

WORK_DIR="$HOME/CloudKit"
ZIP_FILE="$WORK_DIR/CloudKit.zip"
EXTRACT_DIR="$WORK_DIR/extracted"

echo "================================"
echo " CLOUDKIT AUTO INSTALLER"
echo "================================"

echo "[1/4] Install kebutuhan..."
pkg update -y
pkg install -y curl unzip

mkdir -p "$WORK_DIR"

echo ""
echo "[2/4] Download CloudKit.zip..."

curl -fL -C - \
  --retry 5 \
  --retry-delay 3 \
  --progress-bar \
  "$URL" \
  -o "$ZIP_FILE"

echo ""
echo "[INFO] Mengecek file..."

ls -lh "$ZIP_FILE"

if [ ! -f "$ZIP_FILE" ]; then
    echo "ERROR: File ZIP tidak ditemukan."
    exit 1
fi

echo ""
echo "[3/4] Memeriksa ZIP..."

if ! unzip -t "$ZIP_FILE"; then
    echo "ERROR: ZIP rusak atau belum lengkap."
    exit 1
fi

echo ""
echo "[4/4] Extract..."

rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"

echo ""
echo "Mencari APK..."

APK_FILE=$(find "$EXTRACT_DIR" -type f \( -iname "*.apk" -o -iname "*.xapk" \) | head -n 1)

if [ -z "$APK_FILE" ]; then
    echo "ERROR: APK/XAPK tidak ditemukan."
    echo ""
    echo "Isi hasil extract:"
    find "$EXTRACT_DIR" -type f
    exit 1
fi

echo ""
echo "================================"
echo " FILE DITEMUKAN:"
echo "$APK_FILE"
echo "================================"

echo "Membuka installer..."
termux-open "$APK_FILE"
