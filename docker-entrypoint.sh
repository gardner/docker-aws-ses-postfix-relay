#!/bin/bash

postconf -e "relayhost = [${SMTP_HOST}]:587" \
"smtp_sasl_auth_enable = yes" \
"smtp_sasl_security_options = noanonymous" \
"smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" \
"smtp_use_tls = yes" \
"smtp_tls_security_level = encrypt" \
"smtp_tls_note_starttls_offer = yes"

echo "[${SMTP_HOST}]:587 ${SMTP_USERNAME}:${SMTP_PASSWORD}" > /etc/postfix/sasl_passwd

postmap hash:/etc/postfix/sasl_passwd

## Allow for overriding every config
for e in ${!POSTFIX_*} ; do postconf -e "${e:8}=${!e}" ; done

rm -f /var/spool/postfix/pid/master.pid

exec "$@"
