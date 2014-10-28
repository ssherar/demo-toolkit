$ () ->
  $entryPage = $ "div#entry-page"
  $mainPage = $ "div#main-page"

  $username = $ "input#aber-username"
  $usernameSubmit = $ "button#username-submit"
  $signoffButton = $ "button#signoff"

  socket = io "/students"

  $usernameSubmit.on "click", () ->
    socket.emit "user added", $username.val()
    $entryPage.addClass "hidden"
    $mainPage.removeClass "hidden"

  $signoffButton.on "click", () ->
    socket.emit "signoff requested", "true"
    $signoffButton.prop "disabled", true

  socket.on "user signedoff", () ->
    $signoffButton.prop "disabled", false


