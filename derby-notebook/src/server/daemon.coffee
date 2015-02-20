hook = require "derby-hook"
tough = require "tough-cookie"
request = require "request"
  .defaults jar: true

util = require "./util"

env = process.env
IPYTHON = "http://#{env.IPYTHON_HOST}:#{env.IPYTHON_PORT}"

module.exports = (store)->
  daemon =
    init: ->
      hook store

      request.post
        url: "#{IPYTHON}/login"
        form: password: "Dont make this your default"
        (err, response, body) ->
          return console.error "... connection error", err if err
          console.info "... OT daemon connected to IPython"
          daemon.listen()

    listen: ->
      store.hook "create", "notebooks", daemon.notebookCreated
      console.info "... OT daemon waiting ..."

    notebookCreated: (id, notebook) ->
      console.log "HOOK", id, notebook
      model = store.createModel()
      model.fetch "notebooks.#{id}", ->
        console.log arguments
        request
          url: "#{IPYTHON}/api/contents/#{notebook.name}?type=notebook"
          headers: "Content-Type": "application/json"
          json: true
          (err, response, body) ->
            return console.error "... failed to fetch contents", err if err
            console.log "... daemon contents fetched", body
            model.set "notebooks.#{id}.content", body
