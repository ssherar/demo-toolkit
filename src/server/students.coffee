Student = require("./models").student

module.exports = (adminSocket, studentSocket, users) ->
  studentSocket.on "connection", (socket) ->
    console.log "user connected"
    socket.authenticated = false

    socket.on "disconnect", () ->
      console.log "user disconnected"
      if socket.authenticated
        adminSocket.emit "user disconnected", users[socket.id].toJSON()
        delete users[socket.id]

    socket.on "user added", (username) ->
      console.log "user added: #{username}"
      socket.authenticated = true
      tmp = new Student username, socket
      users[socket.id] = tmp
      adminSocket.emit "user connected", tmp.toJSON()
      socket.emit "user authenticated", true

    socket.on "signoff requested", () ->
      userObj = users[socket.id]
      userObj.state = 1
      adminSocket.emit "signoff requested", userObj.user


