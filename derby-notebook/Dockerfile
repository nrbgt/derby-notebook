# specify base docker image
FROM dockerfile/nodejs

# npm install all the things
ADD ["README.md", "package.json", "/srv/derby-notebook/"]

WORKDIR /srv/derby-notebook
RUN npm install

ADD ./patches/patch-483.sh /srv/derby-notebook/
RUN ./patch-483.sh

# TODO: this is still weird... really don't ever want to see the built assets
VOLUME /srv/derby-notebook/src
VOLUME /srv/derby-notebook/public

EXPOSE 9999

# the command that gets run inside the docker container
CMD ["./node_modules/.bin/coffee"]
