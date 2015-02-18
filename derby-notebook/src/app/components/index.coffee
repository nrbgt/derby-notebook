init = (options)->
  @component require './cell'
  @component require './header'
  @component require './notebook'

module.exports = (app, options) -> init.call app
