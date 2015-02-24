module.exports = class Notebook
  view: __dirname
  create: ->
    window.addEventListener "resize", @resize
    @resize()
  resize: =>
    site = document.getElementById "site"
    header = document.getElementById "header"
    site.style.height = "#{window.innerHeight - header.clientHeight}px"
