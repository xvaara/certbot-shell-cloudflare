# certbot-shell-cloudflare

one command to install let's encrypt certificate fwith dns-cloudflare

add token with Zone:DNS:Edit permissions to cloudflare.ini
(see https://certbot-dns-cloudflare.readthedocs.io/en/stable/ for more info)

modify deploy-hook.sh to fit your environment
and to install run

```bash
./install.sh subdomain.foobar.tld admin@foobar.tld
```

add renew.sh to crontab
