#!/bin/bash

echo "🚀 Setup Node Kuzco Tanpa GPU - Auto Script"

# 1. Minta input dari user
read -p "Masukkan API Key ViKey kamu: " vikey_api_key
read -p "Masukkan KUZCO_WORKER dari dashboard Kuzco: " kuzco_worker
read -p "Masukkan KUZCO_CODE dari dashboard Kuzco: " kuzco_code
read -p "Masukkan IP VPS kamu: " vps_ip

# 2. Install Docker dan Docker Compose
echo "🛠️ Menginstall Docker..."
sudo apt update && sudo apt install -y docker.io docker-compose

sudo systemctl start docker
sudo systemctl enable docker

# 3. Clone repo ViKey Inference
echo "🔽 Clone ViKey Inference..."
git clone https://github.com/direkturcrypto/vikey-inference
cd vikey-inference

# 4. Buat file .env
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
sed -i "s/YOUR_WORKER_ID/$kuzco_worker/" docker-compose.yml
sed -i "s/YOUR_WORKER_CODE/$kuzco_code/" docker-compose.yml

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
