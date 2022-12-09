#!/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")
certbot --config-dir ./conf --work-dir ./tmp --logs-dir ./logs $@