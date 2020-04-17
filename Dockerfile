FROM alpine:3.6

RUN echo -e "http://mirrors.aliyun.com/alpine/v3.6/main\nhttp://mirrors.aliyun.com/alpine/v3.6/community" > /etc/apk/repositories && \
    apk add --no-cache apache2 openvpn iptables bash easy-rsa php5 php5-zip php5-apache2 php5-json php5-pdo_mysql mysql-client && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && ln -s /usr/bin/php5 /usr/bin/php && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* /var/www/localhost/htdocs/*

RUN mkdir -p /etc/openvpn/ccd && mkdir /run/apache2 -p && chmod 777 -R /run


ADD ./openvpn-admin /var/www/localhost/htdocs
RUN  mv /var/www/localhost/htdocs/include/scripts /etc/openvpn/ && chmod +x /etc/openvpn/*.sh 
#openvpn env
ENV OVPN_ADDR=0.0.0.0 \ 
    OVPN_PORT=1194 \    
    OVPN_PRO=udp

#db
ENV DB_HOST=127.0.0.1 \
    DB_PORT=3306 \
    DB_NAME=openvpn \
    DB_USER=openvpn \
    DB_PASSWORD=openvpn \



#rsa



EXPOSE 1194/udp 80

ADD entrypoint.sh /entrypoint.sh 

ENTRYPOINT ["bash", "/entrypoint.sh"]