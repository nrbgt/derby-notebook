module.exports = class Cell
  view: __dirname
  color: (id)-> id[0..5]
  selectCell: (idx) ->
    @model.set "currentCell", idx
