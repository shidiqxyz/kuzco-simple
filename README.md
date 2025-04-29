# 🛠️ Setup Node Kuzco Tanpa GPU - Auto Script

**Tutorial untuk menjalankan Node Kuzco di VPS RAM 2GB tanpa GPU.**  
Dengan ViKey inference, kamu bisa proses task seperti menggunakan GPU dengan biaya lebih hemat.

## Baca Tulisan ini agar paham cara kerja dan apa saja yang diperlukan
[Tutorial Menjalankan Node Kuzco Tanpa GPU (Bisa di RAM 2GB Aja!)](https://paragraph.com/@a31/%F0%9F%94%B0-tutorial-menjalankan-node-kuzco-tanpa-gpu-bisa-di-ram-2gb-aja)

## ⚙️ Prasyarat

- VPS (Contabo, Vultr, DigitalOcean, dll)
- OS: Ubuntu 20.04 / 22.04
- Koneksi internet stabil
- Akun di [**ViKey.ai**](https://vikey.ai/) dan [**Kuzco**](https://inference.supply/)

## 🛠️ Langkah-langkah

1. **Login ke VPS** melalui SSH. 
   Dan tambahan jika vps mu kentang swap ram, ini dengan 1:1 ram system.
   ```
   sudo fallocate -l $(grep MemTotal /proc/meminfo | awk '{print int($2/1024)"M"}') /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
   ```
   
3. **Download dan Setup Script**:

   ```bash
   curl -O https://raw.githubusercontent.com/shidiqxyz/kuzco-simple/refs/heads/main/install.sh
   chmod +x install.sh
   ./install.sh
   ```

4. **Isi Input** saat diminta:
   API Key ViKey (Dapat ditemukan di dashboard ViKey).
   
   KUZCO_WORKER (Dapat ditemukan di dashboard Kuzco).
   
   KUZCO_CODE (Dapat ditemukan di dashboard Kuzco).
   
   IP VPS (Alamat IP VPS Anda).
   
   Jumlah Service (Maksimal 50). Script ini akan mengonfigurasi hingga 50 service Kuzco secara otomatis.

5. **Restart Docker**
   Jika belum muncul instance, coba restart docker :

   ```
   docker restart $(docker ps -q)
   ```

6. **Delete Container**
   ```
   docker rm -f $(docker ps -aq)
   ```
   
7. **Cek Log**:

   Untuk log ViKey:

   ```bash
   tail -f ~/vikey-inference/vikey.log
   ```

   Untuk log Kuzco:

   ```bash 
   cd ~/kuzco-installer-docker/kuzco-main && docker-compose logs -f --tail 100
   ```

## 💡 Referensi

Terinspirasi dari tutorial [A31](https://paragraph.com/@a31/%F0%9F%94%B0-tutorial-menjalankan-node-kuzco-tanpa-gpu-bisa-di-ram-2gb-aja).
