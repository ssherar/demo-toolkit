utils = require "./utils"

module.exports = (adminSocket, studentSocket, users) ->
  adminSocket.on "connection", (socket) ->
    console.log "admin connected"
    for key,value of users
      adminSocket.emit "user connected", value

    socket.on "user signedoff", (username) ->
      socketid = utils.findIdForUsername username, users
      user = users[socketid]
      user.state = 0
      user.socket.emit "user signedoff", true

