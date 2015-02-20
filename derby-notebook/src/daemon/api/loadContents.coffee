module.exports = class LoadContents extends require "./apiCall"
  url: -> "#{@root()}/api/contents/#{@notebook}?type=notebook"
  constructor: ({@notebook}, callback) ->
    @request
      url: @url()
      headers: "Content-Type": "application/json"
      json: true
      callback
