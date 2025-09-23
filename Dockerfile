FROM docker.io/kalilinux/kali-rolling:latest

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get full-upgrade -y -qq
RUN apt-get install -y apt-utils bash bash-completion byobu chromium coreutils curl file git golang jq masscan nano nmap python3-dev python3-pip python3-setuptools python3-virtualenv python3-xyzservices sudo unzip vim virtualenv wget
RUN apt-get autoremove -y
RUN virtualenv /usr/local/

ENV PATH=$PATH:/root/osmedeus-base/binaries
WORKDIR /root/

RUN wget -qO - https://raw.githubusercontent.com/osmedeus/osmedeus-base/refs/heads/main/install.sh | bash -

ADD https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 /bin/ttyd
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /sbin/tini
RUN chmod 755 /bin/ttyd /sbin/tini

LABEL org.label-schema.name="Osmedeus - X Linux" \
      org.opencontainers.image.title="Osmedeus - X Linux" \
      org.opencontainers.image.description="Automated pentest framework for offensive security experts"

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "-W", "-O", "login", "-f", "root", "bash"]
