xhr = require 'xhr-browserify'

app = module.exports = require 'derby'
  .createApp 'hello', __filename

app.loadViews __dirname

# Routes render on CLIENT as well as SERVER
app.get '/multiuser/:notebook?', (page, model, {notebook}, next) ->
  model.setNull "_page.notebook", notebook

  try
    xhr "/api/contents/#{notebook}?type=notebook", (err, data) ->
      model.setNull "_page.contents", data
  catch err
    console.log err

  # Subscribe specifies the data to sync
  model.subscribe 'hello.message', ->
    console.log "rendering"
    page.render()
