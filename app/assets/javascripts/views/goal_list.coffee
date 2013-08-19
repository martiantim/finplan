class GoalList extends NiceList
  constructor: (@wrapper, @plan) ->    
    that = this
    super(@wrapper, {
      click: (itemID) ->
        that.showGoal itemID       
    })    
    
  viewer: ->
    $('#goal_options > div')    

  showGoal: (itemID) ->
    that = this    
    @viewer().load "/manipulators/#{itemID}?plan_id=#{@plan.id}", ->
      m = that.plan.findManipulatorByID(itemID)
      if m && m.achievedYear
        that.viewer().find('.goal_status').html('<span class="ui-icon ui-icon-info"></span> Will achieve in '+m.achievedYear)
      else if m && m.failMessage
        that.viewer().find('.goal_status').html('<span class="ui-icon ui-icon-alert"></span> '+m.failMessage)
    
      that.viewer().find('button.remove').click ->
        that.removeGoal itemID
        false
      
      that.viewer().find('form').on 'ajax:success', (event, xhr, status) ->  
        that.reload()

  reload: ->    
    that = this
    $.ajax({
      url: "/manipulators/goals",
      type: 'GET',
      data: {'plan_id': @plan.id},
      success: (data) ->
        that.wrapper.html data
        that.rewire()
    })
    
  removeGoal: (itemID) ->
    that = this
    $.ajax({
      url: "/manipulators/#{itemID}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        that.viewer().html('')
        that.reload()
      ,error: (request) ->      
        showMessageDialog('error', request.responseText);
      
    })

window.GoalList = GoalList