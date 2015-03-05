_ = require "underscore"

module.exports = class Toolbar
  view: __dirname

  moveCellUp: (id) ->
    console.log "UP", @model.get "cells"

  moveCellDown: (id) ->
    console.log "DOWN", @model.get "cells"

  insertCell: (after) ->
    ordered = @model.get "cells"
    cells = @model.scope "cells"
    cellId = @model.get "currentCell"

    console.log "NOTEBOOK", @model.get "notebook"

    newCell =
      cell_type: "markdown"
      source: ""
      metadata: {}
      _notebook: @model.get "notebook.id"
      _weight: 1e6

    if cellId
      cell = _.findWhere ordered, id: cellId
      cidx = ordered.indexOf cell

      prev = if !cidx then 0 else ordered[cidx - 1]._weight
      current = ordered[cidx]._weight
      next = if cidx is ordered.length - 1
          ordered[cidx]._weight + 1e3
        else
          ordered[cidx + 1]._weight

      newCell._weight = 0.5 * (current + (if after then next else prev))

    @model.set "currentCell", cells.add newCell

  runCell: (id) ->
    @model.root.set "cells.#{id}._state", "run"
