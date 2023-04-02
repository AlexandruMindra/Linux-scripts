#!/bin/sh

#made with love

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

read -p 'mail_server_url [xx.xx.xx]: ' mail_server_url

# Check All variable have a value
if [ -z $mail_server_url ]
then
   echo run script again please insert all value. do not miss any value
else

rm /opt/zimbra/ssl/zimbra/commercial/commercial.key

rm /tmp/ISRG-X1.pem

rm /opt/zimbra/ssl/letsencrypt/*

su - zimbra -c 'zmcontrol stop'

/etc/scripts/stop
certbot  renew --standalone --non-interactive --hsts --preferred-chain "ISRG Root X1" --key-type rsa
/etc/scripts/firewall

cp /etc/letsencrypt/live/$mail_server_url/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
chown zimbra:zimbra /opt/zimbra/ssl/zimbra/commercial/commercial.key
wget -O /tmp/ISRG-X1.pem https://letsencrypt.org/certs/isrgrootx1.pem.txt
cat /tmp/ISRG-X1.pem >> /etc/letsencrypt/live/$mail_server_url/chain.pem

#mkdir /opt/zimbra/ssl/letsencrypt
cp /etc/letsencrypt/live/$mail_server_url/*.pem /opt/zimbra/ssl/letsencrypt/
chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/
chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/* -R
su - zimbra -c 'zmcertmgr verifycrt comm /opt/zimbra/ssl/zimbra/commercial/commercial.key /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/chain.pem'
su - zimbra -c 'zmcertmgr deploycrt comm /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/chain.pem'
su - zimbra -c 'zmcontrol start'

fi
