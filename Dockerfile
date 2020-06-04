FROM alpine:3.6

RUN echo -e "http://mirrors.aliyun.com/alpine/v3.6/main\nhttp://mirrors.aliyun.com/alpine/v3.6/community" > /etc/apk/repositories && \
    apk add --no-cache expect apache2 openvpn iptables bash easy-rsa php5 php5-zip php5-apache2 php5-json php5-pdo_sqlite sqlite && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && ln -s /usr/bin/php5 /usr/bin/php && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* /var/www/localhost/htdocs/*

RUN mkdir -p /etc/openvpn/ccd && mkdir /run/apache2 -p && chmod 777 -R /run

ENV EASYRSA=/usr/share/easy-rsa
ENV WEBDIR=/var/www/localhost/htdocs
ENV LAN=EN

ADD ./openvpn-manager /var/www/localhost/htdocs
RUN  mv $WEBDIR/installation/scripts /etc/openvpn/ && chmod +x /etc/openvpn/scripts/*.sh 

#openvpn env
ENV OVPN_ADDR=0.0.0.0 \ 
    OVPN_PORT=1194 \    
    OVPN_PROTO=udp

#db
ENV DB_FILE=/data/ovpn.sqlite3


EXPOSE 1194/udp 80

ADD entrypoint.sh /entrypoint.sh 

VOLUME ["/var/www/localhost/htdocs", "/etc/openvpn/", "/data"]

ENTRYPOINT ["bash", "/entrypoint.sh"]