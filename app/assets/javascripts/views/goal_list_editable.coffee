class GoalListEditable extends GoalList

  showGoal: (itemID) ->
    that = this    
    @viewer().load "/goals/#{itemID}?plan_id=#{@plan.id}", ->
      m = that.plan.findManipulatorByID(itemID)
      if m && m.achievedYear
        that.viewer().find('.goal_status').html('<span class="ui-icon ui-icon-info"></span> Will achieve in '+m.achievedYear)
      else if m && m.failMessage
        that.viewer().find('.goal_status').html('<span class="ui-icon ui-icon-alert"></span> '+m.failMessage)
    
      that.viewer().find('button.remove').click ->
        that.removeGoal itemID
        false
      
      that.viewer().find('form').on 'ajax:success', (event, xhr, status) ->  
        plan.markDirty(true)
        that.reload()

  removeGoal: (itemID) ->
    that = this
    $.ajax({
      url: "/goals/#{itemID}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        that.viewer().html('')
        that.reload()
        plan.markDirty(true)
      ,error: (request) ->      
        showMessageDialog('error', request.responseText);
      
    })
    
window.GoalListEditable = GoalListEditable