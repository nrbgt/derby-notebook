_ = require "underscore"
{icons} = require "./components/icon"

randomColor = -> '#' + Math.floor(Math.random()*16777215).toString(16)

module.exports = app = require 'derby'
  .createApp 'derby-notebook', __filename

# extra init so we can use app as @
init = ->
  # these are preference: coffee, jade, stylus kinda wotk the same
  @serverUse module, "derby-jade", coffee: true
  @serverUse module, "derby-stylus"

  # load high-level views and templates
  @loadViews "#{__dirname}/views"
  @loadStyles "#{__dirname}/styles"

  # enable various derby-level things
  @use require "derby-debug"
  @use require "./components"

  # Routes render on CLIENT as well as SERVER
  @get '/multiuser/:name?', (page, model, {name}, next) ->
    notebookQuery = model.query "notebooks", name: name
    userId = model.get "_session.userId"
    user = model.at "users.#{userId}"

    notebookQuery.fetch (err) ->
      return next err if err
      notebooks = notebookQuery.get()

      console.log "fetched #{notebooks.length} named #{name}"

      # first we have to find the notebook..
      notebookId = if notebooks.length
        console.log "found notebook named #{name} at #{notebooks[0].id}"
        notebooks[0].id
      else
        console.log "creating notebook named #{name}",
        # or we make a new one
        model.add "notebooks", name: name
      console.log "using notebook #{notebookId}"

      # scope a model
      notebook = model.at "notebooks.#{notebookId}"

      # get cells ready
      cells = model.query "cells",
        _notebook: notebookId

      # finally, subscribe to all changes beneath it... maybe other stuff
      # eventually
      model.subscribe cells, notebook, user, (err) ->
        return next err if err
        # set up refs
        user.setNull "icon", _.sample icons
        user.setNull "color", randomColor()

        model.ref "_page.notebook", notebook
        model.ref "_page.user", user

        # ok, actually render!
        page.render()


# let's go!
init.call app
