# AWS SES Postfix Relay ✉️

No-frills container that runs Postfix 3.3 using its new start-fg option that was specifically added for running inside containers. See the Postfix [release notes](http://www.postfix.org/announcements/postfix-3.3.0.html) 

The configuration is specifically intended to be used as a relay for AWS SES. The postfix config was derived from the [aws documentation](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/postfix.html).

The relay will use TLS/SSL connections to connect to AWS SES. This container is designed to run inside a trusted docker network. Configuring docker containers to use the smtp server `smtp` which no credentials or encryption requirements works for the vast majority of services out there. Please do not expose port 25 to the docker host unless you kow what you are doing.

## Usage:

    version: '3'

    services
      smtp:
        build: gardner/aws-ses-postfix-relay
        container_name: smtp
        restart: unless-stopped
        environment:
          - SMTP_HOST=email-smtp.us-east-1.amazonaws.com
          - SMTP_USERNAME=${SMTP_USERNAME}
          - SMTP_PASSWORD=${SMTP_PASSWORD}

## Credentials

To get a username and password visit the [SES console](https://eu-central-1.console.aws.amazon.com/ses/home) for you desired region. Go to _SMTP Settings_ and click on "Create My SMTP Credentials". Please keep them secret and do not check them into git. 👍