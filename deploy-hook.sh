#!/bin/bash
DOMAINNAME=$(basename "$RENEWED_LINEAGE")

echo "done with $DOMAINNAME with domains $RENEWED_DOMAINS"
echo "cert is at $RENEWED_LINEAGE directory"


# Copy the cert to the nginx directory
#cp $RENEWED_LINEAGE/fullchain.pem /etc/nginx/ssl/fullchain.pem
#cp $RENEWED_LINEAGE/privkey.pem /etc/nginx/ssl/privkey.pem

# Restart nginx
#brew services restart nginx
#systemctl restart nginx

