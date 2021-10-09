#!/bin/bash

#config openvpn
if [ ! -f /etc/openvpn/server.conf ];then
    cp $WEBDIR/installation/server.conf /etc/openvpn/
    sed -i "s@proto tcp@proto $OVPN_PROTO@g" /etc/openvpn/server.conf
    sed -i "s@port 1194@port $OVPN_PORT@g" /etc/openvpn/server.conf
fi
if [ ! -d /etc/openvpn/scripts ];then
    cp -r $WEBDIR/installation/scripts /etc/openvpn/ 
    chmod +x /etc/openvpn/scripts/*.sh 
fi

if [ ! -d /etc/openvpn/ccd ];then
    mkdir -p /etc/openvpn/ccd
fi


#config mysql
sed -i "s@host='localhost'@host='$DB_HOST'@g"   /etc/openvpn/scripts/config.sh
sed -i "s@port=3306@port=$DB_PORT@g"  /etc/openvpn/scripts/config.sh
sed -i "s@user='root'@user='$DB_USER'@g"  /etc/openvpn/scripts/config.sh
sed -i "s@pass=''@pass='$DB_PASSWORD'@g"  /etc/openvpn/scripts/config.sh
sed -i "s@db='openvpn-admin'@db='$DB_NAME'@g" /etc/openvpn/scripts/config.sh


init-pki(){
    source $EASYRSA/vars.example
    easyrsa init-pki
    expect -c '
    	spawn easyrsa build-ca nopass
    	expect "*:"
    	send "\r"
	    expect eof
    '
    easyrsa gen-dh
    easyrsa build-server-full server nopass
    openvpn --genkey --secret $EASYRSA/pki/ta.key
    cp $EASYRSA/pki/{ca.crt,ta.key,issued/server.crt,private/server.key,dh.pem} "/etc/openvpn/"
}

#init-pki
if [ ! -f '/etc/openvpn/ca.crt' ];then
    init-pki
fi

#config ovpn-client
if [ $OVPN_PROTO = udp ];then
    sed -i "s@port 1194@port $OVPN_PORT@g" /etc/openvpn/server.conf
fi
if [ ! -d $WEBDIR/client-conf ];then
    cp -r $WEBDIR/installation/client-conf $WEBDIR/
    chown -R apache.apache $WEBDIR/client-conf
    for file in $(find $WEBDIR/client-conf -name client.ovpn); do
        sed -i "s/remote xxx\.xxx\.xxx\.xxx 443/remote $OVPN_ADDR $OVPN_PORT/" $file
        echo "<ca>" >> $file
        cat "/etc/openvpn/ca.crt" >> $file
        echo "</ca>" >> $file
        echo "<tls-auth>" >> $file
        cat "/etc/openvpn/ta.key" >> $file
        echo "</tls-auth>" >> $file

    if [ $OVPN_PROTO = udp ]; then
        sed -i "s/proto tcp-client/proto udp/g" $file
    fi
    done
fi
#iptables init
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi
iptables -t nat -A POSTROUTING -s 10.254.254.0/24 -o eth0 -j MASQUERADE

#language
if [ $LAN = CN ];then
    cp -r $WEBDIR/installation/zh_CN/*  $WEBDIR/
fi

/usr/sbin/openvpn --config /etc/openvpn/server.conf --daemon

httpd -D FOREGROUND