request = require 'request'

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
  @get '/multiuser/:notebook?', (page, model, {notebook}, next) ->
    model.setNull "_page.notebook", notebook

    request
      uri: "/api/contents/#{model.get "notebook"}?type=notebook"
      headers: "Content-Type": "application/json"
      json: true
      (err, resp, body) -> model.set "_page.notebook_content", body

    # Subscribe specifies the data to sync
    model.subscribe "hello.message", ->
      console.log "rendering"
      page.render()

init.call app
