#!/bin/bash

echo "install nginx.."
sudo apt install -y nginx

echo "create nginx.conf.."
sudo sh -c 'cat > /etc/nginx/sites-available/django <<EOF
server {
    listen 80;
    server_name 175.45.201.136;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF'

echo "create symlink.."
sudo ln -s /etc/nginx/sites-available/django /etc/nginx/sites-enabled/django

echo "restart nginx.."
sudo systemctl restart nginx
