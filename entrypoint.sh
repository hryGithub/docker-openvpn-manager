#!/bin/bash


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