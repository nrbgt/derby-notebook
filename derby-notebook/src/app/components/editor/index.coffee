module.exports = class CellEditor
  view: __dirname

  create: (model)->
    CodeMirror = require "codemirror"
    require "codemirror/mode/gfm/gfm.js"

    @cm = CodeMirror @container,
      value: @model.get("value") or ""
      theme: "ipython"
      mode: "gfm"
      matchBrackets: true
      lineWrapping: true

    @model.on "change", "value", (old, value, passed) => @modelChanged passed
    @cm.on "change", (cm, change) => @editorChanged change

  modelChanged: ({editing, $stringInsert, $stringRemove}) ->
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
