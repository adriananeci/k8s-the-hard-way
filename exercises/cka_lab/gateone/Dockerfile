FROM ubuntu

ENV GATEONE_REPO_URL https://github.com/liftoff/GateOne.git

# Ensure everything is up-to-date
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing && apt-get -y upgrade

# Install dependencies
RUN apt-get -y \
    install python-pip python-imaging python-setuptools python-mutagen python-pam python-dev \
    git wget curl vim openssh-client iputils-ping telnet nmap bash-completion \
    openssh-client && \
    apt-get -y clean all && \
    apt-get -q -y autoremove
RUN pip install --upgrade futures tornado cssmin slimit psutil

# Create the necessary directories, clone the repo, and install everything
RUN mkdir -p /gateone/logs && \
    mkdir -p /gateone/users && \
    mkdir -p /etc/gateone/conf.d && \
    mkdir -p /etc/gateone/ssl && \
    cd /gateone && \
    git clone $GATEONE_REPO_URL && \
    cd GateOne && \
    python setup.py install && \
    cp docker/update_and_run_gateone.py /usr/local/bin/update_and_run_gateone && \
    cp docker/60docker.conf /etc/gateone/conf.d/60docker.conf

# This ensures our configuration files/dirs are created:
RUN /usr/local/bin/gateone --configure \
    --log_file_prefix="/gateone/logs/gateone.log"

# Remove the auto-generated key/certificate so that a new one gets created the
# first time the container is started:
RUN rm -f /etc/gateone/ssl/key.pem && \
    rm -f /etc/gateone/ssl/certificate.pem
# (We don't want everyone using the same SSL key/certificate)

COPY conf.d/ /etc/gateone/conf.d/

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && ssh-keygen -N "" -t rsa -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys \
    && echo "source <(kubectl completion bash)" >> ~/.bashrc \
    && echo "alias k=kubectl" >> ~/.bashrc \
    && echo "complete -F __start_kubectl k" >> ~/.bashrc \
    && mkdir /root/.kube

EXPOSE 8000

CMD ["/usr/local/bin/update_and_run_gateone", "--log_file_prefix=/gateone/logs/gateone.log"]