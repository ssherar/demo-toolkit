require("chai").should()
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

  it "foo bars", () ->
    1.should.equal(1)

  it "bar foos", () ->
    2.should.equal(2)
  
