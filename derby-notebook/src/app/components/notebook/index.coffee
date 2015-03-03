module.exports = class Notebook
  view: __dirname

  init: ->
    notebookId = @model.get "notebook.id"
    cells = @model.scope "cells"

    filter = @model
      .filter cells, (cell) -> cell and cell._notebook is notebookId
      .sort (a, b) ->
        if b._prev is a.id then -1 else 1

    @model.ref "cells", filter

  create: ->
    window.addEventListener "resize", @resize
    @resize()

  resize: ->
    site = document.getElementById "site"
    header = document.getElementById "header"
    site.style.height = "#{window.innerHeight - header.clientHeight}px"
