derby = require 'derby'

module.exports =
  run: (app, options={}) ->
    port = options.port or process.env.PORT or 3000

    listenCallback = (err) ->
      console.log '%d listening. Go to: http://localhost:%d/', process.pid, port
      options.listenCallback and options.listenCallback err

    createServer = ->
      if typeof app == 'string'
        app = require app

      require('./server').setup app,
        options,
        (err, expressApp, upgrade) ->
          throw err unless not err

          if options.setupCallback
            expressApp = options.setupCallback err, expressApp

          server = require 'http'
            .createServer expressApp

          server.on 'upgrade', upgrade
          server.listen port, listenCallback

    derby.run createServer
