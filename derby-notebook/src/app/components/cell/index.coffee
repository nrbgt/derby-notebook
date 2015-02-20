module.exports = class Cell
  view: __dirname
  create: (model, dom)->
    CodeMirror = require "codemirror"
    require "codemirror/mode/gfm/gfm.js"

    console.log @model.get "cell.source"

    @cm = CodeMirror.fromTextArea @textarea,
      theme: "ipython"
      mode: "gfm"
      matchBrackets: true
      lineWrapping: true

    # changes in values inside the array
    @model.on "change", "cell.source", (oldVal, newVal, passed) =>
      #we don't want to change the CM instance if we did the change
      return if passed.editing

      if insert = passed.$stringInsert
        @suppress = true
        @cm.replaceRange insert.text, @cm.posFromIndex insert.index
        @suppress = false
      else if (remove = passed.$stringRemove) and remove.howMany
        @suppress = true
        from = @cm.posFromIndex remove.index
        to = @cm.posFromIndex remove.howMany
        @cm.replaceRange "", from, to
        @suppress = false

    @cm.on "change", (cm, change) =>
      return if @suppress or not change or change.origin == "setValue"

      start = @cm.indexFromPos change.from
      end = @cm.indexFromPos change.to

      #delete anything if needed
      if change.removed.length or change.removed
        toRemove = change.removed.join "\n"
        @model.pass editing: true
          .stringRemove "cell.source", start, toRemove.length

      #see if we have anything to insert
      if change.text.length or change.text
        toInsert = change.text.join "\n"
        model.pass editing: true
          .stringInsert "cell.source", start, toInsert
