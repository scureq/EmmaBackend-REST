FROM node:7.0.0-slim

# Testing:
# docker build . -t emma
# Run: docker run -i -v /Users/steffo/CodeWarrior/NodeJS/emma-backend-REST/datadb:/data/db--name emma -t emma /bin/bash

# docker run -i  -v /Users/steffo/CodeWarrior/NodeJS/emma-backend-REST/datadb:/data/db -p 4001:4001  --name emma  emma 
# Try:  curl -d '{ "A2" : 201 }' -H "Content-Type: application/json" http://localhost:4001/api/v1/test

RUN apt-get update \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
  && echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
  && apt-get update \
  && apt-get install -y mongodb-org supervisor

RUN mkdir -p  /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /opt/emma
# This should be pulled from github but we have hardcoded API keys

COPY package.json /opt/emma/package.json

WORKDIR /opt/emma
RUN npm install

COPY app.js /opt/emma/app.js

EXPOSE  4001

# CMD [ "npm", "start" ]
cmd     ["/usr/bin/supervisord", "-n"]
