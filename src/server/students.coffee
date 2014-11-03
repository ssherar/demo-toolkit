Student = require("./models").student
utils = require "./utils"

module.exports = (adminSocket, studentSocket, users, config) ->
  studentSocket.on "connection", (socket) ->
    utils.log "student", "user connected #{socket.id}"
    socket.authenticated = false

    socket.on "disconnect", () ->
      utils.log "student", "user #{socket.id} disconnected"
      if socket.authenticated
        adminSocket.emit "user disconnected", users[socket.id].toJSON()
        delete users[socket.id]

    socket.on "user added", (username) ->
      return unless utils.findIdForUsername(username, users) == undefined
      utils.log "student", "user added: #{username} | #{socket.id}"
      socket.authenticated = true
      tmp = new Student username, socket
      users[socket.id] = tmp
      socket.emit "user authenticated", config.defaultRooms

    socket.on "joined room", (room) ->
      utils.log "student", "user #{socket.id} joined #{room}"
      socket.join(room)
      users[socket.id].room = room
      adminSocket.emit "user connected", users[socket.id].toJSON()

    socket.on "signoff requested", () ->
      utils.log "student", "user #{socket.id} requesting signoff"
      userObj = users[socket.id]
      userObj.state = 1
      adminSocket.emit "signoff requested", userObj.user


