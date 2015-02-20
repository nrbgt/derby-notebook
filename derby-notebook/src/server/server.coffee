coffeeify = require "coffeeify"
derby = require "derby"
highway = require "racer-highway"
bundle = require "racer-bundle"
express = require "express"

favicon = require "serve-favicon"
compression = require "compression"
cookieParser = require "cookie-parser"
session = require "express-session"

util = require "./util"


# derby plugins
derby.use bundle


# error app
errorApp = derby.createApp()
errorApp.loadViews "#{__dirname}/../views/error"
errorApp.loadStyles "#{__dirname}/../styles/reset"
errorApp.loadStyles "#{__dirname}/../styles/error"


exports.setup = setup = (app, options, cb) ->
  publicDir = "#{__dirname}/../../public"

  # The store creates models and syncs data
  store = util.derbyStore()

  store.on "bundle", (browserify) ->
    browserify.transform { global: true }, coffeeify
    pack = browserify.pack

    browserify.pack = (opts) ->
      detectTransform = opts.globalTransform.shift()
      opts.globalTransform.push detectTransform
      pack.apply this, arguments

  options.storeCallback store if options.storeCallback

  handlers = highway store

  expressApp = express()
    #.use favicon "#{publicDir}/favicon.ico"
    .use compression()
    .use express.static publicDir
    .use store.modelMiddleware()
    .use cookieParser()
    .use session
      store: util.redisStore()
      secret: process.env.SESSION_SECRET or "YOUR SECRET HERE"
    .use handlers.middleware
    .use createUserId

  if options and options.static
    if Array.isArray options.static
      for handler in option.static
        expressApp.use handler.route, express.static handler.dir
    else
      expressApp.use express.static options.static

  expressApp.use app.router()
    .use errorMiddleware

  app.writeScripts store, publicDir, { extensions: [ ".coffee" ] }, (err) ->
    cb err, expressApp, handlers.upgrade


createUserId = (req, res, next) ->
  model = req.getModel()
  userId = req.session.userId or req.session.userId = model.id()
  model.set "_session.userId", userId
  next()


errorMiddleware = (err, req, res, next) ->
  return next() unless err
  message = err.message or err.toString()
  status = parseInt(message)
  status = if status >= 400 and status < 600 then status else 500
  if status < 500
    console.log err.message or err
  else
    console.log err.stack or err
  page = errorApp.createPage req, res, next
  page.renderStatic status, status.toString()
