#!/data/data/com.termux/files/usr/bin/bash

echo "🕋 Installing Live Makkah..."

pkg update -y
pkg install -y mpv python nodejs git
pip install -U yt-dlp

chmod +x makkah.sh
cp makkah.sh $PREFIX/bin/makkah
chmod +x $PREFIX/bin/makkah

echo
echo "✅ Instalasi selesai."
echo "Jalankan dengan: makkah"
