#!/bin/sh

#made with love

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

rm /opt/zimbra/ssl/zimbra/commercial/commercial.key

rm /tmp/ISRG-X1.pem

rm -r /opt/zimbra/ssl/letsencrypt/
