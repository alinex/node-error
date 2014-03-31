# Error handler
# =================================================
#
# The error handling will only work if run through node.js not if called
# directly using iced or coffee. If interpreting coffee directly it will
# not always capture the errors using `process.on 'uncaughtException'`.
# That's a bug in the coffee interpreter implementation. Instead of this module
# then the default behavior will be used.

# Node Modules
# -------------------------------------------------

# include base modules
fs = require 'fs'
path = require 'path'
colors = require 'colors'
sourcemap = require 'source-map'
sprintf = require("sprintf-js").sprintf


# Configuration
# -------------------------------------------------
config = module.exports.config =
  colors: true
  # Define whether and which stack lines to show
  stack:
    view: true
    modules: false
    system: false
  # Define if and how much code to show
  code:
    view: true
    before: 2
    after: 2
    modules: false
    all: false
  # Display of the errors cause if there is one
  cause: 
    view: true
    stack: true
  # Should command exit after an uncaught error is reported
  uncaught:
    exit: true
    timeout: 100
    code: 2


# Install error handler
# -------------------------------------------------
# Install the error handler for uncaught Errors
module.exports.install = ->
  Error.prepareStackTrace = prepareStackTrace
  process.on 'uncaughtException', uncaughtError


# ### Process uncaught error
#
# The error will be caught, reported (colorful) and then the process will be
# stopped with exit value 2 if defined.
#
# __Arguments:__
#
# * `err`
#   Error object instance to report.
#
uncaughtError = (err) ->
  module.exports.report err
  # stop processing after short timeout to finish logging
  if config.uncaught.exit
    setTimeout ->
      console.error "Exiting after error logging timeout."
      process.exit config.uncaught.code
    , config.uncaught.timeout


# Report error
# -------------------------------------------------
# The given error will be reported to error output like configured. This may
# be colorful with stack trace, source mapping and code view.
#
# __Arguments:__
#
# * `err`
#   Error object instance to report.
# * `level`
#   Number of level for recursive calls
# * `codePart`
#   Specification to be added in recursive calls
module.exports.report = (err, level, codePart) ->
  if err instanceof Error
    title = err.toString()
    if config.colors
      title = title.bold[if level? then 'magenta' else 'red']
    title = "Caused by #{title}" if level
    title += " #{codePart}" if codePart
    if not config.cause.stack and level
      return console.error title
    console.error title + err.stack.replace /.*?\n/, '\n'
    if err.cause? and config.cause.view
      level ?= 0
      if typeof err.cause is 'object'
        for entry in err.cause
          module.exports.report entry, level+1, err.codePart?
      else
        module.exports.report err.cause, level+1, err.codePart?
  else
    console.error err.toString().red.bold


# Helper methods
# -------------------------------------------------

# ### Overwrite internal stack trace formatting
#
# This function is part of the V8 stack trace API, for more info see:
# http://code.google.com/p/v8/wiki/JavaScriptStackTraceApi
prepareStackTrace = (err, stack) ->
  unless config.stack.view
    stack = stack[..1]
  message = err.toString()
  message = message.bold.red if config.colors
  return message + stack.map (frame) ->
    return '' unless config.stack.modules or !~frame.getFileName().indexOf '/node_modules/'
    return '' unless config.stack.system or ~frame.getFileName().indexOf '/'
    map = mapFrame frame
    out = "\n  at #{frame}"
    out += getCodeview frame unless map or config.code.all is false
    if map
      out += "\n     #{map}"
      out += getCodeview map
    return out
  .join ''

# ### Retrieve highlighted code display
getCodeview = (frame) ->
  return '' unless config.code.view
  return '' unless config.code.modules or !~frame.getFileName().indexOf '/node_modules/'
  contents = retrieveFile frame.getFileName()
  return '' unless contents
  lines = contents?.split /(?:\r\n|\r|\n)/
  out = ''
  max = lines.length.toString().length
  # lines before
  num = frame.getLineNumber() - 1 - config.code.before
  for i in [1..config.code.before]
    line = sprintf "\n     %0#{max}d: #{lines[num++]}", num
    out += if config.colors then line.grey else line
  # highlight line
  line = sprintf "\n     %0#{max}d: #{lines[num++]}", num
  if config.colors
    pos = frame.getColumnNumber() + max + 8
    out += line.slice(0, pos-1).yellow
    out += line.slice(pos-1, pos+2).yellow.underline
    out += line.slice(pos+2).yellow
  else
    out += line
  # lines after
  for i in [1..config.code.after]
    line = sprintf "\n     %0#{max}d: #{lines[num++]}", num
    out += if config.colors then line.grey else line
  out

