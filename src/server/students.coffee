Student = require("./models").student
utils = require "./utils"

module.exports = (adminSocket, studentSocket, users, config) ->
  studentSocket.on "connection", (socket) ->
    console.log "user connected"
    socket.authenticated = false

    socket.on "disconnect", () ->
      console.log "user disconnected"
      if socket.authenticated
        adminSocket.emit "user disconnected", users[socket.id].toJSON()
        delete users[socket.id]

    socket.on "user added", (username) ->
      return unless utils.findIdForUsername(username, users) == undefined
      console.log "user added: #{username}"
      socket.authenticated = true
      tmp = new Student username, socket
      users[socket.id] = tmp
      socket.emit "user authenticated", config.defaultRooms

    socket.on "joined room", (room) ->
      socket.join(room)
      users[socket.id].room = room
      adminSocket.emit "user connected", users[socket.id].toJSON()

    socket.on "signoff requested", () ->
      userObj = users[socket.id]
      userObj.state = 1
      adminSocket.emit "signoff requested", userObj.user


