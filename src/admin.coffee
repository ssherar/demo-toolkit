$ () ->
  socket = io "/admin"
  users = {}
  
  $pageAuthentication = $ "div#admin-authenticate"
  $pageUsers = $ "div#list-users"

  $adminPassword = $ "input#admin-password"
  $passwordSubmit = $ "button#password-submit"
  $connectedUsers = $ "ul#connected-users"
  $signoffUsers = $ "ol#signoff-users"

  moveUser = (event) ->
    $ele = $ event.target
    return unless $ele.parent().is $signoffUsers
    $ele.remove()
    $ele.appendTo $connectedUsers
    socket.emit "user signedoff", $ele.text()

  $passwordSubmit.on "click", () ->
    $pageAuthentication.addClass "hidden"
    $pageUsers.removeClass "hidden"

  socket.on "user connected", (userObj) ->
    $ele = $("<li>").html userObj.user
    $ele.on "click", moveUser
    users[userObj.user] = $ele
    switch userObj.state
      when 0 then $ele.appendTo $connectedUsers
      when 1 then $ele.appendTo $signoffUsers
    null

  socket.on "user disconnected", (userObj) ->
    users[userObj.user].remove()
    delete users[userObj.user]
    null
  
  socket.on "signoff requested", (username) ->
    $ele = users[username]
    $ele.remove()
    $ele.appendTo $signoffUsers
