WebSocket = require "ws"

ApiCall = require "../api/apiCall"

serialize = require "./serialize"


module.exports = class SessionSocket extends ApiCall
  VERSION: "5.0"
  MSG:
    KERNEL_INFO: "kernel_info_request"
  CHANNEL:
    SHELL: "shell"
  username: "OTD"

  root: -> "ws://#{@origin}/api/kernels"

  constructor: (@session, @notebook, @store, @secret) ->
    @callbacks = {}

    k = @session.kernel.id
    s = @session.id

    @ws = new WebSocket "#{@root()}/#{k}/channels?session_id=#{s}",
      headers:
        Cookie: @secret[0].split(";")[0]
        Host: @origin
        Origin: "http://#{@origin}"

    @setModel "session.kernel.status", "connecting"
    @ws.onmessage = @onMessage

    @ws.onopen = (evt) =>
      @setModel "session.kernel.status", "connected"
    @ws.onerror = (evt) =>
      @setModel "session.kernel.status", "error"
    @ws.onclose = (evt) =>
      @setModel "session.kernel.status", "dead"

  setModel: (path, value, op="set") ->
    model = @store.createModel()
    notebook = model.at @notebook
    model.fetch notebook, ->
      console.log "Attempting to set #{@notebook}.#{path} =>", value
      notebook[op] path, value

  onMessage: (evt) =>
    console.log evt
    serialize.deserialize e.data, @finishMessage

  finishMessage: (msg) =>
    if msg.channel == @CHANNEL.SHELL
      @handleShellReply msg

  handleShellReply: (reply) ->
    {content, metadata} = reply
    parent = reply.parent_header.msg_id
    @callbacks[msg.header.msg_id]?.shell?.reply reply

  send: (msg) ->
    @ws.send serialize.serialize msg

  sendShell: (type, content, callbacks, metadata, buffers) ->
    msg = @msg type, content, metadata, buffers
    msg.channel = @CHANNEL.SHELL
    @send msg
    @callbacks[msg.header.msg_id] callbacks

  kernelInfo: (callback=->) ->
    @sendShell @MSG.KERNEL_INFO, {}, shell: reply: callback

  uuid: ->
    # http://www.ietf.org/rfc/rfc4122.txt
    s = []
    hexDigits = "0123456789ABCDEF"
    for i in [0..32]
      s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
    s[12] = "4"
    # bits 12-15 of the time_hi_and_version field to 0010
    s[16] = hexDigits.substr(s[16] & 0x3 | 0x8, 1)
    # bits 6-7 of the clock_seq_hi_and_reserved to 01
    s.join ""

  msg: (msg_type, content, metadata={}, buffers=[]) =>
    header:
      msg_id: @uuid()
      username: @username
      session: @session.id
      msg_type: msg_type
      version: @VERSION
    metadata: metadata
    content: content
    buffers: buffers
    parent_header: {}
