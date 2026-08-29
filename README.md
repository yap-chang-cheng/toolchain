# i586-unknown-elf Toolchain

本專案提供基於 **Crosstool-NG** 之 `i586-unknown-elf` 交叉編譯工具鏈建置組態（適用於 Windows x86_64 環境），並隨附 GNU Binutils 自訂 Opcode 補丁。

* **專案原始碼倉庫 (Source Repository)**：https://github.com/yap-chang-cheng/toolchain

---

## 一、 上游元件與授權資訊 (Upstream Components)

| 元件名稱 | 版本 | 授權條款 | 官方來源 (Upstream Source) |
| :--- | :--- | :--- | :--- |
| **Crosstool-NG** | `1.25.0` (Commit `994767d`) | GPL-2.0-or-later | https://github.com/crosstool-ng/crosstool-ng |
| **GNU Binutils** | `2.38` (含自訂 Patch) | GPL-3.0-or-later | https://mirrors.kernel.org/gnu/binutils/binutils-2.38.tar.xz |
| **GCC** | `12.1.0` | GPL-3.0-or-later | https://mirrors.kernel.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz |
| **Newlib** | `4.1.0` | BSD / GPL-compatible | https://sourceware.org/pub/newlib/newlib-4.1.0.tar.gz |
| **GNU Make** | `4.3` | GPL-3.0-or-later | https://mirrors.kernel.org/gnu/make/make-4.3.tar.gz |
| **GMP** | `6.2.1` | LGPL-3.0-or-later | https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz |
| **MPFR** | `4.1.0` | LGPL-3.0-or-later | https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz |
| **MPC** | `1.2.1` | LGPL-3.0-or-later | https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz |
| **ISL** | `0.24` | MIT | https://libisl.sourceforge.io/isl-0.24.tar.xz |
| **NCURSES** | `6.2` | MIT / X11-like | https://invisible-mirror.net/archives/ncurses/ncurses-6.2.tar.gz |
| **EXPAT** | `2.4.1` | MIT | https://github.com/libexpat/libexpat/releases/download/R_2_4_1/expat-2.4.1.tar.xz |

---

## 二、 自訂修改說明 (Modifications)

* **補丁檔案**：`patches/binutils/2.38/0001-custom-i386-opcodes.patch`
* **說明**：針對 `i586-unknown-elf` 目標調整 x86 Opcode 對應表（修改 `bfd`, `gas`, `gold`, `include`, `opcodes` 等模組）。

---

## 三、 自行編譯與建置指引 (Build Instructions)

* **建置環境**：Windows WSL (Ubuntu)，需預先安裝 Crosstool-NG 1.25.0、`mingw-w64` 與 `zip`。
* **一鍵自動編譯與打包**（自動建立 `tmp` 目錄並產出 `i586-unknown-elf-win64.zip`）：
  ```bash
  ./build.sh
  ```
* *或手動分步執行：*
  ```bash
  # 1. 執行建置
  cp config_i586-unknown-elf .config
  ct-ng build

  # 2. 解除唯讀權限、建立暫存目錄、去除前綴並複製授權
  chmod -R u+w x-tools/HOST-x86_64-w64-mingw32/i586-unknown-elf
  mkdir -p x-tools/HOST-x86_64-w64-mingw32/i586-unknown-elf/tmp
  for f in x-tools/HOST-x86_64-w64-mingw32/i586-unknown-elf/bin/i586-unknown-elf-*; do
      [ -f "$f" ] && mv "$f" "${f//i586-unknown-elf-/}"
  done
  cp README.md COPYING COPYING.LIB x-tools/HOST-x86_64-w64-mingw32/i586-unknown-elf/

  # 3. 打包為 zip
  cd x-tools/HOST-x86_64-w64-mingw32
  zip -r ../../i586-unknown-elf-win64.zip i586-unknown-elf
  ```

---

## 四、 授權條款 (License)

本專案所包含之建置腳本與原始碼補丁依 **GNU General Public License (GPLv3)** 發布。完整條款請參閱 `COPYING`。
