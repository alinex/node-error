chai = require 'chai'
expect = chai.expect

object = require '../data/object.js'
errorHandler = require '../../lib/index.js'
errorHandler.install()
describe "Basic error handling", ->
  describe "When object is used", ->
    it "should return an error", ->
      expect(object.returnError()).is.instanceof Error
  describe "Error handler", ->
    it "should be available", ->
      expect(errorHandler).to.be.an 'object'
    it "should report error", ->
      err = object.returnError()
      expect(err).is.instanceof Error
      console.log errorHandler
#      console.log errorHandler.report err
      console.log '----------------'
      expect(errorHandler.toString err).to.be.an 'object'
