utils = require "./utils"
Student = require("./models").student

module.exports = (adminSocket, studentSocket, users, config) ->
  adminSocket.on "connection", (socket) ->
    console.log "admin connected"
    socket.emit "show rooms", config.defaultRooms
    
    socket.on "change room", (roomName) ->
      for key,value of users
        adminSocket.emit("user connected", value) if value.room == roomName

    socket.on "user signedoff", (username) ->
      socketid = utils.findIdForUsername username, users
      user = users[socketid]
      user.state = 0
      user.socket.emit "user signedoff", true
      socket.broadcast.emit "admin signedoff user", username
    
    socket.on "logging in", (password) ->
      adminSocket.emit "admin authenticated", config.adminPassword == password
