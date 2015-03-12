init = (options)->
  @component require './button'
  @component require './cell-markup'
  @component require './cell'
  @component require './editor'
  @component require './header'
  @component require './icon'
  @component require './kernel'
  @component require './markdown'
  @component require './notebook'
  @component require './toolbar'
  @component require './userbadge'

module.exports = (app, options) -> init.call app
