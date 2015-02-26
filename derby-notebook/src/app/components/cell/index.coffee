module.exports = class Cell
  view: __dirname
  color: (id) ->
    id[0..5]
  selectCell: (id) ->
    console.log "SELECT", id
    @model.set "currentCell", id
  create: ->
    console.log "CREATE", @model.get "cell"
