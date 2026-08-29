#!/usr/bin/env bash
set -euo pipefail

echo "[+] Preparing build configuration..."
if [ ! -f "config_i586-unknown-elf" ]; then
    echo "[-] Error: config_i586-unknown-elf not found."
    exit 1
fi

cp config_i586-unknown-elf .config

echo "[+] Starting crosstool-NG build..."
ct-ng build

TOOLCHAIN_DIR="x-tools/HOST-x86_64-w64-mingw32/i586-unknown-elf"
if [ -d "${TOOLCHAIN_DIR}" ]; then
    echo "[+] Unlocking toolchain directory permissions..."
    chmod -R u+w "${TOOLCHAIN_DIR}"

    echo "[+] Creating required tmp directory..."
    mkdir -p "${TOOLCHAIN_DIR}/tmp"

    echo "[+] Stripping prefix 'i586-unknown-elf-' from executables in bin/..."
    for f in "${TOOLCHAIN_DIR}/bin/i586-unknown-elf-"*; do
        if [ -f "$f" ]; then
            base=$(basename "$f")
            new_name="${base#i586-unknown-elf-}"
            mv -f "$f" "${TOOLCHAIN_DIR}/bin/${new_name}"
        fi
    done

    echo "[+] Copying README.md and licenses to toolchain package..."
    cp -f README.md COPYING COPYING.LIB "${TOOLCHAIN_DIR}/"

    echo "[+] Packaging toolchain to i586-unknown-elf-win64.zip..."
    if command -v zip >/dev/null 2>&1; then
        (cd "x-tools/HOST-x86_64-w64-mingw32" && zip -r -q "../../i586-unknown-elf-win64.zip" "i586-unknown-elf")
        echo "[+] Package generated: i586-unknown-elf-win64.zip"
    else
        tar -czf i586-unknown-elf-win64.tar.gz -C "x-tools/HOST-x86_64-w64-mingw32" "i586-unknown-elf"
        echo "[+] Package generated: i586-unknown-elf-win64.tar.gz"
    fi
fi

echo "[+] Build and packaging complete."
