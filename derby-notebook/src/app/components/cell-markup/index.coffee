module.exports = class MarkupCell extends require "../cell"
  view: __dirname

  classes: (cell, userCell, current) ->
    classes = super cell, userCell, current
    "#{classes} #{if userCell.rendered then '' else 'un' }rendered"

  unrender: ->
    @model.set "userCell.rendered", false, =>
      @editor.refresh()
