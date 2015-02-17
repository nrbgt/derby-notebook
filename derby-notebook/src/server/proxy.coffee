Proxy = require 'express-http-proxy'
url = require 'url'

env = process.env

module.exports = (expressApp) ->
  proxy = Proxy "#{env.IPYTHON_HOST}:#{env.IPYTHON_PORT}",
    forwardPath: (req, res) ->
      url.parse req.url
        .path
  expressApp.use proxy
