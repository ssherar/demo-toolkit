module.exports =
  fineIdForUsername: (username, users) ->
    (id for id,value of users when value.user == username)[0]
