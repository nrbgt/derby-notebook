module.exports = class Chat
  view: __dirname

  submit: ->
    messages = @model.scope "messages"

    messages.add
      source: @model.get "newMessage"
      notebook: @model.get "notebook.id"
      notebook: @model.get "notebook.id"

    @model.set "newMessage", ""
