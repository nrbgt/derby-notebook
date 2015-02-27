module.exports = class CellEditor
  view: __dirname

  create: (model)->
    CodeMirror = require "codemirror"
    require "codemirror/mode/gfm/gfm.js"

    @cm = CodeMirror @container,
      theme: "ipython"
      mode: "gfm"
      matchBrackets: true
      lineWrapping: true

    value = @model.get "value"

    if value is not null
      @cm.setValue value
    else
      process.nextTick =>
        @cm.setValue @model.get "value"

    @model.on "change", "value", (old, value, passed) =>
      @modelChanged value, passed
    @cm.on "change", (cm, change) => @editorChanged change

  modelChanged: (value, {editing, $stringInsert, $stringRemove}) ->
    #we don't want to change the CM instance if we did the change
    return if editing

    if $stringInsert
      @suppress = true
      @cm.replaceRange $stringInsert.text, @cm.posFromIndex $stringInsert.index
      @suppress = false
    else if $stringRemove?.howMany
      @suppress = true
      from = @cm.posFromIndex $stringRemove.index
      to = @cm.posFromIndex $stringRemove.index + $stringRemove.howMany
      @cm.replaceRange "", from, to
      @suppress = false

    @check()

  editorChanged: ({from, to, origin, removed, text}={}) ->
    return if @suppress or origin == "setValue"

    start = @cm.indexFromPos from
    end = @cm.indexFromPos to

    process.nextTick =>
      #delete anything if needed
      if removed?.length
        @model.pass editing: true
          .stringRemove "value", start, removed.join("\n").length

      #see if we have anything to insert
      if text?.length
        @model.pass editing: true
          .stringInsert "value", start, text.join "\n"

      @check()

  check: ->
    process.nextTick =>
      if @cm.getValue() is not (mv = @model.get "value")
        @supress = true
        @cm.setValue mv
        @supress = false
