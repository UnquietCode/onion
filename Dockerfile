FROM node:10.4.1-alpine

# add source code
RUN mkdir /app
ADD src/ /app/src
ADD package.json /app
ADD index.js /app

# install dependencies
RUN cd /app && npm install

# create a volume for template data
VOLUME /templates

# set the entrypoint to the onion application
WORKDIR /templates
ENTRYPOINT ["node", "/app/index.js"]