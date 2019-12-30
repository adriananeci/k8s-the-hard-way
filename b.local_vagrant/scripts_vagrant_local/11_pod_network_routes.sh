#!/usr/bin/env bash

vagrant ssh master -c '''
cat <<EOF | tee add_routes.sh >/dev/null
#!/bin/bash
sudo modprobe br_netfilter
# add containers subnets in route table
sudo ip route add 10.200.0.0/24 via 10.240.0.20
sudo ip route add 10.200.1.0/24 via 10.240.0.21
# add services IP subnet in route table
sudo ip route add 10.32.0.0/24 via 10.240.0.20
EOF

chmod +x add_routes.sh
./add_routes.sh

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo \"@reboot ~/add_routes.sh\" >> mycron
#install new cron file
crontab mycron
rm mycron

cat <<EOF | sudo tee --append /etc/hosts >/dev/null
10.240.0.20 worker-0
10.240.0.21 worker-1
10.240.0.10 master
EOF
'''

vagrant ssh worker-0 -c '''
cat <<EOF | tee add_routes.sh >/dev/null
#!/bin/bash
sudo modprobe br_netfilter
sudo ip route add 10.200.1.0/24 via 10.240.0.21
EOF

chmod +x add_routes.sh
./add_routes.sh

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo \"@reboot ~/add_routes.sh\" >> mycron
#install new cron file
crontab mycron
rm mycron

cat <<EOF | sudo tee --append /etc/hosts >/dev/null
10.240.0.20 worker-0
10.240.0.21 worker-1
10.240.0.10 master
EOF
'''

vagrant ssh worker-1 -c '''
cat <<EOF | tee add_routes.sh >/dev/null
#!/bin/bash
sudo modprobe br_netfilter
sudo ip route add 10.200.0.0/24 via 10.240.0.20
EOF

chmod +x add_routes.sh
./add_routes.sh

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo \"@reboot ~/add_routes.sh\" >> mycron
#install new cron file
crontab mycron
rm mycron

cat <<EOF | sudo tee --append /etc/hosts >/dev/null
10.240.0.20 worker-0
10.240.0.21 worker-1
10.240.0.10 master
EOF
'''
