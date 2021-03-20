#!/bin/bash
set -e

if [ -z "$RELAY_NETS" ]
then
  RELAY_NETS="$(ip addr show | awk '$1 == "inet" { print $2 ":" }' | xargs | sed 's/ //g')"
fi

opts=(
	dc_local_interfaces '0.0.0.0 ; ::0'
	dc_other_hostnames ''
	dc_relay_nets "${RELAY_NETS}"
	dc_eximconfig_configtype 'satellite'
	dc_readhost 'island.byu.edu'
	dc_smarthost 'mmgateway.byu.edu'
	dc_use_split_config 'true'
	dc_hide_mailname 'true'
)

if [ "$GMAIL_USER" -a "$GMAIL_PASSWORD" ]; then
	# see https://wiki.debian.org/GmailAndExim4
	opts+=(
		dc_eximconfig_configtype 'smarthost'
		dc_smarthost 'smtp.gmail.com::587'
	)
	echo "*.gmail.com:$GMAIL_USER:$GMAIL_PASSWORD" > /etc/exim4/passwd.client
else
	opts+=(
		dc_eximconfig_configtype 'internet'
	)
fi

/etc/exim4/set-exim4-update-conf "${opts[@]}"

if [ "$(id -u)" = '0' ]; then
	mkdir -p /var/spool/exim4 /var/log/exim4 || :
	chown -R Debian-exim:Debian-exim /var/spool/exim4 /var/log/exim4 || :
fi

exec "$@"
