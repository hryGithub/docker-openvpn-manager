# start
##### It will take a while for normal use, because certificates needs to be generated when the first start
##### the default language is EN,you can change it by set the LAN value to CN
    docker run -d --add-cap NET_ADMIN -p 80:80 -p 1194:1194/udp -v /data/:/data -e OVPN_ADDR=xxx.xxx.xxx.xxx hyr326/docker-openvpn-manager:sqlite


# install web system
    visit http://${your-openvpn-manger-web-ip}:${your-openvpn-manger-web-port}/index.php?installation