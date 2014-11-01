$ () ->
  socket = io "/admin"
  users = {}
  rooms = {}
  currentRoom = null
  
  $pageAuthentication = $ "div#admin-authenticate"
  $pageUsers = $ "div#list-users"
  $manageRooms = $ "div#manage-rooms"

  $adminPassword = $ "input#admin-password"
  $passwordSubmit = $ "button#password-submit"
  $connectedUsers = $ "ul#connected-users"
  $signoffUsers = $ "ol#signoff-users"
  $backButton = $ "button#nav-back"
  $roomList = $ "div#rooms"

  moveUser = (event) ->
    $ele = $ event.target
    return unless $ele.parent().is $signoffUsers
    $ele.detach()
    $ele.appendTo $connectedUsers
    socket.emit "user signedoff", $ele.text()

  $passwordSubmit.on "click", () ->
    socket.on "admin authenticated", (ret) ->
      return unless ret == true
      $pageAuthentication.addClass "hidden"
      #$pageUsers.removeClass "hidden"
      $manageRooms.removeClass "hidden"

    socket.emit "logging in", $adminPassword.val()

  socket.on "user connected", (userObj) ->
    return unless currentRoom == userObj.room
    $ele = $("<li>").html userObj.user
    $ele.on "click", moveUser
    users[userObj.user] = $ele
    switch userObj.state
      when 0 then $ele.appendTo $connectedUsers
      when 1 then $ele.appendTo $signoffUsers
    null

  socket.on "show rooms", (roomArray) ->
    for room in roomArray
      $tmp = $ "<button>"
      $tmp.on "click", (event) ->
        $ele = $ event.target
        room = $ele.text()
        socket.emit "change room", room
        $manageRooms.addClass "hidden"
        $pageUsers.removeClass "hidden"
        currentRoom = room
      $tmp.html room
      $tmp.appendTo $roomList
      rooms[room] = $tmp

  socket.on "user disconnected", (userObj) ->
    return unless currentRoom == userObj.room
    users[userObj.user].remove()
    delete users[userObj.user]
    null
  
  socket.on "signoff requested", (username) ->
    $ele = users[username]
    $ele.detach()
    $ele.appendTo $signoffUsers

  socket.on "admin signedoff user", (username) ->
    $ele = users[username]
    $ele.detach()
    $ele.appendTo $connectedUsers

  $backButton.on "click", (event) ->
    for user,$ele of users
      $ele.remove()
      delete users[user]
    $pageUsers.addClass "hidden"
    $manageRooms.removeClass "hidden"
