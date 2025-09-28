FROM ubuntu:22.04

RUN apt update && apt upgrade -y && apt install -y \
    git \
    curl \
    wget \
    unzip \
    htop \
    tree \
    jq 

WORKDIR /first-devops-project

COPY . /first-devops-project

CMD [ "bash" ]
