_ = require "underscore"

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
    notebookQuery = model.query 'notebooks', name: name

    notebookQuery.fetch (err) ->
      return next err if err
      notebooks = notebookQuery.get()

      # first we have to find the notebook..
      notebookId = if notebooks.length
        notebooks[0].id
      else
        # or we make a new one
        model.add "notebooks", name: name

      notebook = model.at "notebooks.#{notebookId}"

      # handler model changes
      model.on "change", "_page.newCell.**", -> process.nextTick ->
        cell = model.del "_page.newCell"
        console.log "DELETED NEW CELL", cell

        _.extend cell, _notebook: notebookId

        model.add "cells", cell

        oldPrev = model.query "cells",
          _prev: cell._prev
          _notebook: notebookId

        oldPrev.fetch ->
          prevs = oldPrev.get()
          model.set "cells.#{prevs[0].id}._prev", cell.id if prevs.length

      model.setNull "_session.currentCell",  null

      #set up filters
      model
        .filter "cells", (cell) -> cell._notebook is notebookId
        .sort (a, b) -> if b._prev is a.id then -1 else 1
        .ref "_page.cells"

      # finally, subscribe to all changes beneath it... maybe other stuff
      # eventually
      model.subscribe notebook, "cells", (err) ->
        return next err if err
        # set up refs
        model.ref "_page.notebook", notebook

        # ok, actually render!
        page.render()


# let's go!
init.call app
