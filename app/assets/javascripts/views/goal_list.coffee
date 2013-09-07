class GoalList extends NiceList
  constructor: (@wrapper, @plan) ->    
    that = this
    super(@wrapper, {
      click: (itemID) ->
        that.showGoal itemID       
    })    
  
  markAllUnknown: ->
    @wrapper.find('ul .item .achieved').html('<img src="'+Icons.GOAL_MAYBE+'">')
  
  reload: ->    
    that = this
    $.ajax({
      url: "/goals",
      type: 'GET',
      data: {'plan_id': @plan.id},
      success: (data) ->
        that.wrapper.html data
        that.rewire()
    })
    
  

window.GoalList = GoalList