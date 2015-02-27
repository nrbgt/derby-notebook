module.exports = class Cell
  view: __dirname
  color: (id="000000") -> id[0..5]
  selectCell: (id) -> @model.set "currentCell", id
