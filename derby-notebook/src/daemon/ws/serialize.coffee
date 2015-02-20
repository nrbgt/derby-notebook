# Copyright (c) IPython Development Team.
# Distributed under the terms of the Modified BSD License.
_ = require "underscore"


_deserialize_array_buffer = (buf) ->
  data = new DataView(buf)
  # read the header: 1 + nbufs 32b integers
  nbufs = data.getUint32(0)
  offsets = []
  i = undefined
  i = 1
  while i <= nbufs
    offsets.push data.getUint32(i * 4)
    i++
  json_bytes = new Uint8Array(buf.slice(offsets[0], offsets[1]))
  msg = JSON.parse(new TextDecoder('utf8').decode(json_bytes))
  # the remaining chunks are stored as DataViews in msg.buffers
  msg.buffers = []
  start = undefined
  stop = undefined
  i = 1
  while i < nbufs
    start = offsets[i]
    stop = offsets[i + 1] or buf.byteLength
    msg.buffers.push new DataView(buf.slice(start, stop))
    i++
  msg


_deserialize_binary = (data, callback) ->

  ###*
  # deserialize the binary message format
  # callback will be called with a message whose buffers attribute
  # will be an array of DataViews.
  ###

  if data instanceof Blob
    # data is Blob, have to deserialize from ArrayBuffer in reader callback
    reader = new FileReader

    reader.onload = ->
      msg = _deserialize_array_buffer(@result)
      callback msg
      return

    reader.readAsArrayBuffer data
  else
    # data is ArrayBuffer, can deserialize directly
    msg = _deserialize_array_buffer(data)
    callback msg
  return


deserialize = (data, callback) ->

  ###*
  # deserialize a message and pass the unpacked message object to callback
  ###

  if typeof data == 'string'
    # text JSON message
    callback JSON.parse(data)
  else
    # binary message
    _deserialize_binary data, callback
  return


_serialize_binary = (msg) ->

  ###*
  # implement the binary serialization protocol
  # serializes JSON message to ArrayBuffer
  ###

  msg = _.clone(msg)
  offsets = []
  buffers = []
  msg.buffers.map (buf) ->
    buffers.push buf
    return
  delete msg.buffers
  json_utf8 = new TextEncoder('utf8').encode(JSON.stringify(msg))
  buffers.unshift json_utf8
  nbufs = buffers.length
  offsets.push 4 * (nbufs + 1)
  i = undefined
  i = 0
  while i + 1 < buffers.length
    offsets.push offsets[offsets.length - 1] + buffers[i].byteLength
    i++
  msg_buf = new Uint8Array(offsets[offsets.length - 1] + buffers[buffers.length - 1].byteLength)
  # use DataView.setUint32 for network byte-order
  view = new DataView(msg_buf.buffer)
  # write nbufs to first 4 bytes
  view.setUint32 0, nbufs
  # write offsets to next 4 * nbufs bytes
  i = 0
  while i < offsets.length
    view.setUint32 4 * (i + 1), offsets[i]
    i++
  # write all the buffers at their respective offsets
  i = 0
  while i < buffers.length
    msg_buf.set new Uint8Array(buffers[i].buffer), offsets[i]
    i++
  # return raw ArrayBuffer
  msg_buf.buffer


serialize = (msg) ->
  if msg.buffers and msg.buffers.length
    _serialize_binary msg
  else
    JSON.stringify msg

module.exports =
  deserialize: deserialize
  serialize: serialize
