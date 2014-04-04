# Test script
# =================================================*/

module.exports.returnString = ->
  "Something went wrong"

module.exports.returnError = ->
  new Error "Something went wrong"

module.exports.returnCause = ->
  err = new Error "Something went wrong"
  err.cause = new Error "root fault"
  err
