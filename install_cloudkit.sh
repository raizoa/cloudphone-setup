#!/data/data/com.termux/files/usr/bin/bash

set -u

URL="https://github.com/raizoa/cloudphone-setup/releases/download/V1.0/CloudKit.zip"

WORK_DIR="$HOME/CloudKit"
ZIP_FILE="$WORK_DIR/CloudKit.zip"
EXTRACT_DIR="$WORK_DIR/extracted"

ANDROID_DOWNLOAD="/sdcard/Download"
APK_OUTPUT="$ANDROID_DOWNLOAD/CloudKit.apk"

echo ""
echo "=========================================="
echo "       CLOUDKIT AUTO INSTALLER"
echo "=========================================="
echo ""

# ==========================================
# 1. INSTALL PACKAGE
# ==========================================

echo "[1/7] Update Termux..."

pkg update -y

echo "[2/7] Install kebutuhan..."

pkg install -y curl unzip file

# ==========================================
# 2. SETUP STORAGE
# ==========================================

echo "[3/7] Menyiapkan storage Android..."

termux-setup-storage

mkdir -p "$WORK_DIR"
mkdir -p "$ANDROID_DOWNLOAD"

# ==========================================
# 3. DOWNLOAD
# ==========================================

echo "[4/7] Download CloudKit.zip..."
echo ""

if [ -f "$ZIP_FILE" ]; then
    echo "File sebelumnya ditemukan."
    echo "Melanjutkan / mengecek download..."
fi

curl -fL \
    -C - \
    --retry 5 \
    --retry-delay 3 \
    --progress-bar \
    "$URL" \
    -o "$ZIP_FILE"

echo ""
echo "Download selesai."

# ==========================================
# 4. CHECK FILE
# ==========================================

echo ""
echo "[5/7] Memeriksa file..."

if [ ! -f "$ZIP_FILE" ]; then
    echo "ERROR: CloudKit.zip tidak ditemukan."
    exit 1
fi

echo "Ukuran file:"
ls -lh "$ZIP_FILE"

echo ""
echo "Memeriksa ZIP..."

if ! unzip -t "$ZIP_FILE" >/dev/null 2>&1; then

    echo ""
    echo "ERROR: File ZIP rusak atau belum lengkap."
    echo ""
    echo "Hapus file dan coba download ulang:"
    echo "rm -f '$ZIP_FILE'"

    exit 1
fi

echo "ZIP OK."

# ==========================================
# 5. EXTRACT
# ==========================================

echo ""
echo "[6/7] Extract CloudKit..."

rm -rf "$EXTRACT_DIR"

mkdir -p "$EXTRACT_DIR"

unzip -o \
    "$ZIP_FILE" \
    -d "$EXTRACT_DIR"

# ==========================================
# 6. FIND APK
# ==========================================

echo ""
echo "[7/7] Mencari APK..."

APK_FILE=$(find "$EXTRACT_DIR" \
    -type f \
    -iname "*.apk" \
    | head -n 1)

if [ -z "$APK_FILE" ]; then

    echo ""
    echo "ERROR: File APK tidak ditemukan."
    echo ""
    echo "Isi folder extract:"
    find "$EXTRACT_DIR" -type f

    exit 1
fi

echo ""
echo "=========================================="
echo " APK DITEMUKAN"
echo "=========================================="

echo "$APK_FILE"

echo ""
echo "Ukuran APK:"
ls -lh "$APK_FILE"

# ==========================================
# 7. COPY TO ANDROID DOWNLOAD
# ==========================================

echo ""
echo "Menyalin APK ke Android Download..."

cp -f "$APK_FILE" "$APK_OUTPUT"

if [ ! -f "$APK_OUTPUT" ]; then

    echo ""
    echo "ERROR: Gagal menyalin APK ke Download."

    exit 1
fi

echo ""
echo "=========================================="
echo " APK SIAP DIINSTALL"
echo "=========================================="

echo "$APK_OUTPUT"

echo ""
echo "Membuka Android Package Installer..."

termux-open \
    -t application/vnd.android.package-archive \
    "$APK_OUTPUT"

echo ""
echo "=========================================="
echo " SILAKAN INSTALL CLOUDKIT"
echo "=========================================="
