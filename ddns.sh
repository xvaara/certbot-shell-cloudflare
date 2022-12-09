#!/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")

if [ -z "$1" ]
  then
    # try to get the current IP from the system
    current_ip=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | head -1 | awk '{ print $2 }')
  else
    current_ip=$1
fi

echo "Current IP is $current_ip"

# A bash script to update a Cloudflare DNS A record with the external IP of the source machine
# Used to provide DDNS service from anywhere
# DNS redord needs to be pre-created on Cloudflare

for d in ./conf/live/*/ ; do
  # # Cloudflare zone is the zone which holds the record
  zone=$(basename "$d" | awk -F. '{print $(NF-1) "." $NF}')
  # # dnsrecord is the A record which will be updated
  dnsrecord=$(basename "$d")

  echo "Updating $dnsrecord in $zone"

  ## Cloudflare authentication details
  cloudflare_auth_key=$(grep "api_token" cloudflare.ini |cut -d ' ' -f3)

  if [[ $(host $dnsrecord 1.1.1.1 | grep "has address" | grep "$current_ip") ]]; then
    echo "$dnsrecord is currently set to $current_ip; no changes needed"
    exit
  fi

  cloudflare_zone_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
    -H "Authorization: Bearer $cloudflare_auth_key" \
    -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

  cloudflare_dnsrecord=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$cloudflare_zone_id/dns_records?type=A&name=$dnsrecord" \
    -H "Authorization: Bearer $cloudflare_auth_key" \
    -H "Content-Type: application/json")

  echo $cloudflare_dnsrecord

  cloudflare_dnsrecord_ip=$(echo $cloudflare_dnsrecord|jq -r '{"result"}[] | .[0] | .content')
  echo -e "X${cloudflare_dnsrecord_ip}X"

  if [[ "$cloudflare_dnsrecord_ip" == "null" ]]; then
    echo "DNS record not found, inserting"
    curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$cloudflare_zone_id/dns_records" \
      -H "Authorization: Bearer $cloudflare_auth_key" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$current_ip\",\"ttl\":1,\"proxied\":false}" | jq
    exit
  fi

  if [[ "$current_ip" == "$cloudflare_dnsrecord_ip" ]];then
    echo "DNS record is up to date"
    exit
  else
    cloudflare_dnsrecord_id=$(echo $cloudflare_dnsrecord| jq -r '{"result"}[] | .[0] | .id')
    # update the record
    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$cloudflare_zone_id/dns_records/$cloudflare_dnsrecord_id" \
      -H "Authorization: Bearer $cloudflare_auth_key" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$current_ip\",\"ttl\":1,\"proxied\":false}" | jq
  fi

done