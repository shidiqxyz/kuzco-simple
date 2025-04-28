#!/bin/bash

echo "🚀 Setup Node Kuzco Tanpa GPU - Auto Script"

# 1. Minta input dari user
read -p "Masukkan API Key ViKey kamu: " vikey_api_key
read -p "Masukkan KUZCO_WORKER dari dashboard Kuzco: " kuzco_worker
read -p "Masukkan KUZCO_CODE dari dashboard Kuzco: " kuzco_code
read -p "Masukkan IP VPS kamu: " vps_ip

# Minta input jumlah service dari pengguna (maks 50)
echo "Masukkan jumlah service (maksimal 50):"
read TOTAL_SERVICES

# Validasi input jumlah service (jika lebih dari 50 atau bukan angka)
while ! [[ "$TOTAL_SERVICES" =~ ^[0-9]+$ ]] || [ "$TOTAL_SERVICES" -gt 50 ]; do
  echo "Jumlah service harus angka dan tidak lebih dari 50. Coba lagi:"
  read TOTAL_SERVICES
done

# 2. Install Docker dan Docker Compose
echo "🛠️ Menginstall Docker..."
sudo apt update && sudo apt install -y docker.io docker-compose

sudo systemctl start docker
sudo systemctl enable docker

# 3. Clone repo ViKey Inference
echo "🔽 Clone ViKey Inference..."
git clone https://github.com/direkturcrypto/vikey-inference
cd vikey-inference

# 4. Buat file .env untuk ViKey
echo "🔧 Membuat file .env untuk ViKey..."
cat > .env <<EOL
VIKEY_API_KEY=$vikey_api_key
NODE_PORT=14444
EOL

# 5. Jalankan ViKey Inference
echo "🚀 Menjalankan ViKey Inference di background..."
chmod +x vikey-inference-linux
nohup ./vikey-inference-linux > vikey.log &

# 6. Setup Kuzco Node
echo "🔽 Clone Kuzco Installer..."
cd ~
git clone https://github.com/direkturcrypto/kuzco-installer-docker
cd kuzco-installer-docker/kuzco-main

# 7. Update docker-compose.yml
echo "🔧 Update docker-compose.yml..."
echo "version: '3.8'" > docker-compose.yml
echo "services:" >> docker-compose.yml

# Generate service dalam docker-compose.yml
for i in $(seq 1 $TOTAL_SERVICES); do
  echo "  kuzco-main-$i:" >> docker-compose.yml
  echo "    build:" >> docker-compose.yml
  echo "      context: ." >> docker-compose.yml
  echo "    image: kuzco-main-image-$i" >> docker-compose.yml
  echo "    container_name: kuzco-main-$i" >> docker-compose.yml
  echo "    networks:" >> docker-compose.yml
  echo "      - kuzco-network" >> docker-compose.yml
  echo "    restart: always" >> docker-compose.yml
  echo "    environment:" >> docker-compose.yml
  echo "      NODE_ENV: 'production'" >> docker-compose.yml
  echo "      KUZCO_WORKER: '$kuzco_worker'" >> docker-compose.yml
  echo "      KUZCO_CODE: '$kuzco_code'" >> docker-compose.yml
  echo "      CACHE_DIRECTORY: '/app/cache'" >> docker-compose.yml
  echo "" >> docker-compose.yml
done

# Tambahkan network di akhir file
echo "networks:" >> docker-compose.yml
echo "  kuzco-network:" >> docker-compose.yml
echo "    driver: bridge" >> docker-compose.yml

# 8. Update nginx.conf
echo "🔧 Update nginx.conf..."
sed -i "s/YOUR_VPS_IP/$vps_ip/" nginx.conf

# 9. Build dan jalankan docker-compose
echo "🐳 Build dan Jalankan Node Kuzco..."
docker-compose up -d --build

echo "✅ Selesai! Node Kuzco kamu sudah berjalan!"
echo ""
echo "Tips Cek Log:"
echo "➡️  ViKey Inference Log: cd ~/vikey-inference && tail -f vikey.log"
echo "➡️  Kuzco Node Log: docker-compose logs -f --tail 100"
