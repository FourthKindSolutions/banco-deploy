systemctl stop docker.socket
iptables --flush
iptables -tnat --flush
systemctl start docker

