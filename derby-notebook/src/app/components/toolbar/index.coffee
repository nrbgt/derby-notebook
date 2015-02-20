module.exports = class Toolbar
  view: __dirname
  insertCell: ->
    console.log @model.insert "notebook.content.content.cells", 0, [
      metadata: {}
      cell_type: "markdown"
      source: ""
    ]
