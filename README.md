Exim4 Docker Container
======================

A Exim 4 satellite installation.

This is based upon [tianon/exim4](https://github.com/tianon/dockerfiles/tree/master/exim4) docker container - primarily to provide a simple way to configure a Gmail based installation. It performs configuration at startup and uses supervisor to run exim4 and should shutdown correctly.

## How to Use

place the dkim key in this folder, peek in the dockerfile to see what it should be named.

then,

	docker build --tag exim4:1.0 .
	docker run -d --name exim4 --restart always --network nginx-proxy exim4:1.0

# Linking to another container

This can then be linked to another contain to be used as the SMTP host, e.g. for use with gameldar/bugzilla container you'd use:

  docker run -d --name bugzilla --link exim4:mail -p 8080:80 gameldar/bugzilla

Then the exim4 relay via Gmail could then be used by setting the mail configure to use SMTP with a smtp host of 'mail'
