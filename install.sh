#!/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")

if [ -z "$1" ]
  then
    echo "No domain supplied"
    exit
fi

if [ -z "$2" ]
  then
    echo "No email supplied"
    exit
fi

if [ ! -f "./cloudflare.ini" ]; then
  echo -e "# Cloudflare API token used by Certbot\ndns_cloudflare_api_token = NONE" > cloudflare.ini
  chmod go-r cloudflare.ini
fi

if [ ! -f "./deploy-hook.sh" ]; then
  echo "No deploy-hook.sh found"
  cp ./deploy-hook.example.sh ./deploy-hook.sh
  exit
fi

if grep -q NONE "./cloudflare.ini"; then
  echo "Please fill in your Cloudflare API token in cloudflare.ini"
  exit
fi


echo "Get cert for $1 with email $2"

mkdir -p logs tmp conf

certbot certonly \
  --agree-tos --email $2 --non-interactive \
  --dns-cloudflare \
  --dns-cloudflare-credentials ./cloudflare.ini \
  --config-dir ./conf --work-dir ./tmp --logs-dir ./logs \
  --deploy-hook ./deploy-hook.sh \
  -d $1
