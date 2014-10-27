$ () ->
  socket = io "/admin"
  users = {}
  
  $pageAuthentication = $ "div#admin-authenticate"
  $pageUsers = $ "div#list-users"

  $adminPassword = $ "input#admin-password"
  $passwordSubmit = $ "button#password-submit"
  $connectedUsers = $ "ul#connected-users"
  $signoffUsers = $ "ol#signoff-users"

  $passwordSubmit.on "click", () ->
    $pageAuthentication.addClass "hidden"
    $pageUsers.removeClass "hidden"

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
    $ele.appendTo $signoffUsers
