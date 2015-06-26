Exim4 Docker Container
======================

A Exim 4 satellite installation.

This is based upon [tianon/exim4](https://github.com/tianon/dockerfiles/tree/master/exim4) docker container - primarily to provide a simple way to configure a Gmail based installation. It performs configuration at startup and uses supervisor to run exim4 and should shutdown correctly.

## How to Use

# Gmail

To run use the environment variables to configure the Gmail account:

  docker run -d --name exim4 -e GMAIL_USER=youruser@yourdomain.com -e GMAIL_PASSWORD=yourpasswordhere gameldar/exim4


# Linking to another container

This can then be linked to another contain to be used as the SMTP host, e.g. for use with gameldar/bugzilla container you'd use:

  docker run -d --name bugzilla --link exim4:mail -p 8080:80 gameldar/bugzilla

Then the exim4 relay via Gmail could then be used by setting the mail configure to use SMTP with a smtp host of 'mail'
