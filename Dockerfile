FROM alpine:3.12

RUN RUN sed -i "s@dl-cdn.alpinelinux.org@mirrors.aliyun.com@g" /etc/apk/repositories && \
    apk add --no-cache expect apache2 openvpn iptables bash easy-rsa openvpn-auth-ldap && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* /var/www/localhost/htdocs/*

RUN mkdir -p /etc/openvpn/ccd && mkdir /run/apache2 -p && chmod 777 -R /run

ENV EASYRSA=/usr/share/easy-rsa
ENV WEBDIR=/var/www/localhost/htdocs

RUN  mv $WEBDIR/installation/scripts /etc/openvpn/ && chmod +x /etc/openvpn/scripts/*.sh 

#openvpn env
ENV OVPN_ADDR=0.0.0.0 \ 
    OVPN_PORT=1194 \    
    OVPN_PROTO=udp


EXPOSE 1194/udp 80

ADD entrypoint.sh /entrypoint.sh 

VOLUME ["/var/www/localhost/htdocs", "/etc/openvpn/"]

ENTRYPOINT ["bash", "/entrypoint.sh"]