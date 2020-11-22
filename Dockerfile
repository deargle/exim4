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

COPY set-exim4-update-conf /etc/exim4/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh /etc/exim4/set-exim4-update-conf

EXPOSE 25

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/exim", "-bd", "-v"]

EXPOSE 25
