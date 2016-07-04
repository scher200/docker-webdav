# Usage
This is an NGINX WebDAV docker with some basic WebDAV functionality. Its main purpose is in end-to-end test environments to upload files.

Via two environment variables basic authentication can be set:

	WEBDAV_USERNAME
	WEBDAV_PASSWORD

If either environment variable is missing, basic authentication is removed.

Basic usage:

	docker run -d --name webdav -p 80:80 -v "$PWD":/var/www visity/webdav
	

Can be used with:

jwilder/nginx-proxy and ssl-compagnion, see here the docker-compose.yml file:

```
nginx-proxy:
  image: jwilder/nginx-proxy
  restart: always
  ports:
    - 80:80
    - 443:443
  volumes:
    - ./nginx/certs:/etc/nginx/certs:ro
    - ./nginx/vhost.d:/etc/nginx/vhost.d # only for special cases
    - ./nginx/html:/usr/share/nginx/html
    - /var/run/docker.sock:/tmp/docker.sock:ro
  container_name: nginxproxy

ssl-compagnion:
  image: jrcs/letsencrypt-nginx-proxy-companion
  restart: always
  volumes:
    - ./nginx/certs:/etc/nginx/certs:rw
    - /var/run/docker.sock:/var/run/docker.sock:ro
  volumes_from:
    - nginx-proxy
  container_name: sslcompagnion
```

and here the docker-compose.yml for one of you projects:

```
webdav:
  image: scher200/webdav
  expose:
    - "80"
  restart: always
  environment:
    VIRTUAL_HOST: webdav.yourdomain.nl
    VIRTUAL_PORT: 80
    LETSENCRYPT_HOST: webdav.yourdomain.nl
    LETSENCRYPT_EMAIL: you@yourmail.nl
    WEBDAV_USERNAME: youruser
    WEBDAV_PASSWORD: yourpassword
  volumes:
    - ./data:/var/www

```
