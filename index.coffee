express = require 'express'
app = express()
http = require("http").Server app
io = require("socket.io")(http)
path = require "path"

basedir = path.resolve "#{__dirname}/../"

app.use "/static", express.static("#{basedir}/bower_components")
app.use "/js", express.static("#{basedir}/js")
app.use "/css", express.static("#{basedir}/css")

app.get "/", (req, res) ->
  res.sendFile "#{basedir}/templates/index.html"

app.get "/admin", (req, res) ->
  res.sendFile "#{basedir}/templates/admin.html"


class Student
  constructor: (@user, @socket) ->
    @state = 0

  toJSON: () ->
    {
      user: @user
      state: @state
    }


users = {}

findIdForUsername = (username) ->
  (id for id,value of users when value.user == username )[0]

admin = io.of "/admin"
students = io.of "/students"

admin.on "connection", (socket) ->
  console.log "admin connected"
  for key,value of users
    admin.emit "user connected", value

  socket.on "user signedoff", (username) ->
    socketid = findIdForUsername username
    user = users[socketid]
    user.state = 0
    user.socket.emit "user signedoff", true


students.on "connection", (socket) ->
  console.log "user connected"
  socket.authenticated = false

  socket.on "disconnect", () ->
    console.log "user disconnected"
    if socket.authenticated
      admin.emit "user disconnected", users[socket.id].toJSON()
      delete users[socket.id]

  socket.on "user added", (username) ->
    console.log "user added: #{username}"
    socket.authenticated = true
    tmp = new Student username, socket
    users[socket.id] = tmp
    admin.emit "user connected", tmp.toJSON()
    socket.emit "user authenticated", true

  socket.on "signoff requested", () ->
    userObj = users[socket.id]
    userObj.state = 1
    admin.emit "signoff requested", userObj.user

http.listen 3000, () ->
  console.log("Listening on *:3000")

