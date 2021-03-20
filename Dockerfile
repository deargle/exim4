# configurable exim4
#
# Version 2.0.0
#
# Based on tianon/exim4
#

FROM docker.io/debian:latest
MAINTAINER gameldar@gmail.com

# Update distribution
RUN apt-get update -qq && \
    apt-get install -y exim4-daemon-light supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh


# DKIM
COPY 10_exim4-config_transport-macros-append /etc/exim4/
RUN cat /etc/exim4/10_exim4-config_transport-macros-append >> /etc/exim4/conf.d/transport/10_exim4-config_transport-macros

COPY 30_exim4-config_remote_smtp-append /etc/exim4/
RUN cat /etc/exim4/30_exim4-config_remote_smtp-append >> /etc/exim4/conf.d/transport/30_exim4-config_remote_smtp

RUN mkdir -p /etc/exim4/dkim/
COPY island.byu.edu-dkim-private.pem /etc/exim4/dkim/
RUN chown Debian-exim:Debian-exim /etc/exim4/dkim/island.byu.edu-dkim-private.pem
RUN chmod 400 /etc/exim4/dkim/island.byu.edu-dkim-private.pem


COPY set-exim4-update-conf /etc/exim4/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh /etc/exim4/set-exim4-update-conf

EXPOSE 25

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/exim", "-bd", "-v"]

EXPOSE 25
