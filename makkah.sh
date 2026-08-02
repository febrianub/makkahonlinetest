#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# 🕋 LIVE MASJIDIL HARAM
# ==========================================

URL="https://www.youtube.com/live/wawzF8i5yAo"

if ! command -v mpv >/dev/null \
 || ! command -v yt-dlp >/dev/null \
 || ! command -v node >/dev/null; then
    pkg update -y
fi
# AUTO INSTALL DEPENDENCY
# ==========================================

check_dep() {

    command -v pkg >/dev/null || {
        echo "❌ Script hanya untuk Termux"
        exit 1
    }

    PKGS=""

    command -v python  >/dev/null || PKGS="$PKGS python"
    command -v node    >/dev/null || PKGS="$PKGS nodejs"
    command -v mpv     >/dev/null || PKGS="$PKGS mpv"
    command -v ffmpeg  >/dev/null || PKGS="$PKGS ffmpeg"

    if [ -n "$PKGS" ]; then
        pkg update -y
        pkg install -y $PKGS
    fi

    command -v yt-d
    }
# ==========================================
# LOG
# ==========================================

LOG_DIR="$HOME/log"
mkdir -p "$LOG_DIR"

LOG="$LOG_DIR/makkah-$(date +%F).log"

# Hapus log lebih dari 7 hari
find "$LOG_DIR" -type f -name "makkah-*.log" -mtime +7 -delete

# ==========================================
# WARNA
# ==========================================

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
NC="\033[0m"

# ==========================================
# WAKE LOCK
# ==========================================

command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock

# ==========================================
# VARIABEL
# ==========================================

START_TIME=$(date +%s)

PID=0
STREAM=""
RECONNECT=0

REFRESH_INTERVAL=$((4*60*60))
LAST_REFRESH=$(date +%s)

LAST_RESTART=""

VOLUME=100
LAST_VOLUME=100

# ==========================================
# SMART VOLUME
# ==========================================

smart_volume() {

    HOUR=$(date +%H)

    if [ "$HOUR" -ge 22 ] || [ "$HOUR" -lt 5 ]; then
        VOLUME=40

    elif [ "$HOUR" -ge 18 ]; then
        VOLUME=60

    else
        VOLUME=100
    fi

}

# ==========================================
# DASHBOARD
# ==========================================

dashboard() {

    clear

    smart_volume

    if ping -c1 -W1 8.8.8.8 >/dev/null 2>&1
    then
        NET="${GREEN}🟢 ONLINE${NC}"
        PING=$(ping -c1 8.8.8.8 | awk -F'time=' '/time=/{print $2}' | cut -d' ' -f1)
    else
        NET="${RED}🔴 OFFLINE${NC}"
        PING="-"
    fi

    RAM=$(free -m | awk '/Mem:/ {print $3}')

    SEC=$(( $(date +%s)-START_TIME ))

    UPTIME=$(printf "%02d:%02d:%02d" \
        $((SEC/3600)) \
        $(((SEC%3600)/60)) \
        $((SEC%60)))

    LEFT=$((REFRESH_INTERVAL-($(date +%s)-LAST_REFRESH)))

    [ "$LEFT" -lt 0 ] && LEFT=0

    REFRESH=$(printf "%02d:%02d:%02d" \
        $((LEFT/3600)) \
        $(((LEFT%3600)/60)) \
        $((LEFT%60)))

    echo "══════════════════════════════"
    echo " 🕋 LIVE MASJIDIL HARAM"
    echo "══════════════════════════════"

    printf "📅 %s\n" "$(date '+%d %b %Y')"
    printf "🕒 %s\n" "$(date '+%H:%M:%S')"
    printf "📶 %b\n" "$NET"
    printf "▶  PLAYING\n"
    printf "🔊 Volume    : %s%%\n" "$VOLUME"
    printf "🔄 Reconnect : %s\n" "$RECONNECT"
    printf "❤️  Uptime    : %s\n" "$UPTIME"
    printf "💾 RAM       : %s MB\n" "$RAM"
    printf "📡 Ping      : %s ms\n" "$PING"
    printf "⏳ Refresh   : %s\n" "$REFRESH"

    echo "══════════════════════════════"
    echo "Ctrl+C untuk keluar"
    echo "══════════════════════════════"

}
# ==========================================
# Ambil URL Stream
# ==========================================
wait_internet() {

    until ping -c1 -W2 8.8.8.8 >/dev/null 2>&1
    do
        dashboard
        echo
        echo "🌐 Menunggu koneksi internet..."
        sleep 5
    done

}
get_stream() {

    dashboard

    echo
    echo "🔄 Mengambil URL Stream..."

    STREAM=$(yt-dlp \
        --js-runtimes node \
        -f 93 \
        -g "$URL" 2>/dev/null)

    if [ -z "$STREAM" ]; then

        echo "$(date '+%F %T') | Gagal mengambil URL Stream" >> "$LOG"

        echo
        echo "❌ Gagal mengambil URL."

        sleep 10

        return 1

    fi

    echo "$(date '+%F %T') | URL Stream berhasil diperbarui" >> "$LOG"

    return 0

}

