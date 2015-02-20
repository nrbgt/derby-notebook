module.exports = class Login extends require "./apiCall"
  url: -> "#{@root()}/login"
  constructor: (callback) ->
    @request.post
      url: @url()
      form: password: process.env.IPYTHON_PASSWORD
      callback
