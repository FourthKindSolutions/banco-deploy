# Open TCP/6443 for all
iptables -A INPUT -p tcp --dport 6443 -j ACCEPT

# Open TCP/6443 for one specific IP
iptables -A INPUT -p tcp -s your_ip_here --dport 6443 -j ACCEPT

# Open TCP/6443 for all
firewall-cmd --zone=public --add-port=6443/tcp --permanent
firewall-cmd --reload

# Open TCP/6443 for one specific IP
firewall-cmd --permanent --zone=public --add-rich-rule='
  rule family="ipv4"
  source address="your_ip_here/32"
  port protocol="tcp" port="6443" accept'
firewall-cmd --reload


  firewall-cmd --zone=public  --add-masquerade --permanent
  firewall-cmd --reload
  
  kubectl -n kube-system get pods -l job-name=rke-network-plugin-deploy-job --no-headers -o custom-columns=NAME:.metadata.name | xargs -L1 kubectl -n kube-system logs



  curl -LO https://dl.k8s.io/release/v1.22.2/bin/linux/amd64/kubectl
