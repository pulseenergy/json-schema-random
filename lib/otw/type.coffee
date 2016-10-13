"use strict"

module.exports = (obj) ->
  return String(obj)  unless obj?
  Object::toString.call(obj).slice(8, -1).toLowerCase() or 'object'
