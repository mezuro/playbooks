# NOTICE: This is intended to be an base for Vagrant

FROM ubuntu:16.04

# Update the system
RUN apt-get update && apt-get upgrade -y

# Systemd, from: https://github.com/dockerimages/docker-systemd/blob/master/15.10/Dockerfile
RUN apt-get update && apt-get install systemd && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; \
rm -f /lib/systemd/system/plymouth*; \
rm -f /lib/systemd/system/systemd-update-utmp*;
RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd
VOLUME [ "/sys/fs/cgroup" ]

RUN apt-get update && apt-get install -y openssh-server
#RUN mkdir /var/run/sshd
RUN echo 'root:mezuro' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Set sudo
RUN apt-get update && apt-get -y install sudo

# Set mezuro user
RUN useradd -ms /bin/bash mezuro
RUN echo 'mezuro:mezuro' | chpasswd
RUN adduser mezuro sudo

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["systemd.unit=emergency.service"]
