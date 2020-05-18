# start
##### It will take a while for normal use, because certificates needs to be generated when the first start
##### the default language is EN,you can change it by set the LAN value to CN
    docker run -d --name openvpn-manager --restart on-failture:5 --cap-add NET_ADMIN -p 80:80 -p 1194:1194/udp -e DB_HOST= -e DB_PORT= -e DB_NAME= -e DB_USER= -e DB_PASSWORD=  -e OVPN_ADDR=xxx.xxx.xxx.xxx hyr326/openvpn-manager:latest

# docker-compose
    git clone https://github.com/hryGithub/docker-openvpn-manager.git
    cd docker
    docker-compose up -d

# install web system
    visit http://${your-openvpn-manger-web-ip}:${your-openvpn-manger-web-port}/index.php?installation