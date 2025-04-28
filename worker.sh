#!/bin/bash

# Meminta input jumlah service dari pengguna
echo "Masukkan jumlah service (maksimal 50):"
read TOTAL_SERVICES

# Validasi input (jika lebih dari 50 atau bukan angka)
while ! [[ "$TOTAL_SERVICES" =~ ^[0-9]+$ ]] || [ "$TOTAL_SERVICES" -gt 50 ]; do
  echo "Jumlah service harus angka dan tidak lebih dari 50. Coba lagi:"
  read TOTAL_SERVICES
done

# Meminta input untuk KUZCO_WORKER dan KUZCO_CODE
echo "Masukkan KUZCO_WORKER:"
read KUZCO_WORKER
echo "Masukkan KUZCO_CODE:"
read KUZCO_CODE

# Buat docker-compose.yml baru
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
  echo "      KUZCO_WORKER: '$KUZCO_WORKER'" >> docker-compose.yml
  echo "      KUZCO_CODE: '$KUZCO_CODE'" >> docker-compose.yml
  echo "      CACHE_DIRECTORY: '/app/cache'" >> docker-compose.yml
  echo "" >> docker-compose.yml
done

# Tambahkan network di akhir file
echo "networks:" >> docker-compose.yml
echo "  kuzco-network:" >> docker-compose.yml
echo "    driver: bridge" >> docker-compose.yml

# Jalankan docker-compose
docker-compose up -d --build

echo "Docker Compose dengan $TOTAL_SERVICES service telah dijalankan!"
