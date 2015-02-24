_ = require "underscore"
loadContents = require "../api/loadContents"

module.exports = ->
  @store.hook "create", "notebooks", (id, notebook) =>
    model = @store.createModel()

    model.fetch "notebooks.#{id}", =>
      new loadContents
        notebook: notebook.name
        (err, response, body) ->
          return console.error "OTD failed to fetch contents #{id}", err if err

          # load cells, copy them, and collect ids
          cellIds = for cell in body.content.cells
            model.add "cells", cell

          model.setEach "notebooks.#{id}",
            cellIds: cellIds
            content: body
            session: false
            -> console.log "OTD set contents of #{id}"
