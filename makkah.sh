#!/data/data/com.termux/files/usr/bin/bash

URL="https://www.youtube.com/live/Zn7PajygY60"

clear

echo "==============================================="
echo "      🕋 LIVE MASJIDIL HARAM 24 JAM"
echo "==============================================="
echo

while true
do
    echo "[$(date '+%d-%m-%Y %H:%M:%S')] Menghubungkan..."

    STREAM=$(yt-dlp -f 93 -g "$URL" 2>/dev/null)

    if [ -n "$STREAM" ]; then
        echo "✅ Terhubung"
        echo "🎧 Memutar audio..."
        echo

        mpv \
            --no-video \
            --quiet \
            --cache=yes \
            --cache-secs=60 \
            "$STREAM"

        echo
        echo "⚠️ Stream terputus..."
    else
        echo "❌ Gagal mengambil stream."
    fi

    echo "🔄 Mencoba lagi dalam 5 detik..."
    sleep 5
    clear
    echo "==============================================="
    echo "      🕋 LIVE MASJIDIL HARAM 24 JAM"
    echo "==============================================="
    echo
done
