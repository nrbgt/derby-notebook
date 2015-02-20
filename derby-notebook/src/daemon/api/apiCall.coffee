request = require "request"
  .defaults
    jar: true # ensures that we get persistent cookies

module.exports = class ApiCall
  request: request
  origin: "#{process.env.IPYTHON_HOST}:#{process.env.IPYTHON_PORT}"
  root: -> "http://#{@origin}"
