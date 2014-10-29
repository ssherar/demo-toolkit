class Student
  constructor: (@user, @socket) ->
    @state = 0

  toJSON: () ->
    {
      user: @user
      state: @state
    }

module.exports =
  student: Student
