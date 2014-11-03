$ () ->
  $entryPage = $ "div#entry-page"
  $mainPage = $ "div#main-page"
  $roomPage = $ "div#room-choice"

  $username = $ "input#aber-username"
  $usernameSubmit = $ "button#username-submit"
  $signoffButton = $ "button#signoff"
  $choices = $ "div#choices"

  socket = io "/students"

  $usernameSubmit.on "click", () ->
    socket.emit "user added", $username.val()
    socket.on "user authenticated", (rooms) ->
      for room in rooms
        $tmp = $ "<button>"
        $tmp.on "click", (event) ->
          $ele = $ event.target
          socket.emit "joined room", $ele.text()
          $roomPage.addClass "hidden"
          $mainPage.removeClass "hidden"
        $tmp.html room
        $tmp.appendTo $choices
      $entryPage.addClass "hidden"
      $roomPage.removeClass "hidden"

  $signoffButton.on "click", () ->
    socket.emit "signoff requested", "true"
    $signoffButton.prop "disabled", true

  socket.on "user signedoff", () ->
    $signoffButton.prop "disabled", false


