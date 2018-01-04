# configurable exim4
#
# Version 0.0.2
#
# Based on tianon/exim4
#

FROM phusion/baseimage:latest
MAINTAINER gameldar@gmail.com

# Update distribution
RUN apt-get update -qq && \
    apt-get install -y exim4-daemon-light supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN mkdir -p /etc/my_init.d && mkdir -p /etc/service/exim4

COPY set-exim4-update-conf /etc/exim4/
RUN chmod 755 /etc/exim4/set-exim4-update-conf
COPY run /etc/service/exim4/
RUN chmod 755 /etc/service/exim4/run
COPY supervisord.conf /etc/
RUN chmod 700 /etc/supervisord.conf

EXPOSE 25

CMD ["/sbin/my_init"]
