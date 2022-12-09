#!/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")
certbot renew \
  --config-dir ./conf --work-dir ./tmp --logs-dir ./logs
