module.exports = ->
  @store.hook "change",
    "notebooks.*.content.content.cells.*._state",
    (notebookId, idx) =>
      console.log "OTD CHANGE cell", notebookId, idx
      model = @store.createModel()

      notebookPath = "notebooks.#{notebookId}"

      model.fetch notebookPath, (err)=>
        notebook = model.at notebookPath
        source = notebook.get "content.content.cells.#{idx}.source"
        @sockets[notebook.get "session.id"].execute source,
          shell:
            reply:  (msg)-> console.log "reply", msg
            payload: (msg)-> console.log "payload", msg
          iopub:
            output: (msg)-> console.log "output", msg
            clear_output: (msg)-> console.log "clear_output", msg
