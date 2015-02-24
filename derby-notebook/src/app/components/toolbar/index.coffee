module.exports = class Toolbar
  view: __dirname

  insertCell: (current)->
    @model.insert "cells", current, [
      metadata: {}
      cell_type: "markdown"
      source: ""
    ]
    @model.set "currentCell", current

  runCurrentCell: (current)->
    @model.set "cells.#{current}._state", "run"
