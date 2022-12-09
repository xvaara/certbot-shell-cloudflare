#!/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")

if [ -t 1 ] ; then 
  echo "interacive mode";
  certbot renew \
    --config-dir ./conf --work-dir ./tmp --logs-dir ./logs
else
  # Sleep for a random amount of time because we're nice to letsencrypt
  sleep $[($RANDOM % 120)+1]
  certbot renew -q \
    --config-dir ./conf --work-dir ./tmp --logs-dir ./logs
fi

