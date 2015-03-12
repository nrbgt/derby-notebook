_ = require "underscore"

module.exports = class Toolbar
  view: __dirname

  doAction: (action) ->
    console.log action

  cellIndex: (cellId) ->
    cells = @model.get "cells"
    cells.indexOf _.findWhere cells, id: cellId

  removeCell: ->
    @model.scope "cells"
      .del @model.get "currentCell"

  moveCell: (down) ->
    console.log "move", down
    return unless cellId = @model.get "currentCell"

    cells = @model.get "cells"

    idx = @cellIndex cellId

    # can't move first and last
    return if (down and (idx == cells.length - 1)) or (not down and (idx == 0))

    before = (if down then cells[idx + 1] else cells[idx - 1])._weight

    after = if down
      if cells[idx + 2] then cells[idx + 2]._weight else before + 1e3
    else
      if cells[idx - 2] then cells[idx - 2]._weight else 0

    console.log "moving", cellId, "between", before, after
    @model.scope "cells"
      .set "#{cellId}._weight", (before + after) / 2

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
      cidx = @cellIndex cellId

      prev = if !cidx then 0 else ordered[cidx - 1]._weight
      current = ordered[cidx]._weight
      next = if cidx is ordered.length - 1
          ordered[cidx]._weight + 1e3
        else
          ordered[cidx + 1]._weight

      newCell._weight = 0.5 * (current + (if after then next else prev))

    @model.set "currentCell", cells.add newCell

  runCell: ->
    cellId = @model.get "currentCell"
    cell = @model.scope "cells.#{cellId}"
    userCell = @model.scope "_page.userNotebook.cells.#{cellId}"

    cellType = cell.get "cell_type"

    if cellType == "markdown"
      userCell.set "rendered", true
    else
      cell.set "_state", "run"
