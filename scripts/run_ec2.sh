#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

sudo apt update -y

# AWS INSTALL

sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# PYENV INSTALL

# curl -fsSL https://pyenv.run | bash

# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
# echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
# echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc

# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
# echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
# echo 'eval "$(pyenv init - bash)"' >> ~/.profile

# NGINX INSTALL

sudo apt install nginx -y

# after setup and configuration

sudo service nginx restart

# GITHUB REPO CLONING

sudo apt install jq -y

cd /home/ubuntu

sudo -u ubuntu git clone https://${GITHUB_TOKEN}@github.com/AbbyAdj/ecommerce-app.git

# EXPORT .ENV VARIABLES

# TO BE IMPLEMENTED

cd ecommerce-app

touch .env
#
echo DB_PORT=${DB_PORT} >> .env
echo DB_USER=${DB_USERNAME} >> .env
echo DB_HOST=${DB_ENDPOINT} >> .env
echo DB_DATABASE=${DB_DATABASE} >> .env
echo DB_PASSWORD=${DB_PASSWORD} >> .env
echo FLASK_ENV=${FLASK_ENV} >> .env
echo S3_STATIC_BUCKET=${S3_STATIC_BUCKET} >> .env


# DATABASE SETUP

sudo apt install postgresql -y

#psql "host=${DB_ENDPOINT} port=${DB_PORT} dbname=${DB_DATABASE} user=${DB_USERNAME} password=${DB_PASSWORD} sslmode=require" -f /home/ubuntu/ecommerce-app/src/data/setup-database.sql


# GET SERVER UP AND RUNNING

# sudo apt instassh -i "dev-key.pem" ubuntu@3.8.211.124ll make

sudo apt install python3-venv -y
sudo apt install python3-pip -y

cd ecommerce-app

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt


# SETUP SYSTEM SERVICE

cat <<EOF > /etc/systemd/system/flask.service
[Unit]
Description=Flask App Served With Waitress
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/ecommerce-app
ExecStart=/home/ubuntu/ecommerce-app/venv/bin/python3 run.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable flask
sudo systemctl start flask

# nginx setup
#cat <<EOF > /etc/nginx/sites-available/flask
sudo tee /etc/nginx/sites-available/flask > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF


ln -s /etc/nginx/sites-available/flask /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl restart nginx



