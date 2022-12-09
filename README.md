# certbot-shell-cloudflare

one command to install let's encrypt certificate fwith dns-cloudflare

## Install

install certbot and certbot-dns-cloudflare

```sh
brew install certbot
pip3 install certbot-dns-cloudflare
```

create a token with Zone:DNS:Edit permissions in cloudflare for your domain: <https://dash.cloudflare.com/profile/api-tokens>
add token to cloudflare.ini
(see <https://certbot-dns-cloudflare.readthedocs.io/en/stable/> for more info)

modify deploy-hook.sh to fit your environment
and to install run

```sh
./install.sh subdomain.foobar.tld admin@foobar.tld
```

add renew.sh to crontab

```sh
crontab -l | {cat; echo "0 0 * * * /path/to/renew.sh"} |crontab -
```
