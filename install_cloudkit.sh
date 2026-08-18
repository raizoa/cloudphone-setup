#!/data/data/com.termux/files/usr/bin/bash

set -u

export DEBIAN_FRONTEND=noninteractive

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


# ==========================================
# 1. INSTALL KEBUTUHAN
# ==========================================

echo "[1/6] Menyiapkan Termux..."

pkg update -y
pkg upgrade -y
pkg install -y curl unzip


# ==========================================
# 2. STORAGE DAN FOLDER
# ==========================================

echo "[2/6] Menyiapkan folder..."

# Meminta izin storage jika belum ada
if [ ! -d "$HOME/storage" ]; then
    echo "Meminta izin storage Android..."
    termux-setup-storage
    sleep 3
fi

mkdir -p "$WORK_DIR"
mkdir -p "$ANDROID_DIR"


# ==========================================
# 3. DOWNLOAD ZIP
# ==========================================

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



# ==========================================
# 4. CEK ZIP
# ==========================================

echo ""
echo "[4/6] Memeriksa CloudKit.zip..."


if ! unzip -t "$ZIP_FILE" >/dev/null 2>&1; then

    echo ""
    echo "ERROR: ZIP rusak atau download belum lengkap."
    echo "Hapus:"
    echo "rm -f $ZIP_FILE"

    exit 1

fi


echo "ZIP OK."



# ==========================================
# 5. EXTRACT
# ==========================================

echo ""
echo "[5/6] Extract semua APK..."


rm -rf "$EXTRACT_DIR"

mkdir -p "$EXTRACT_DIR"


unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"



# ==========================================
# 6. COPY APK
# ==========================================

echo ""
echo "[6/6] Menyalin semua APK..."


APK_COUNT=0


while IFS= read -r APK_FILE
do

    APK_NAME=$(basename "$APK_FILE")

    echo "Ditemukan:"
    echo "$APK_NAME"


    cp -f "$APK_FILE" "$ANDROID_DIR/$APK_NAME"


    APK_COUNT=$((APK_COUNT+1))


done < <(find "$EXTRACT_DIR" -type f -iname "*.apk")



echo ""
echo "=========================================="
echo " HASIL"
echo "=========================================="

echo "Jumlah APK : $APK_COUNT"

echo ""

find "$ANDROID_DIR" -type f -iname "*.apk"



echo ""
echo "=========================================="
echo " SELESAI"
echo "=========================================="

echo ""
echo "Lokasi APK:"
echo "$ANDROID_DIR"

echo ""


# Buka folder hasil
if command -v termux-open >/dev/null; then

    termux-open "$ANDROID_DIR"

fi
