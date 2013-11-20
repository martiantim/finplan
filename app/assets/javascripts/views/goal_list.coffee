class GoalList extends NiceList
  constructor: (@el, @options) ->
    super(@el, @options)

  markAllUnknown: ->
    @wrapper.find('ul .item .achieved').html('<img src="'+Icons.GOAL_MAYBE+'">')
  
  reload: ->    
    that = this
    $.ajax({
      url: "/goals",
      type: 'GET',
      data: {'plan_id': @plan.id, editable: @editable},
      success: (data) ->
        that.wrapper.html data
        that.rewire()
    })
    
  

window.GoalList = GoalList