console.info "notebook proxy starting ..."

env = require "./env"
  .setup()

daemon = require "../daemon"

app = require "../app"
require "./starter"
  .run app,
    port: env.HTTP_PORT
    setupCallback: (err, expressApp) ->
      require("./proxy") expressApp
    storeCallback: (store) ->
      daemon store
        .init()
    listenCallback: (err) ->
      if err
        console.error err
      else
        console.info "... notebok proxy listening..."
