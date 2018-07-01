# 5 steps for a Private NPM registry with Docker, Verdaccio and Let's Encrypt SSL

Make sure you have a domain(or subdomain) and SSH access to an instance. This works well under a DigitalOcean's Ubuntu with Docker and Docker Compose installed.

## Steps
1. Set in `docker-compose.yml` and `ssl_gen.sh` the **DOMAIN=my.registry.com** on the Nginx args.
2. Delete all **DELETE_ME.yml** files in `certs`, `certs-data`, `verdaccio/storage` (keep folders).
3. `docker-compose up -d`
4. `chmod +x *.sh && ./ssl_gen.sh`  
5. After it succeeds, start it with `docker-compose restart`

You should be able to access the registry via https://...

# htpasswd for adding users to registry
Verdaccio uses htpasswd for user management
1. http://www.htaccesstools.com/htpasswd-generator/
2. copy the output to the file `./verdaccio/conf/htpasswd`
3. npm login --registry http://my.registry.com

# Automatic cron setup ssl renewal

This will schedule a renewal of the SSL cert with Let's Encrypt every 15 days.
1. `crontab -u $USER -e`
2. `0 0 */15 * *  /path/to/registry_files/ssl_renew.sh`

# Gotchas
- is there a DNS **A** record pointing to the server?
- are you using registry.com? (use your own)
- if let's encrypt fails (dns or whatever, try deleting all certs files and try again.
- if you need a token see https://docs.npmjs.com/getting-started/working_with_tokens

## Need to install Docker in your VPS machine?
https://docs.docker.com/install/linux/docker-ce/ubuntu/

https://docs.docker.com/compose/install/

### Be sure to donate to **letsencrypt.org**!
