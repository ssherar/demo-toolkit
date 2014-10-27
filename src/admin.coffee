$ () ->
  socket = io "/admin"
  users = {}
  $connectedUsers = $ "ul#connected-users"
  $signoffUsers = $ "ol#signoff-users"

  socket.on "user connected", (userObj) ->
    $ele = $("<li>").html userObj.user
    users[userObj.user] = $ele
    switch userObj.state
      when 0 then $ele.appendTo $connectedUsers
      when 1 then $ele.appendTo $signoffUsers

    null
  
  socket.on "signoff requested", (username) ->
    $ele = users[username]
    $ele.remove()
    $ele.appendTo "$signoffUsers"
