# 🕋 Live Masjidil Haram (Termux)

Streaming audio Live Masjidil Haram menggunakan **yt-dlp** dan **mpv**.

## ✨ Fitur

- ✅ Auto Install Dependency
- ✅ Auto Reconnect
- ✅ Auto Refresh Player (4 Jam)
- ✅ Smart Volume
- ✅ Auto Restart (09:00 & 15:00)
- ✅ Dashboard Monitoring
- ✅ Auto Hapus Log (>7 Hari)

---

## 📥 Instalasi

### 1. Install Git

```bash
pkg update -y
pkg install git -y
```

### 2. Clone Repository

```bash
git clone https://github.com/febrianub/makkahonlinetest.git
```

### 3. Masuk ke Folder

```bash
cd makkahonlinetest
```

### 4. Jalankan Script

```bash
bash makkah.sh
```

Saat pertama kali dijalankan, script akan otomatis menginstal:

- Python
- Node.js
- MPV
- FFmpeg
- yt-dlp

Setelah instalasi selesai, audio akan langsung diputar.

---

## ▶ Menjalankan Kembali

```bash
cd ~/makkahonlinetest
bash makkah.sh
```

---

## 🔄 Update

```bash
cd ~/makkahonlinetest
git pull
```

---
