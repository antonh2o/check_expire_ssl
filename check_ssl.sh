#!/bin/bash

source .env

for i in $(cat ./domains.txt)
do
RETVAL=0
EXPIRE_DATE=`echo | openssl s_client -connect $i:443 -servername $i -tlsextdebug 2>/dev/null |\
 openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2`
EXPIRE_SECS=`date -d "${EXPIRE_DATE}" +%s`
EXPIRE_TIME=$(( ${EXPIRE_SECS} - `date +%s` ))
RETVAL=$(( ${EXPIRE_TIME} / 24 / 3600 ))
if [ $RETVAL -lt $num ]
then
     /usr/bin/curl -s -X POST $URL -d chat_id=${chatid} -d parse_mode=HTML -d text="Внимание сертификат на $i истекает через $RETVAL дн."
fi

done
