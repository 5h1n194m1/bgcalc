# Panduan Operasional Singkat (Cheat Sheet)
**Battleground-Calc & Docusaurus**

Dokumen ini berisi rangkuman perintah terminal WSL2 paling penting untuk menjalankan, mengecek, dan mematikan seluruh lingkungan pengembangan tanpa ribet.

---

## 1. Menyalakan Seluruh Layanan (Start)
Buka terminal WSL2, lalu jalankan perintah berikut secara berurutan:

```bash
# A. Nyalakan Docker Container CodeIgniter 4 & MySQL
cd /root/project/htdocs && docker compose up -d

# B. Pastikan izin folder writable CI4 aman (mencegah Error 500/log)
docker exec -it ci4_app chmod -R 777 writable/

# C. Nyalakan Docusaurus di background (Port 3001)
cd /root/project/bgcalc-docs && nohup npm run start -- --port 3001 --host 0.0.0.0 > docusaurus.log 2>&1 &
```

* **Akses Aplikasi Utama:** [http://localhost:8088](http://localhost:8088)
* **Akses Dokumentasi:** [http://localhost:3001](http://localhost:3001)

---

## 2. Mematikan Seluruh Layanan (Stop & Clean)
Gunakan perintah ini saat selesai ngoding atau ketika port sering bermasalah/nyangkut:

```bash
# A. Matikan proses Docusaurus dan bebaskan port 3001 secara paksa
pkill -f "docusaurus start" || true
pkill -f "node.*3001" || true

# B. Matikan Container Docker CI4 & MySQL
cd /root/project/htdocs && docker compose down
```

---

## 3. Cek Status Kesehatan Layanan (Health Check)
Untuk memastikan apakah container dan port berjalan normal:

```bash
# Cek container Docker yang aktif
docker ps

# Cek apakah port 8088 (CI4) dan 3001 (Docusaurus) aktif terikat
ss -tulpn | grep -E ':8088|:3001'
```

---

## 4. Tips Mengatasi Masalah Umum
* **Port 3001 Docusaurus EADDRINUSE (Sudah Dipakai):**
  Jalankan perintah stop pada poin **2A**, lalu jalankan ulang perintah start pada poin **1C**.
* **Error 500 / Sesi Login Rusak di CI4:**
  Jalankan ulang perintah izin folder: `docker exec -it ci4_app chmod -R 777 writable/`.