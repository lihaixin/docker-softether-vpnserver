##RUN

	touch /etc/vpn_server.config
	docker volume create --name softether-logs
	docker run -d -v /etc/vpnserver/vpn_server.config:/usr/vpnserver/vpn_server.config  \
	-v softether-logs:/var/log/vpnserver \
	-p 443:443 --cap-add NET_ADMIN \
        --name softether lihaixin/softether
	
	
	touch /etc/vpn_server.config
	docker volume create --name softether-logs
	docker run -d --restart=always \
	-v softether-logs:/var/log/vpnserver \
	-p 443:443 --cap-add NET_ADMIN \
        --name softether lihaixin/softether
