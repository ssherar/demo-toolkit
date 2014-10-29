utils = require "./utils"

module.exports = (adminSocket, studentSocket, users, config) ->
  adminSocket.on "connection", (socket) ->
    console.log "admin connected"
    for key,value of users
      adminSocket.emit "user connected", value

    socket.on "user signedoff", (username) ->
      socketid = utils.findIdForUsername username, users
      user = users[socketid]
      user.state = 0
      user.socket.emit "user signedoff", true
    
    socket.on "logging in", (password) ->
      adminSocket.emit "admin authenticated", config.adminPassword == password
