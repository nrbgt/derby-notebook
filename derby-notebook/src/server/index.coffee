env = process.env

if env.MONGO_PORT_27017_TCP_ADDR
  env.MONGO_HOST = env.MONGO_PORT_27017_TCP_ADDR

if env.MONGO_PORT_27017_TCP_PORT
  env.MONGO_PORT = env.MONGO_PORT_27017_TCP_PORT

if (env.REDIS_PORT_6379_TCP_ADDR != undefined and
    env.REDIS_PORT_6379_TCP_PORT != undefined)
  env.REDIS_HOST = env.REDIS_PORT_6379_TCP_ADDR
  env.REDIS_PORT = env.REDIS_PORT_6379_TCP_PORT

if env.IPYTHON_PORT_8888_TCP_ADDR
  env.IPYTHON_HOST = env.IPYTHON_PORT_8888_TCP_ADDR

if env.IPYTHON_PORT_8888_TCP_PORT
  env.IPYTHON_PORT = env.IPYTHON_PORT_8888_TCP_PORT

env.MONGO_DB = 'derby-notebook'
env.NODE_ENV = 'production'

#require('./daemon')()


app = require '../app'

require './starter'
  .run app,
    port: 9999
    setupCallback: (err, expressApp) -> require("./proxy") expressApp
    listenCallback: (err) -> console.log "well, it started", err
