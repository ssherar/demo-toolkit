class Student
  constructor: (@user, @socket) ->
    @state = 0
    @room = null

  toJSON: () ->
    {
      user: @user
      state: @state
      room: @room
    }

module.exports =
  student: Student
