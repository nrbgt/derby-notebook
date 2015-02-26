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

          prev = null

          # load cells, copy them, and collect ids
          for cell in body.content.cells
            _.extend cell,
              _notebook: id
              _prev: prev

            prev = model.add "cells", cell
            console.log """
              created cell at #{cell._prev} #{cell.id}:
              #{JSON.stringify cell, null, 2}
            """

          model.setEach "notebooks.#{id}",
            content: body
            session: false
            -> console.log "OTD set contents of #{id}"
