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
      order = cell.get "_order"
      newId = @model.root.add "cells",
        metadata: {}
        cell_type: "markdown"
        source: ""
        _notebook: cell.get "_notebook"
        _order: "#{order}-00000"
        _prev: cell.get "_prev"

      cell.setEach _order: "#{order}-00001", _prev: newId

  runCell: (id) ->
    @model.root.set "cells.#{id}._state", "run"