# ==========================================
# Jalankan MPV
# ==========================================

play_stream() {

    dashboard

    echo
    echo "▶ Memulai Audio..."
    echo "🔊 Volume : ${VOLUME}%"

    smart_volume

    mpv \
        --no-video \
        --volume="$VOLUME" \
        --force-window=no \
        --audio-display=no \
        --cache=yes \
        --cache-secs=60 \
        --network-timeout=20 \
        --keep-open=no \
        --quiet \
        "$STREAM" &

    PID=$!

    echo "$(date '+%F %T') | MPV Started | PID=$PID | Volume=${VOLUME}%" >> "$LOG"

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

            echo "$(date '+%F %T') | Restart Terjadwal 09:00" >> "$LOG"

            LAST_RESTART="$TODAY-09"

            kill -TERM "$PID"
            wait "$PID" 2>/dev/null

            return
        fi

        # Restart 15:00
        if [ "$HOUR" = "15" ] && [ "$LAST_RESTART" != "$TODAY-15" ]; then

            echo "$(date '+%F %T') | Restart Terjadwal 15:00" >> "$LOG"

            LAST_RESTART="$TODAY-15"

            kill -TERM "$PID"
            wait "$PID" 2>/dev/null

            return
        fi

        # Smart Volume
        smart_volume

        if [ "$VOLUME" != "$LAST_VOLUME" ]; then

            echo "$(date '+%F %T') | Volume berubah menjadi ${VOLUME}%" >> "$LOG"

            LAST_VOLUME="$VOLUME"

            kill -TERM "$PID"
            wait "$PID" 2>/dev/null

            return
        fi

        # Internet putus
        if ! ping -c1 -W2 8.8.8.8 >/dev/null 2>&1
        then

            echo "$(date '+%F %T') | Internet Putus" >> "$LOG"

            kill -TERM "$PID"
            wait "$PID" 2>/dev/null

            wait_internet

            return

        fi

        # Refresh Player 4 jam
NOW=$(date +%s)

if [ $((NOW-LAST_REFRESH)) -ge $((4*60*60)) ]; then

    echo "$(date '+%F %T') | Refresh Player" >> "$LOG"

    LAST_REFRESH=$NOW

    kill -9 "$PID" 2>/dev/null
    wait "$PID" 2>/dev/null

    STREAM=""

    return

fi

        sleep 5

    done

    echo "$(date '+%F %T') | MPV berhenti" >> "$LOG"

}

# ==========================================
# Program Utama
# ==========================================

echo "=========================================" >> "$LOG"
echo "$(date '+%F %T') | Live Makkah V9.1 Started" >> "$LOG"

smart_volume
LAST_VOLUME="$VOLUME"

while true
do

    wait_internet

    if ! get_stream
    then
        sleep 10
        continue
    fi

    smart_volume
    LAST_VOLUME="$VOLUME"

    play_stream

    watchdog

    RECONNECT=$((RECONNECT+1))
    echo "$(date '+%F %T') | Reconnect ke-$RECONNECT" >> "$LOG"

    dashboard
    echo
    echo "🔄 Reconnect dalam 5 detik..."

    sleep 5

done
