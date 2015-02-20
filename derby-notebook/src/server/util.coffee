url = require "url"
Redis = require "redis"
derby = require "derby"
racer = require "racer"
session = require "express-session"
liveDbMongo = require "livedb-mongo"
RedisStore = require("connect-redis") session


env = process.env


redisClient = ->
  if env.REDIS_HOST
    redis = Redis.createClient env.REDIS_PORT, env.REDIS_HOST
    redis.auth env.REDIS_PASSWORD
  else if env.OPENREDIS_URL
    redisUrl = url.parse env.OPENREDIS_URL
    redis = Redis.createClient redisUrl.port, redisUrl.hostname
    redis.auth redisUrl.auth.split(":")[1]
  else
    redis = Redis.createClient()
  redis


mongoUrl = ->
  {MONGO_PORT, MONGO_HOST, MONGO_DB, REDIS_HOST, MONGO_URL, MONGOHQ_URL} = env

  MONGO_HOST = MONGO_HOST
  MONGO_PORT = MONGO_PORT

  if MONGO_URL
    MONGO_URL
  else if MONGOHQ_URL
    MONGOHQ_URL
  else
    "mongodb://#{MONGO_HOST}:#{MONGO_PORT}/#{MONGO_DB}?auto_reconnect"


_createStore = (lib) ->
  return lib.createStore
    db: liveDbMongo mongoUrl(), safe: true
    redis: redisClient()


derbyStore = -> _createStore derby


racerStore = -> _createStore racer


redisStore = ->
  return new RedisStore
    host: env.REDIS_HOST
    port: env.REDIS_PORT

module.exports =
  redisClient: redisClient
  mongoUrl: mongoUrl
  derbyStore: derbyStore
  racerStore: racerStore
  redisStore: redisStore
