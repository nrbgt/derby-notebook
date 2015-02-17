# specify base docker image
FROM dockerfile/nodejs

# npm install all the things
ADD README.md /srv/derby-notebook/
ADD package.json /srv/derby-notebook/
RUN cd /srv/derby-notebook && npm install

EXPOSE 9999

# TODO: this is still weird... really don't ever want to see the built assets
VOLUME /srv/derby-notebook/src
VOLUME /srv/derby-notebook/public

WORKDIR /srv/derby-notebook

# the command that gets run inside the docker container
CMD ["./node_modules/.bin/coffee", "./src/server/index.coffee"]
