# 🕋 Live Masjidil Haram - Termux

Streaming audio Live Masjidil Haram langsung dari YouTube menggunakan **yt-dlp** dan **MPV**.

## ✨ Fitur

- ▶️ Streaming Audio Live Masjidil Haram
- 🔄 Auto Reconnect
- ♻️ Auto Refresh Player setiap 4 Jam
- 🔊 Smart Volume
- 📊 Dashboard Monitoring
- 🗑️ Auto Hapus Log (>7 Hari)
- ⏱️ Menampilkan Uptime, RAM, Ping, Refresh Countdown

---

## 📦 Persyaratan

Install terlebih dahulu:

```bash
pkg update -y
pkg install -y git python nodejs mpv ffmpeg
python -m pip install -U yt-dlp
```

---

## 📥 Instalasi

Clone repository:

```bash
git clone https://github.com/febrianub/makkahonlinetest.git
```

Masuk ke folder:

```bash
cd makkahonlinetest
```

Jalankan:

```bash
bash makkah.sh
```

---

## 🔄 Update

```bash
cd ~/makkahonlinetest
git pull
```

---

## ▶ Menjalankan Kembali

```bash
cd ~/makkahonlinetest
bash makkah.sh
```

---

## ⚠️ Troubleshooting

### MPV tidak bisa dijalankan

Cek:

```bash
mpv --version
```

Jika muncul pesan seperti:

```
CANNOT LINK EXECUTABLE "mpv"
```

Perbarui paket:

```bash
pkg update
pkg upgrade
pkg reinstall mpv ffmpeg
```

---

### yt-dlp gagal mengambil URL

Perbarui yt-dlp:

```bash
python -m pip install -U yt-dlp
```

Tes:

```bash
yt-dlp --js-runtimes node -f 93 -g "https://www.youtube.com/live/wawzF8i5yAo"
```

Jika muncul URL panjang, berarti yt-dlp bekerja dengan baik.

---

## 📝 Catatan

- Gunakan Termux versi terbaru (F-Droid atau GitHub).
- Past
