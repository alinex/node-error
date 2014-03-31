# Test script
# =================================================*/

# include base modules
errorHandler = require '../lib'
errorHandler.install()

# Easy script
# -------------------------------------------------
console.log "start"
throw new Error "Something went wrong"
