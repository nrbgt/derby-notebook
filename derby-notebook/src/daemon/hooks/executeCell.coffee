module.exports = ->
  @store.hook "change",
    "notebooks.*.content.content.cells.*.status",
    (id, session) =>
      console.log "OTD CHANGE cell", arguments
