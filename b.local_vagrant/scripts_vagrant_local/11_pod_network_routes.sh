#!/usr/bin/env bash

vagrant ssh master -c '''
sudo ip route add 10.200.0.0/24 via 10.240.0.20
sudo ip route add 10.200.1.0/24 via 10.240.0.21

echo "
up route add -net 10.200.0.0/24 10.240.0.20
up route add -net 10.200.1.0/24 10.240.0.21
" | sudo tee --append /etc/network/interfaces

echo "
10.240.0.20 worker-0
10.240.0.21 worker-1
10.240.0.10 master
" | sudo tee --append /etc/hosts
'''

vagrant ssh worker-0 -c '''
sudo ip route add 10.200.1.0/24 via 10.240.0.21
echo "up route add -net 10.200.1.0/24 10.240.0.21" | sudo tee --append /etc/network/interfaces
echo "
10.240.0.20 worker-0
10.240.0.21 worker-1
10.240.0.10 master
" | sudo tee --append /etc/hosts
'''

vagrant ssh worker-1 -c '''
sudo ip route add 10.200.0.0/24 via 10.240.0.20
echo "up route add -net 10.200.0.0/24 10.240.0.20" | sudo tee --append /etc/network/interfaces
echo "
10.240.0.20 worker-0
10.240.0.21 worker-1
10.240.0.10 master
" | sudo tee --append /etc/hosts
'''
