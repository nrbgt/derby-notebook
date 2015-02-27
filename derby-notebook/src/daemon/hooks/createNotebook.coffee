_ = require "underscore"
loadContents = require "../api/loadContents"

module.exports = ->
  @store.hook "create", "notebooks", (notebookId, notebook) =>
    model = @store.createModel()

    model.fetch "notebooks.#{notebookId}", =>
      new loadContents
        notebook: notebook.name
        (err, response, body) ->
          return console.error "OTD failed FETCH #{notebookId}", err if err

          prev = null

          # load cells, copy them, and collect ids
          for cell in body.content.cells
            prev = model.add "cells", _.extend cell,
              _notebook: notebookId
              _prev: prev

          model.setEach "notebooks.#{notebookId}",
            content: body
            session: false
            (err)-> console.log "OTD set contents of #{notebookId}: #{err}"
