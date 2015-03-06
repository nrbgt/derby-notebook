module.exports = class Button
  view: __dirname

  click: ->
    @emit "clicked"
