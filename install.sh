#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# 🕋 LIVE MASJIDIL HARAM 
# ==========================================

URL="https://www.youtube.com/live/8OB5WmcfUTk"

LOG="$HOME/makkah.log"

START_TIME=$(date +%s)
RECONNECT=0
LAST_RESTART=""

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock

# ==========================================
# Dashboard
# ==========================================

dashboard() {

    clear

    NOW=$(date "+%d %b %Y")
    JAM=$(date "+%H:%M:%S")

    if ping -c1 -W1 8.8.8.8 >/dev/null 2>&1
    then
        NET="${GREEN}🟢 ONLINE${NC}"
        PING=$(ping -c1 8.8.8.8 | awk -F'time=' '/time=/{print $2}' | cut -d' ' -f1)
    else
        NET="${RED}🔴 OFFLINE${NC}"
        PING="-"
    fi

    RAM=$(free -m | awk '/Mem:/ {print $3"/"$2" MB"}')

    SEC=$(( $(date +%s)-START_TIME ))
    H=$((SEC/3600))
    M=$(((SEC%3600)/60))
    S=$((SEC%60))

    UPTIME=$(printf "%02d:%02d:%02d" $H $M $S)

    echo -e "${CYAN}┌──────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}         🕋 LIVE MASJIDIL HARAM             ${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────┤${NC}"

    printf " 📅 %-42s \n" "$NOW"
    printf " 🕒 %-42s \n" "$JAM"

    printf " 📶 Internet  : %-28b \n" "$NET"
    printf " ▶  Status    : 🔊 PLAYING                  \n"
    printf " 🔄 Reconnect : %-27s \n" "$RECONNECT"
    printf " ❤️  Uptime    : %-27s \n" "$UPTIME"
    printf " 💾 RAM       : %-27s \n" "$RAM"
    printf " 📡 Ping      : %sms \n" "$PING"
    printf " 🕘 Restart   : 09:00 & 15:00             \n"

    echo -e "${CYAN}├──────────────────────────────────────────────┤${NC}"
    echo -e " ${RED}Ctrl+C = Keluar                            ${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────┘${NC}"
}

# ==========================================
# Cek Internet
# ==========================================

wait_internet() {

    until ping -c1 8.8.8.8 >/dev/null 2>&1
    do
        dashboard
        echo
        echo "📡 Menunggu koneksi internet..."
        sleep 5
    done
}
# ==========================================
# Ambil URL Stream
# ==========================================

get_stream() {

    dashboard
    echo
    echo "🔄 Mengambil URL Stream..."

    STREAM=$(yt-dlp \
        --js-runtimes node \
        -f 93 \
        -g "$URL" 2>/dev/null)

    if [ -z "$STREAM" ]; then
        echo "$(date) Gagal mengambil stream." >> "$LOG"
        echo
        echo "❌ Gagal mengambil URL."
        sleep 10
        return 1
    fi

    return 0
}

# ==========================================
# Jalankan MPV
# ==========================================

play_stream() {

    dashboard
    echo
    echo "▶ Memulai audio..."

    mpv \
        --no-video \
        --force-window=no \
        --audio-display=no \
        --cache=yes \
        --cache-secs=60 \
        --network-timeout=20 \
        --keep-open=no \
        --quiet \
        "$STREAM" &

    PID=$!

    echo "$(date) MPV Started PID=$PID" >> "$LOG"
}

# ==========================================
# Watchdog
# ==========================================

watchdog() {

    while kill -0 "$PID" 2>/dev/null
    do

        dashboard

        HOUR=$(date +%H)
        TODAY=$(date +%F)

        # Restart 09:00
        if [ "$HOUR" = "09" ] && [ "$LAST_RESTART" != "$TODAY-09" ]; then

            echo "$(date) Restart Terjadwal 09:00" >> "$LOG"

            LAST_RESTART="$TODAY-09"

            kill -TERM "$PID"
            wait "$PID" 2>/dev/null

            return
        fi

        # Restart 15:00
        if [ "$HOUR" = "15" ] && [ "$LAST_RESTART" != "$TODAY-15" ]; then

            echo "$(date) Restart Terjadwal 15:00" >> "$LOG"

            LAST_RESTART="$TODAY-15"

            kill -TERM "$PID"
            wait "$PID" 2>/dev/null

            return
        fi

        # Internet putus
        if ! ping -c1 8.8.8.8 >/dev/null 2>&1
        then

            echo "$(date) Internet Putus" >> "$LOG"

            kill -TERM "$PID"
            wait "$PID" 2>/dev/null

            wait_internet

            return
        fi

        sleep 5

    done

    echo "$(date) MPV berhenti." >> "$LOG"

}
# ==========================================
# Program Utama
# ==========================================

echo "=========================================" >> "$LOG"
echo "$(date) Live Makkah" >> "$LOG"

while true
do

    wait_internet

    if ! get_stream
    then
        sleep 10
        continue
    fi

    play_stream

    watchdog

    RECONNECT=$((RECONNECT+1))

    dashboard
    echo
    echo "🔄 Reconnect dalam 5 detik..."

    sleep 10

done
