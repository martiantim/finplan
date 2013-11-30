class GoalList extends NiceList
  constructor: (@el, @options) ->
    super(@el, @options)

  markAllUnknown: ->
    @wrapper.find('ul .item .achieved').html('<img src="'+Icons.GOAL_MAYBE+'">')
  

window.GoalList = GoalList