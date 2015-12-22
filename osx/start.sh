#!/usr/bin/env bash

BASEDIR=$(dirname $0)

pip install -r $BASEDIR/OpenBazaar-Server/requirements.txt
python $BASEDIR/OpenBazaar-Server/openbazaard.py start --testnet &

cd $BASEDIR/OpenBazaar-Client
npm install
npm start

read -p "Press Return to Close..."