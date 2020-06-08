FROM debian:buster-slim

# This container uses the new "postfix start-fg" command 
# that was developed specifically for container use
# @see http://www.postfix.org/announcements/postfix-3.3.0.html

# Preselections for installation
RUN echo smtp > /etc/hostname \
  && echo "postfix postfix/mailname string smtp.example.com" | debconf-set-selections \
  && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    postfix \
    libsasl2-modules \
    ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN postconf -e 'smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt' && \
    postconf -e 'syslog_name=smtp' && \
    postconf -e 'smtpd_use_tls=no' && \
    postconf -e 'maillog_file=/dev/stdout' && \
    postconf -e 'mynetworks=0.0.0.0/0'

COPY docker-entrypoint.sh /

EXPOSE 25

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postfix", "start-fg"]
