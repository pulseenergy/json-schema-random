"use strict"

random = (type, options) ->
  switch type
    when 'number'
      random._getNumber options
    when 'integer', 'int'
      random._getInteger options
    when 'boolean', 'bool'
      random._getBoolean options
    when 'string'
      random._getString options


# maxNumber = Math.pow(2, 53) - 1
# minNumber = maxNumber * -1
# we need bitwise operations, see http://notepad2.blogspot.se/2012/04/maximum-integer-in-javascript.html
random._maxNumber = Math.pow(2, 31) - 1
random._minNumber = random._maxNumber * -1


random._getInt = (min, max) ->
  min ?= random._minNumber
  max ?= random._maxNumber
  max = min  if min > max
  return Math.floor(Math.random() * (max - min + 1)) + min


random._getNumber = (options) ->
  options ?= {}
  options.minimum ?= random._minNumber
  options.minimum = random._minNumber  if options.minimum < random._minNumber
  options.maximum ?= random._maxNumber
  options.maximum = random._maxNumber  if options.maximum > random._maxNumber
  options.divisibleBy ?= 1
  options.decimals ?= 0
  options.decimals = 0  if options.decimals < 0
  options.base ?= 10

  if options.divisibleBy isnt 1
    options.maximum = parseInt(options.maximum / options.divisibleBy)

  randomInt = random._getInt options.minimum, options.maximum

  if options.divisibleBy isnt 1
    randomInt = randomInt * options.divisibleBy

  if options.decimals isnt 0
    randomInt = randomInt / Math.pow(10, options.decimals)

  if options.base isnt 10
    randomInt = randomInt.toString options.base
  randomInt


random._getInteger = (options = {}) ->
  options.decimals = 0
  random._getNumber options


random._getBoolean = (options = {}) ->
  options.minimum = 0
  options.maximum = 1
  Boolean random._getInteger options


random._getString = (options) ->
  options ?= {}
  options.minLength ?= 0
  options.minLength = 0  if options.minLength < 0
  options.maxLength ?= 255
  options.maxLength = 255  if options.maxLength > 255
  options.maxLength = options.minLength  if options.minLength > options.maxLength
  options.useDigits ?= true
  options.useUpperCase ?= true
  options.useLowerCase ?= true

  digits = '1234567890'
  upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  lowerCase = 'abcdefghijklmnopqrstuvwxyz'

  possibleChars = ''
  possibleChars += digits  if options.useDigits
  possibleChars += upperCase  if options.useUpperCase
  possibleChars += lowerCase  if options.useLowerCase
  possibleChars ?= digits + upperCase + lowerCase

  length = random._getNumber {minimum: options.minLength, maximum: options.maxLength}

  result = ''
  for i in [1..length]
    result += possibleChars.charAt random._getInt(0, possibleChars.length-1)
  result

module.exports = random
