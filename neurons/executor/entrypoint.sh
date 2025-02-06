#!/bin/sh
set -eu

check_nvidia_driver() {
    if ! nvidia-smi > /dev/null 2>&1; then
        echo "NVIDIA driver not responding, restarting container..."
        docker compose restart executor
        sleep 10
    fi
}

docker compose up --pull always --detach --wait --force-recreate

# Clean docker images
docker image prune -f

while true
do
    # 每5分钟检查一次驱动状态
    check_nvidia_driver
    sleep 300
    docker compose logs -f
    echo 'All containers died'
    sleep 10
done