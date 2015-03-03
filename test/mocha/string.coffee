chai = require 'chai'
expect = chai.expect

describe "String reporting", ->

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
        modules: false
        all: false
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
    it "can return a string", ->
      expect(object.returnString()).is.equal 'Something went wrong'

  describe "for strings", ->
    err = object.returnString()
    it "can format the message", ->
      expect(errorHandler.format err).is.equal 'Error: Something went wrong'
    it "can format the message with colors", ->
      config.colors = true
      expect(errorHandler.format err).is.equal '\u001b[1m\u001b[31mError: Something went wrong\u001b[39m\u001b[22m'
