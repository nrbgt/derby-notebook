marked = require "marked"

module.exports = class Markdown
  view: __dirname
  style: __dirname

  convert: ->
    marked @model.get "value"
