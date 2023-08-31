#!/bin/bash

# 1. pull DB image
docker pull postgres:13
# 2. create .env file
cat > .env <<EOF
POSTGRES_DB=lionforum
POSTGRES_USER=lion
POSTGRES_PASSWORD=lion1234
EOF
# 3. run DB image
docker run -d -p 5432:5432 \
    --name db \
    -v postgres_data:/var/lib/postgresql/data \
    --env-file .env \
    postgres:13