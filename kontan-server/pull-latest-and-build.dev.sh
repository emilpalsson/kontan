#!/usr/bin/env bash

echo "Pulling latest from "$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')" branch"
git pull

npm install
npm run build:dev

# Generate start scripts
echo "export PATH="$(npm config get prefix)"/bin/node:$PATH" > startDev.sh
{ echo "cd "$(pwd)""; echo "sudo killall node"; echo "npm run serve:dev"; echo "ngrok http localhost:8080 --log=stdout > ngrok.dev.log &"; } >> startDev.sh
echo "sudo killall ngrok" > startDev.tunnel.sh
echo "ngrok http --config=$HOME/.config/ngrok/ngrok.yml localhost:8080 --log=stdout > /var/log/ngrok.dev.log &" >> startDev.tunnel.sh

sudo supervisorctl restart kontan-dev:*