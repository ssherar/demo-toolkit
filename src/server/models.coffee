class Student
  constructor: (@user, @socket) ->
    @state = 0
    @room = "CS101"

  toJSON: () ->
    {
      user: @user
      state: @state
      room: @room
    }

module.exports =
  student: Student
