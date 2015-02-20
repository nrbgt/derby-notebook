app = module.exports = require 'derby'
  .createApp 'derby-notebook', __filename

init = ->
  @serverUse module, "derby-jade", coffee: true
  @serverUse module, "derby-stylus"

  @loadViews "#{__dirname}/views"
  @loadStyles "#{__dirname}/styles"

  @use require "derby-debug"
  @use require "./components"

  # Routes render on CLIENT as well as SERVER
  @get '/multiuser/:name?', (page, model, {name}, next) ->
    notebookQuery = model.query 'notebooks', name: name

    notebookQuery.subscribe (err) ->
      return next err if err

      notebooks = notebookQuery.get()
      id = if notebooks.length then notebooks[0].id else
        model.add "notebooks", name: name

      model.ref "_page.notebook", "notebooks.#{id}"
      page.render()

init.call app
