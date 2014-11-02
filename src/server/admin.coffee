utils = require "./utils"
Student = require("./models").student

module.exports = (adminSocket, studentSocket, users, config) ->
  adminSocket.on "connection", (socket) ->
    utils.log "admin", "admin connected #{socket.id}"
    socket.emit "show rooms", config.defaultRooms
    
    socket.on "change room", (roomName) ->
      utils.log "admin", "admin #{socket.id} moving to #{roomName}"
      socket.join(roomName)
      for key,value of users
        socket.emit("user connected", value) if value.room == roomName
    
    socket.on "leave room", (roomName) ->
      utils.log "admin", "admin #{socket.id} leaving room #{roomName}"
      socket.leave(roomName)

    socket.on "user signedoff", (userObj) ->
      utils.log "admin", "admin #{socket.id} signing off user #{userObj}"
      socketid = utils.findIdForUsername userObj.user, users
      user = users[socketid]
      user.state = 0
      user.socket.emit "user signedoff", true
      socket.broadcast.to(userObj.room).emit "admin signedoff user", userObj.user
    
    socket.on "logging in", (password) ->
      utils.log "admin", "admin #{socket.id} attempting to authenticate"
      socket.emit "admin authenticated", config.adminPassword == password
