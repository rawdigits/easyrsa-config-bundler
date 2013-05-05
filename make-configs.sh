#!/bin/sh

if [ $# -lt 1 ]
then
  /bin/echo "Need a key name!"
  exit
fi

PREFIX_NAME="${1}"
CONFIG_DIR="clients/${PREFIX_NAME}"

/bin/echo $CONFIG_FILE

mkdir -p clients/$PREFIX_NAME

#Make .ovpn file with embedded certs 
CONFIG_FILE="${CONFIG_DIR}/${PREFIX_NAME}.ovpn"

cp config-template.ovpn $CONFIG_FILE

/bin/echo -ne '<ca>\n' >> $CONFIG_FILE
cat ca.crt >> $CONFIG_FILE
/bin/echo -ne '</ca>\n' >> $CONFIG_FILE

/bin/echo -ne '<cert>\n' >> $CONFIG_FILE
cat ${PREFIX_NAME}.crt >> $CONFIG_FILE
/bin/echo -ne '</cert>\n' >> $CONFIG_FILE

/bin/echo -ne '<key>\n' >> $CONFIG_FILE
cat ${PREFIX_NAME}.key >> $CONFIG_FILE
/bin/echo -ne '</key>\n' >> $CONFIG_FILE


#Make tunnelblick config with multiple files in a dir
TBLK_DIR=$CONFIG_DIR/$PREFIX_NAME.tblk
mkdir -p $TBLK_DIR
cp config-template.ovpn $TBLK_DIR/config.ovpn
/bin/echo -ne "ca ca.crt\ncert ${PREFIX_NAME}.crt\nkey ${PREFIX_NAME}.key\n" >> $TBLK_DIR/config.ovpn
cp ca.crt $TBLK_DIR/
cp ${PREFIX_NAME}.crt $TBLK_DIR/
cp ${PREFIX_NAME}.key $TBLK_DIR/

#Move everything to the client config dir to clean house
#mv $PREFIX_NAME.* clients/$PREFIX_NAME
