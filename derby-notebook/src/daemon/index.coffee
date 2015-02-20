derbyHook = require "derby-hook"

hooks = require "./hooks"

Login = require "./api/login"

module.exports = (store)->
  daemon =
    store: store
    sockets: {}
    secret: null
    init: ->
      derbyHook @store

      login = new Login (err, response, body) =>
        return console.error "OTD connection error", err if err
        console.info "OTD connected to IPython", response.statusCode
        @secret = response.headers["set-cookie"]
        daemon.listen()

    listen: ->
      for hookName, hook of hooks
        console.info "OTD listening for #{hookName} ..."
        hook.call @
      console.info "OTD ready ..."
