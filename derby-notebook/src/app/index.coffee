app = module.exports = require 'derby'
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
    notebookQuery = model.query 'notebooks', name: name

    notebookQuery.fetch (err) ->
      return next err if err
      console.log "fetched query"
      notebooks = notebookQuery.get()

      # first we have to find the notebook..
      id = if notebooks.length
        notebooks[0].id
      else
        console.log "adding notebook"
        # or we make a new one
        model.add "notebooks", name: name

      # reference it to the page for easy naming
      notebook = model.at "notebooks.#{id}"

      # finally, subscribe to all changes beneath it... maybe other stuff
      # eventually
      model.subscribe notebook, (err) ->
        return next err if err
        console.log "notebook subscription"
        model.ref "_page.notebook", notebook
        model.setNull "_session.currentCell", 0

        cellIds = notebook.at "cellIds"

        model.query "cells", cellIds
          .subscribe (err) ->
            return next err if err
            model.ref '_page.notebook', notebook
            model.refList '_page.cells', 'cells', cellIds

            # ok, actually render!
            page.render()


# let's go!
init.call app
