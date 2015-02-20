module.exports = class LoadSession extends require "./apiCall"
  url: -> "#{@root()}/api/sessions/"
  constructor: ({notebook}, callback) ->
    @request
      url: @url()
      headers: "Content-Type": "application/json"
      json: true
      (err, resp, body) =>
        return callback err if err

        for session in body
          if session.notebook.path == notebook
            return callback null, session
