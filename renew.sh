#!/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")

# Sleep for a random amount of time because we're nice to letsencrypt
sleep $[($RANDOM % 120)+1]

certbot renew \
  --config-dir ./conf --work-dir ./tmp --logs-dir ./logs
