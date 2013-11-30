class GoalListEditable extends GoalList

  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'goals',
      editable: true
    })

  extraWireItem: (itemID) ->
    m = @plan.findManipulatorByID(itemID)
    if m && m.achievedYear
      @viewer().find('.goal_status').html('<span class="ui-icon ui-icon-info"></span> Will achieve in '+m.achievedYear)
    else if m && m.failMessage
      @viewer().find('.goal_status').html('<span class="ui-icon ui-icon-alert"></span> '+m.failMessage)

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