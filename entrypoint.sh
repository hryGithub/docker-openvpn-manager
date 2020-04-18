#!/bin/bash

#config db
sed -i "s@HOST='localhost'@HOST='$DB_HOST'@g"   /etc/openvpn/scripts/config.sh  /var/www/localhost/htdocs/include/config.php
sed -i "s@PORT='3306'@PORT='$DB_PORT'@g"  /etc/openvpn/scripts/config.sh    /var/www/localhost/htdocs/include/config.php
sed -i "s@USER=''@USER='$DB_USER'@g"  /etc/openvpn/scripts/config.sh    /var/www/localhost/htdocs/include/config.php
sed -i "s@PASS=''@PASS='$DB_PASSWORD'@g"  /etc/openvpn/scripts/config.sh    /var/www/localhost/htdocs/include/config.php
sed -i "s@DB='openvpn-admin'@DB='$DB_NAME'@g" /etc/openvpn/scripts/config.sh    /var/www/localhost/htdocs/include/config.php


#config openvpn
sed -i "s@proto tcp@proto $OVPN_PROTO@g" /etc/openvpn/server.conf
sed -i "s@port 1194@port $OVPN_PORT@g" /etc/openvpn/server.conf


#config ovpn-client
if [ $OVPN_PROTO = udp ];then
    sed -i "s@port 1194@port $OVPN_PORT@g" /etc/openvpn/server.conf
fi
for file in $(find -name client.ovpn); do
    sed -i "s/remote xxx\.xxx\.xxx\.xxx 443/remote $OVPN_ADDR $OVPN_PORT/" $file
    echo "<ca>" >> $file
    cat "/etc/openvpn/ca.crt" >> $file
    echo "</ca>" >> $file
    echo "<tls-auth>" >> $file
    cat "/etc/openvpn/ta.key" >> $file
    echo "</tls-auth>" >> $file

  if [ $openvpn_proto = "udp" ]; then
    sed -i "s/proto tcp-client/proto udp/" $file
  fi
done
#iptables init
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi
iptables -t nat -A POSTROUTING -s 10.254.254.0/24 -o eth0 -j MASQUERADE


genconfig(){
    echo 1
}

init-pki(){
    cd $OPENVPN 
    easyrsa init-pki
    easyrsa build-ca nopass
    easyrsa gen-dh
    easyrsa build-server-full server nopass
    openvpn --genkey --secret $EASYRSA/pki/ta.key
    cp $EASYRSA/pki/{ca.crt,ta.key,issued/server.crt,private/server.key,dh.pem} "/etc/openvpn/"
}



#init-pki
if [ ! -f '/etc/openvpn/ca.crt'];then
    init_pki()
fi

httpd -DFOREGROUND
#/usr/sbin/openvpn --config /etc/openvpn/server.conf