FROM alpine:edge

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories  

# build/code
RUN apk add --no-cache build-base git go bash bash-completion ncurses vim tmux jq

# network
RUN apk add --no-cache bind-tools iputils tcptraceroute busybox-extras tcpdump curl wget nmap tcpflow iftop net-tools mtr netcat-openbsd bridge-utils iperf ngrep

# certificates
RUN apk add --no-cache ca-certificates openssl

# processes/io
RUN apk add --no-cache htop atop strace iotop sysstat ltrace ncdu logrotate hdparm pciutils psmisc tree pv

CMD [ "bash" ]