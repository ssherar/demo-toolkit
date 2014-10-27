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
  constructor: (@user) ->
    @state = 0


users = {}

admin = io.of "/admin"
students = io.of "/students"

admin.on "connection", (socket) ->
  console.log "admin connected"
  for key,value of users
    admin.emit "user connected", value

students.on "connection", (socket) ->
  console.log "user connected"

  socket.on "disconnect", () ->
    console.log "user disconnected"
    admin.emit "user disconnected", users[socket.id]
    delete users[socket.id]

  socket.on "user added", (username) ->
    console.log "user added: #{username}"
    tmp = new Student username
    users[socket.id] = tmp
    admin.emit "user connected", tmp

  socket.on "signoff requested", () ->
    userObj = users[socket.id]
    userObj.state = 1
    admin.emit "signoff requested", userObj.user

http.listen 3000, () ->
  console.log("Listening on *:3000")

