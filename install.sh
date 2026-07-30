#!/data/data/com.termux/files/usr/bin/bash

clear
echo "======================================"
echo "    🕋 INSTALL LIVE MASJIDIL HARAM"
echo "======================================"
echo

pkg update -y
pkg upgrade -y

pkg install -y \
git \
python \
nodejs \
mpv \
termux-api

pip install -U yt-dlp

chmod +x makkah.sh

cp makkah.sh $PREFIX/bin/makkah
chmod +x $PREFIX/bin/makkah

echo
echo "======================================"
echo "✅ Instalasi berhasil!"
echo
echo "Sekarang jalankan dengan:"
echo
echo "makkah"
echo "======================================"
