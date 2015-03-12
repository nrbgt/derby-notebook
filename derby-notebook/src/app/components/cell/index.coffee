module.exports = class Cell
  view: __dirname

  select: ->
    @model.set "currentCell", @model.get "cell.id"

  classes: (cell, userCell, current)->
    if cell.id is current then "selected" else ""

  init: ->
    cellId = @model.get "cell.id"
    userCells = @model.scope "_page.userNotebook.cells"

    unless userCells.get cellId
      userCells.add
        id: cellId

    @model.ref "userCell", userCells.at cellId
