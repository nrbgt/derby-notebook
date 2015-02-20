loadSession = require "../api/loadSession"
SessionSocket = require "../ws"

module.exports = ->
  @store.hook "change", "notebooks.*.session", (id, session) =>
    return if session
    console.log "OTD change session (#{session}) of #{id}"

    model = @store.createModel()
    notebook = model.at "notebooks.#{id}"

    model.fetch notebook, =>
      new loadSession
        notebook: notebook.get "name"
        (err, session) =>
          return console.error "OTD failed to fetch session #{id}", err if err
          notebook.set "session", session, =>
            console.log "OTD set session of #{id}"
            @sockets[session.id] = new SessionSocket session,
              "notebooks.#{id}"
              @store
              @secret
