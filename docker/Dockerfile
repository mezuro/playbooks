# NOTICE: This is intended to be an base for Vagrant

FROM ubuntu:16.04

# Update the system
RUN apt-get update && apt-get upgrade -y

RUN apt-get update && apt-get install -y dbus
ENV container=docker
RUN mkdir -p /etc/systemd/system-preset
COPY 50-docker.preset 99-disable-all.preset /etc/systemd/system-preset/
RUN systemctl mask ondemand systemd-modules-load systemd-sysctl
RUN systemctl preset-all
RUN systemctl set-default multi-user.target
    
RUN apt-get update && apt-get install -y openssh-server
RUN echo 'root:mezuro' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Set sudo
RUN apt-get update && apt-get -y install sudo

# Set mezuro user
RUN useradd -ms /bin/bash mezuro
RUN echo 'mezuro:mezuro' | chpasswd
RUN adduser mezuro sudo

# Install dependencies in order to get ansible working
RUN apt-get update && apt-get -y install iproute2 iputils-ping python

EXPOSE 22

ENTRYPOINT ["/lib/systemd/systemd"]
