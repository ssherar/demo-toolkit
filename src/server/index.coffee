express = require 'express'
app = express()
http = require("http").Server app
io = require("socket.io")(http)
path = require "path"
fs = require "fs"

basedir = path.resolve "#{__dirname}/../"
config = JSON.parse fs.readFileSync("#{basedir}/config.json")

app.use "/static", express.static("#{basedir}/bower_components")
app.use "/js", express.static("#{basedir}/js")
app.use "/css", express.static("#{basedir}/css")

app.get "/", (req, res) ->
  res.sendFile "#{basedir}/templates/index.html"

app.get "/admin", (req, res) ->
  res.sendFile "#{basedir}/templates/admin.html"

users = {}

admin = io.of "/admin"
students = io.of "/students"

require("./admin")(admin, students, users)
require("./students")(admin, students, users)

http.listen config.port, () ->
  console.log("Listening on *:#{config.port}")

