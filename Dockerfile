# configurable exim4
#
# Version 1.0.0
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


# DKIM
COPY 10_exim4-config_transport-macros-append /etc/exim4/
RUN cat 10_exim4-config_transport-macros-append >> /etc/exim4/conf.d/transport/10_exim4-config_transport-macros

COPY 30_exim4-config_remote_smtp-append /etc/exim4/
RUN cat /etc/exim4/30_exim4-config_remote_smtp-append >> /etc/exim4/conf.d/transport/30_exim4-config_remote_smtp

RUN mkdir -p /etc/exim4/dkim/
COPY island.byu.edu-dkim-private.pem /etc/exim4/dkim/
RUN chown Debian-exim:Debian-exim /etc/exim4/dkim/island.byu.edu-dkim-private.pem
RUN chmod 400 /etc/exim4/dkim/island.byu.edu-dkim-private.pem


COPY set-exim4-update-conf /etc/exim4/
RUN chmod 755 /etc/exim4/set-exim4-update-conf

COPY run /etc/service/exim4/
RUN chmod 755 /etc/service/exim4/run

COPY supervisord.conf /etc/
RUN chmod 700 /etc/supervisord.conf

EXPOSE 25

CMD ["/sbin/my_init"]
