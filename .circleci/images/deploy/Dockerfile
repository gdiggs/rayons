FROM ubuntu:16.04

RUN apt-get update -qq && \
    apt-get install -y curl python-pip jq && \
    pip install --upgrade pip && \
    pip install awscli --upgrade

RUN aws --version

RUN curl https://raw.githubusercontent.com/silinternational/ecs-deploy/develop/ecs-deploy > /bin/ecs-deploy && \
    chmod +x /bin/ecs-deploy

ENV DOCKER_VERSION="17.03.0-ce"

RUN curl -L -o /tmp/docker-$DOCKER_VERSION.tgz https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz && \
    tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION.tgz && \
    mv /tmp/docker/* /usr/bin
