chai = require 'chai'
expect = chai.expect

describe "Error with cause reporting", ->

  object = require '../data/object.js'
  errorHandler = require '../../lib/index.js'
  errorHandler.install()
  config = errorHandler.config

  beforeEach ->
    config = errorHandler.config =
      colors: false
      # Define whether and which stack lines to show
      stack:
        view: false
        modules: false
        system: false
      # Define if and how much code to show
      code:
        view: false
        before: 0
        after: 0
        all: false
        modules: false
      # Display of the errors cause if there is one
      cause:
        view: false
        stack: false
      # Should command exit after an uncaught error is reported
      uncaught:
        exit: true
        timeout: 100
        code: 2

  describe "test object", ->
    it "can return an Error with cause", ->
      err = object.returnCause()
      expect(err).is.instanceof Error
      expect(err.cause).is.instanceof Error

  describe "using colors", ->
    it "no", ->
      err = object.returnCause()
      expect(errorHandler.format err).is.equal 'Error: Something went wrong'
    it "yes", ->
      err = object.returnError()
      config.colors = true
      expect(errorHandler.format err).is.equal '\u001b[31m\u001b[1mError: Something went wrong\u001b[22m\u001b[39m'

  describe "show cause", ->
    it "default", ->
      err = object.returnCause()
      config.cause.view = true
      msg = errorHandler.format err
      expect(msg).is.equal 'Error: Something went wrong\n  Caused by Error: root fault (somethere)'
      expect(msg.split(/\n/).length).is.equal 2
    it "for array", ->
      err = object.returnCauseArray()
      config.cause.view = true
      msg = errorHandler.format err
      expect(msg).is.equal 'Error: Something went wrong\n  Caused by Error: root fault 1 (somethere)\n  Caused by Error: root fault 2 (somethere)'
#      expect(msg.split(/\n/).length).is.equal 2
    it "for hash", ->
      err = object.returnCauseHash()
      config.cause.view = true
      msg = errorHandler.format err
      expect(msg).is.equal 'Error: Something went wrong\n  Caused by Error: root fault 1 (here)\n  Caused by Error: root fault 2 (there)'
#      expect(msg.split(/\n/).length).is.equal 2

  describe "show cause with stack", ->
    it "default", ->
      err = object.returnCause()
      config.stack.view = true
      config.cause.view = true
      config.cause.stack = true
      msg = errorHandler.format err
      expect(msg.split(/\n/).length).is.equal 8
