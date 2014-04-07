# Test script
# =================================================*/

module.exports.returnString = ->
  "Something went wrong"

module.exports.returnError = ->
  new Error "Something went wrong"

module.exports.returnCause = ->
  err = new Error "Something went wrong"
  err.cause = new Error "root fault"
  err.codePart = 'somethere'
  err

module.exports.returnCauseArray = ->
  err = new Error "Something went wrong"
  err.cause = [
    new Error "root fault 1"
    new Error "root fault 2"
  ]
  err.codePart = 'somethere'
  err

module.exports.returnCauseHash = ->
  err = new Error "Something went wrong"
  err.cause =
    here: new Error "root fault 1"
    there: new Error "root fault 2"
  err
