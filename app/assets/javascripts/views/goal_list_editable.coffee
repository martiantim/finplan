class GoalListEditable extends GoalList

  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'goals',
      editable: true,
      showFirst: true
    })

  extraWireItem: (itemID) ->
    @_setValidAges()
    @viewer().find('#when_person').change =>
      @_setValidAges()

    m = @plan.findManipulatorByID(itemID)
    if m && m.achievedYear
      @viewer().find('.goal_status').html('<div class="alert alert-success"><span class="glyphicon glyphicon-ok"></span> Congratulations! This goal will be achieved in '+m.achievedYear+'</div>')
    else if m && m.failMessage
      @viewer().find('.goal_status').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign"></span> '+m.failMessage + '</div>')

  _setValidAges: ->
    person = @plan.family.findByID(parseInt(@viewer().find('#when_person').val()))
    return if !person
    start_age = person.ageInYear(finData['current_year'])
    start_age = 0 if start_age < 0
    end_age = person.projectedLongevity()

    ages = @viewer().find('#when_age')
    curSelected = ages.val()
    curValid = false
    ages.html('')
    for age in [start_age..end_age]
      ages.append($("<option value='#{age}'>#{age}</option>"))
      curValid = true if age == parseInt(curSelected)

    if curSelected && curValid
      ages.val(curSelected)

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