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

          # load cells, copy and weight them
          for cell, idx in body.content.cells
            prev = model.add "cells", _.extend cell,
              _notebook: notebookId
              _weight: 1e3 * (idx + 1)

          model.setEach "notebooks.#{notebookId}",
            content: body
            session: false
            (err)->
              if err
                console.error "OTD set contents #{notebookId} error: #{err}"
              else
                console.log "OTD set contents of #{notebookId}!"
