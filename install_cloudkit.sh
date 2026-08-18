#!/data/data/com.termux/files/usr/bin/bash

set -u

URL="https://github.com/raizoa/cloudphone-setup/releases/download/V1.0/CloudKit.zip"

WORK_DIR="$HOME/CloudKit"
ZIP_FILE="$WORK_DIR/CloudKit.zip"
EXTRACT_DIR="$WORK_DIR/extracted"

# Folder hasil agar bisa dilihat Android
ANDROID_DIR="/sdcard/Download/CloudKit"

echo ""
echo "=========================================="
echo "       CLOUDKIT AUTO SETUP"
echo "=========================================="
echo ""

# 1. Install kebutuhan
echo "[1/6] Menyiapkan Termux..."

pkg update -y
pkg install -y curl unzip

# 2. Setup folder
echo "[2/6] Menyiapkan folder..."

mkdir -p "$WORK_DIR"
mkdir -p "$ANDROID_DIR"

# 3. Download ZIP
echo "[3/6] Download CloudKit.zip..."

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
echo "Download selesai:"
ls -lh "$ZIP_FILE"

# 4. Cek ZIP
echo ""
echo "[4/6] Memeriksa CloudKit.zip..."

if ! unzip -t "$ZIP_FILE" >/dev/null 2>&1; then
    echo "ERROR: ZIP rusak atau download belum lengkap."
    echo "Hapus file dan coba ulang:"
    echo "rm -f $ZIP_FILE"
    exit 1
fi

echo "ZIP OK."

# 5. Extract
echo ""
echo "[5/6] Extract semua APK..."

rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"

unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"

# 6. Copy semua APK
echo ""
echo "[6/6] Mencari semua APK..."

APK_COUNT=0

find "$EXTRACT_DIR" -type f -iname "*.apk" | while IFS= read -r APK_FILE
do
    APK_NAME=$(basename "$APK_FILE")

    echo "Ditemukan: $APK_NAME"

    cp -f "$APK_FILE" "$ANDROID_DIR/$APK_NAME"
done

echo ""
echo "=========================================="
echo " APK YANG BERHASIL DIEKSTRAK"
echo "=========================================="

find "$ANDROID_DIR" -type f -iname "*.apk"

echo ""
echo "=========================================="
echo " SELESAI"
echo "=========================================="
echo ""
echo "Lokasi APK:"
echo "$ANDROID_DIR"
echo ""

# Coba buka folder Download
termux-open "$ANDROID_DIR"
