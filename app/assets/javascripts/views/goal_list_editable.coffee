class GoalListEditable extends GoalList

  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'goals',
      editable: true
    })

  extraWireItem: (itemID) ->
    m = @plan.findManipulatorByID(itemID)
    if m && m.achievedYear
      @viewer().find('.goal_status').html('<div class="alert alert-success"><span class="glyphicon glyphicon-ok"></span> Congratulations! This goal will be achieved in '+m.achievedYear+'</div>')
    else if m && m.failMessage
      @viewer().find('.goal_status').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign"></span> '+m.failMessage + '</div>')

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