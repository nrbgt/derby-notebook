init = (options)->
  @component require './cell'
  @component require './icon'
  @component require './header'
  @component require './kernel'
  @component require './editor'
  @component require './button'
  @component require './toolbar'
  @component require './notebook'
  @component require './userbadge'

module.exports = (app, options) -> init.call app
