module.exports = class Toolbar
  view: __dirname

  moveCellUp: (id) ->
    console.log "UP", @model.get "cells"

  moveCellDown: (id) ->
    console.log "DOWN", @model.get "cells"

  insertCell: (after) ->
    console.log "attempting to insert a cell"

    cell = @model.root.at "cells.#{after}"

    @model.fetch cell, =>
      newId = @model.root.add "cells",
        metadata: {}
        cell_type: "markdown"
        source: ""
        _notebook: cell.get "_notebook"
        _prev: cell.get "_prev"

      cell.set "_prev", newId

  runCell: (id) ->
    @model.root.set "cells.#{id}._state", "run"
