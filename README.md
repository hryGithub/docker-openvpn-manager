# start
##### It will take a while for normal use, because certificates needs to be generated when the first start
##### the default language is EN,you can change it by set the LAN value to CN
    docker run -d --add-cap NET_ADMIN -p 10080:10080 -e DB_HOST= -e DB_PORT= -e DB_NAME= -e DB_USER= -e DB_PASSWORD=  -e LAN=CN hyr326/docker-openvpn-manager

# docker-compose
    git clone https://github.com/hryGithub/docker-openvpn-manager.git
    cd docker
    docker-compose up 

# build 
    git clone https://github.com/hryGithub/docker-openvpn-manager.git
    cd docker
    docker-compose -f docker-compose-build.yml up 


# install web system
    visit http://${your-openvpn-manger-ip}:${your-openvpn-manger-port}/index.php?installation