# ### Get the mapped frame
mapFrame = (frame) ->
  # Most call sites will return the source file from getFileName(), but code
  # passed to eval() ending in "//# sourceURL=..." will return the source file
  # from getScriptNameOrSourceURL() instead
  source = frame.getFileName() || frame.getScriptNameOrSourceURL()
  if source
    position = mapSourcePosition(
      source: source
      line: frame.getLineNumber()
      column: frame.getColumnNumber()
    )
    return null unless position
    return (
      __proto__: frame
      getFileName: -> position.source
      getLineNumber: -> position.line
      getColumnNumber: -> position.column
      getScriptNameOrSourceURL: -> position.source
    )
  # Code called using eval() needs special handling
  origin = frame.isEval() and frame.getEvalOrigin()
  if origin
    origin = mapEvalOrigin(origin)
    return (
      __proto__: frame
      getEvalOrigin: ->
        origin
    )
  # If we get here then we were unable to change the source position
  null
# Maps a file path to a source map for that file
sourceMapCache = {};

# ### Find the mapped position
mapSourcePosition = (position) ->
  sourceMap = sourceMapCache[position.source]
  # retrieve source map
  unless sourceMap
    urlAndMap = retrieveSourceMap(position.source)
    if urlAndMap
      sourceMap = sourceMapCache[position.source] =
        url: urlAndMap.url
        map: new sourcemap.SourceMapConsumer(urlAndMap.map)
  # Resolve the source URL relative to the URL of the source map
  if sourceMap
    mapPosition = sourceMap.map.originalPositionFor position
    if mapPosition.source
      mapPosition.source = supportRelativeURL path.dirname(position.source), mapPosition.source
      return mapPosition
  null

# ### Get the sourcemap data
#
# Takes a
# generated source filename; returns a {map, optional url} object, or null if
# there is no source map.  The map field may be either a string or the parsed
# JSON object (ie, it must be a valid argument to the SourceMapConsumer
# constructor).
retrieveSourceMap = (source) ->
  # Get the URL of the source map
  fileData = retrieveFile(source)
  match = /\/\/[#@]\s*sourceMappingURL=(.*)\s*$/m.exec(fileData)
  return null  unless match
  sourceMappingURL = match[1]

  # Read the contents of the source map
  sourceMapData = undefined
  dataUrlPrefix = "data:application/json;base64,"
  if sourceMappingURL.slice(0, dataUrlPrefix.length).toLowerCase() is dataUrlPrefix
    # Support source map URL as a data url
    sourceMapData = new Buffer(sourceMappingURL.slice(dataUrlPrefix.length), "base64").toString()
  else
    # Support source map URLs relative to the source URL
    dir = path.dirname(source)
    sourceMappingURL = supportRelativeURL(dir, sourceMappingURL)
    sourceMapData = retrieveFile(sourceMappingURL, "utf8")
  return null  unless sourceMapData
  url: sourceMappingURL
  map: sourceMapData

# Maps a file path to a source map for that file
isInBrowser = -> typeof window isnt "undefined"

# ### Retrieve file for node and browser
retrieveFile = (path) ->
  return fileContentsCache[path]  if path of fileContentsCache
  try
    # Use AJAX if we are in the browser
    if isInBrowser()
      xhr = new XMLHttpRequest()
      xhr.open "GET", path, false
      xhr.send null
      contents = (if xhr.readyState is 4 then xhr.responseText else null)
    # Otherwise, use the filesystem
    else
      contents = fs.readFileSync path, "utf8"
  catch ex
    contents = null
  fileContentsCache[path] = contents
# Maps a file path to a string containing the file contents
fileContentsCache = {};

# ### Make path absolute
#
# Support URLs relative to a directory, but be careful about a protocol prefix
# in case we are in the browser (i.e. directories may start with "http://")
supportRelativeURL = (dir, url) ->
  match = /^\w+:\/\/[^\/]*/.exec(dir)
  protocol = (if match then match[0] else "")
  protocol + path.resolve dir.slice(protocol.length), url

# ### get Eval origin
#
# Parses code generated by FormatEvalOrigin(), a function inside V8:
# https://code.google.com/p/v8/source/browse/trunk/src/messages.js
mapEvalOrigin = (origin) ->
  # Most eval() calls are in this format
  match = /^eval at ([^(]+) \((.+):(\d+):(\d+)\)$/.exec(origin)
  if match
    position = mapSourcePosition(
      source: match[2]
      line: match[3]
      column: match[4]
    )
    return "eval at " + match[1] + " (" + position.source + ":" + position.line + ":" + position.column + ")"
  # Parse nested eval() calls using recursion
  match = /^eval at ([^(]+) \((.+)\)$/.exec(origin)
  return "eval at " + match[1] + " (" + mapEvalOrigin(match[2]) + ")"  if match
  # Make sure we still return useful information if we didn't find anything
  origin
