module.exports = class Notebook
  view: __dirname
  style: __dirname

  init: ->
    notebookId = @model.get "notebook.id"
    cells = @model.scope "cells"

    filter = @model
      .filter cells, (cell) -> cell and cell._notebook is notebookId
      .sort (a, b) -> a._weight - b._weight

    @model.ref "cells", filter, updateIndices: true

  create: ->
    window.addEventListener "resize", @resize
    @resize()

  resize: ->
    site = document.getElementById "site"
    header = document.getElementById "header"
    site.style.height = "#{window.innerHeight - header.clientHeight}px"
