module.exports = class Toolbar
  view: __dirname

  insertCell: (after) ->
    @model.setEach "newCell",
      id: @model.id()
      metadata: {}
      cell_type: "markdown"
      source: ""
      _prev: after

  runCell: (id) ->
    @model.set "cells.#{current}._state", "run"
