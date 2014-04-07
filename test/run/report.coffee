chai = require 'chai'
expect = chai.expect

describe "Report error to console", ->

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
        exit: false
        timeout: 100
        code: 2

  describe "for strings", ->
    err = object.returnString()
    it "manuel", ->
      errorHandler.report err
#    it "uncaught", ->
#      throw err