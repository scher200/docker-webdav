# Do not use nginx as base since extras are not included.
FROM      debian:jessie

RUN       apt-get update && \
          apt-get install -y nginx nginx-extras apache2-utils wget && \
          rm -rf /var/lib/apt/lists/*

# Add dumb-init for smooth down and up 
RUN       wget https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64.deb
RUN       dpkg -i dumb-init_*.deb
    
COPY      set_htpasswd.sh /set_htpasswd.sh
COPY      webdav-site.conf /etc/nginx/sites-enabled/
RUN       rm /etc/nginx/sites-enabled/default
# Overwrite mimetypes to add rss format.
COPY      mime.types /etc/nginx/

# Forward request and error logs to docker log collector
RUN       ln -sf /dev/stdout /var/log/nginx/access.log
RUN       ln -sf /dev/stderr /var/log/nginx/error.log

# Create folder where webdav files end up.
RUN       mkdir -p /var/www/.temp
RUN       chown -R www-data:www-data /var/www
RUN       chmod -R a+rw /var/www

# show wich port to be used
EXPOSE 80

# Share the volume with the files to other dockers
VOLUME    /var/www

CMD       dumb-init sh -c '/set_htpasswd.sh && nginx -g "daemon off;"'
