chai = require 'chai'
expect = chai.expect
winston = require 'winston'

describe "Report error", ->

  object = require '../data/object.js'
  errorHandler = require '../../src/index.js'
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
  # define a specific logger
  logger: null


  describe "default", ->
    err = object.returnString()
    it "to console error", ->
      errorHandler.report err

  describe "using logger", ->
    it "to console as error", ->
      errorHandler.config.logger = new winston.Logger
        transports: [
          new winston.transports.Console()
        ]
      err = object.returnString()
      errorHandler.report err
    it "to console as info", ->
      errorHandler.config.logger = new winston.Logger
        transports: [
          new winston.transports.Console()
        ]
      err = object.returnString()
      errorHandler.report err, 'info'
