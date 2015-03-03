module.exports = class Toolbar
  view: __dirname

  moveCellUp: (id) ->
    console.log "UP", @model.get "cells"

  moveCellDown: (id) ->
    console.log "DOWN", @model.get "cells"

  insertCell: (after) ->

    cells = @model.scope "cells"
    cell = cells.at after
    session = @model.scope "_session"

    console.log "attempting to insert a cell after #{after}"

    newCell =
      id: newId = @model.id()
      metadata: {}
      cell_type: "markdown"
      source: ""
      _notebook: cell.get "_notebook"
      _prev: cell.get "_prev"

    cell.set "_prev", newId
    cells.add newCell
    session.set "currentCell", newId


    console.log "created new cell #{newId}", newCell

  runCell: (id) ->
    @model.root.set "cells.#{id}._state", "run"
