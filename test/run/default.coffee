chai = require 'chai'
expect = chai.expect

describe "Default Error reporting", ->

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
    it "can return a simple Error", ->
      expect(object.returnError()).is.instanceof Error

  describe "using colors", ->
    it "no", ->
      err = object.returnError()
      expect(errorHandler.format err).is.equal 'Error: Something went wrong'
    it "yes", ->
      err = object.returnError()
      config.colors = true
      expect(errorHandler.format err).is.equal '\u001b[31m\u001b[1mError: Something went wrong\u001b[22m\u001b[39m'

  describe "with stack trace", ->
    it "default", ->
      err = object.returnError()
      config.stack.view = true
      msg = errorHandler.format err
      expect(msg.split(/\n/).length).is.equal 4
    it "including node_modules", ->
      err = object.returnError()
      config.stack.view = true
      config.stack.modules = true
      msg = errorHandler.format err
      expect(msg.split(/\n/).length).is.equal 12
    it "including system", ->
      err = object.returnError()
      config.stack.view = true
      config.stack.system = true
      msg = errorHandler.format err
      expect(msg.split(/\n/).length).is.equal 5
    it "including noide_modules and system", ->
      err = object.returnError()
      config.stack.view = true
      config.stack.modules = true
      config.stack.system = true
      msg = errorHandler.format err
      expect(msg.split(/\n/).length).is.equal 13

  describe "show code", ->
    it "line", ->
      err = object.returnError()
      config.stack.view = true
      config.code.view = true
      msg = errorHandler.format err
      expect(msg).to.have.string '08:   new Error "Something went wrong"'
      expect(msg.split(/\n/).length).is.equal 5
    it "line with colors", ->
      err = object.returnError()
      config.colors = true
      config.stack.view = true
      config.code.view = true
      msg = errorHandler.format err
      expect(msg).to.have.string '08:   new\u001b[39m\u001b[4m\u001b[33m Er\u001b[39m\u001b[24m\u001b[33mror "Something went wrong"\u001b[39m'
      expect(msg.split(/\n/).length).is.equal 5
    it "with context", ->
      err = object.returnError()
      config.stack.view = true
      config.code.view = true
      config.code.before = 2
      config.code.after = 2
      msg = errorHandler.format err
      expect(msg).to.have.string '08:   new Error "Something went wrong"'
      expect(msg.split(/\n/).length).is.equal 9
    it "for all lines", ->
      err = object.returnError()
      config.stack.view = true
      config.stack.modules = true
      config.code.view = true
      config.code.all = true
      msg = errorHandler.format err
      expect(msg).to.have.string '08:   new Error "Something went wrong"'
      expect(msg.split(/\n/).length).is.equal 14
    it "for node_modules stack, too", ->
      err = object.returnError()
      config.stack.view = true
      config.stack.modules = true
      config.code.view = true
      config.code.all = true
      config.code.modules = true
      msg = errorHandler.format err
      expect(msg).to.have.string '08:   new Error "Something went wrong"'
      expect(msg.split(/\n/).length).is.equal 22
