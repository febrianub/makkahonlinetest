# 🕋 Live Masjidil Haram (Termux)

Streaming audio langsung dari YouTube Live Masjidil Haram menggunakan **yt-dlp** dan **mpv**.

## Fitur

- ✅ Auto Install Dependency
- ✅ Auto Reconnect
- ✅ Auto Refresh Player setiap 4 jam
- ✅ Smart Volume
- ✅ Auto Restart (09:00 & 15:00)
- ✅ Dashboard Monitoring
- ✅ Auto Hapus Log > 7 Hari

---

## Instalasi

Install Git:

```bash
pkg update -y
pkg install git -y
```

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
bash makkahv9.1.sh
```

Saat pertama kali dijalankan, script akan otomatis menginstal:

- Python
- Node.js
- MPV
- FFmpeg
- yt-dlp

Setelah instalasi selesai, audio akan langsung diputar.

---

## Menjalankan Kembali

```bash
cd makkahonlinetest
bash makkahv9.1.sh
```

---

## Update

```bash
cd makkahonlinetest
git pull
```

---
