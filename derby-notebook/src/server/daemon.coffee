liveDbMongo = require 'livedb-mongo'
Redis = require 'redis'
racer = require 'racer'

log = (args...) -> console.log "DAEMON", args...

module.exports = ->
  log 'STARTING'

  {MONGO_PORT, MONGO_HOST, MONGO_DB, REDIS_HOST} = process.env
  MONGO_HOST = MONGO_HOST or 'localhost'
  MONGO_PORT = MONGO_PORT or 27017
  MONGO_DB = MONGO_DB or 'derby-' + (app.name or 'app')

  redis = Redis.createClient()
  redis.select REDIS_HOST
  log 'redis', redis

  mongoUrl = "mongodb://#{MONGO_HOST}:#{MONGO_PORT}/#{MONGO_DB}?auto_reconnect"

  store = racer.createStore
    db: liveDbMongo mongoUrl, safe: true
    redis: redis
  log 'store', store

  model = store.createModel()
  log 'model', model

  model.on 'change', (value) ->
    log 'change: ' + value
