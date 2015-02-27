module.exports = class Toolbar
  view: __dirname

  moveCellUp: (id) ->
    console.log "UP", @model.get "cells"

  moveCellDown: (id) ->
    console.log "DOWN", @model.get "cells"

  insertCell: (after) ->
    console.log "attempting to insert a cell"
    @model.set "newCell",
      id: @model.id()
      metadata: {}
      cell_type: "markdown"
      source: ""
      _prev: after

  runCell: (id) ->
    @model.set "cells.#{current}._state", "run"
