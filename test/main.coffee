chai = require("chai")
should = chai.should()
expect = chai.expect
clientio = require "socket.io-client"

socketOptions =
  transports: ['websocket']
  'force new connection': true
  "reconnection delay": 0
  "reopen delay": 0

socket = null

describe "index.coffee", () ->
  
  beforeEach (done) ->
    socket = clientio.connect "http://localhost:3000/students", socketOptions
    socket.on "connect", () ->
      done()

  afterEach (done) ->
    socket.disconnect()
    done()

  it "should return if connected", () ->
    socket.on "connect", () ->
      done()

  it "should return true if user has authenticated correctly", (done) ->
    name = "abc1"

    socket.on "user authenticated", (ret) ->
      expect(ret).equal(true)
      done()

    socket.emit "user added", name
  
