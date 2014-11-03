util = require "util"

module.exports =
  findIdForUsername: (username, users) ->
    (id for id,value of users when value.user == username)[0]
  log: (location, message) ->
    util.log "[#{location}] - #{message}"
