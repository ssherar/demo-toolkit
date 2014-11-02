utils = require "./utils"
Student = require("./models").student

module.exports = (adminSocket, studentSocket, users, config) ->
  adminSocket.on "connection", (socket) ->
    console.log "admin connected"
    socket.emit "show rooms", config.defaultRooms
    
    socket.on "change room", (roomName) ->
      socket.join(roomName)
      for key,value of users
        adminSocket.emit("user connected", value) if value.room == roomName

    socket.on "user signedoff", (userObj) ->
      socketid = utils.findIdForUsername userObj.user, users
      user = users[socketid]
      user.state = 0
      user.socket.emit "user signedoff", true
      socket.broadcast.to(userObj.room).emit "admin signedoff user", userObj.user
    
    socket.on "logging in", (password) ->
      adminSocket.emit "admin authenticated", config.adminPassword == password
