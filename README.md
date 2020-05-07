# apioak-docker
    docker run -d --add-cap NET_ADMIN -p 10080:10080 -e DB_HOST= -e DB_PORT= -e DB_NAME= -e DB_USER= -e DB_PASSWORD=  hyr326/docker-openvpn-manager:latest

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