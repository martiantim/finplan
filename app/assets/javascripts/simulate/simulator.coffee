class Simulator
  constructor: (@family, @manipulators, @startAccounts, @dialog) ->
    @startYear = new Date().getYear()+1900
    @endYear = @family.endYear()
    
    @dialog.find('.close').hide()
    @dialog.find('#simulate_year_progress').progressbar({
      max: @endYear - @startYear + 1
    })
    @_markGoalProgress()    

  findManipulatorByName: (name) ->
    for m in @manipulators
      if m.template_name == name
        return m

  findAllManipulatorsByName: (name) ->
    arr = []
    for m in @manipulators
      if m.template_name == name
        arr.push(m)
    arr

  disable: (name) ->
    ms = @findAllManipulatorsByName(name)
    for m in ms
      m.setDisabled()

  enable: (name) ->
    ms = @findAllManipulatorsByName(name)
    for m in ms
      m.setEnabled()

  sim: (onDone) ->    
    that = this

    #TODO: this is broken
    @xtype = $('#xtype').attr('data-value')
    $('#xtype a').click =>
      $('#xtype').attr('data-value',$(this).attr('data-xtype'))
      @display()
    
    for m in @manipulators
      m.reset(that)
    
    @datasets = {
      'Cash': [],
      'Savings': [],
      'Retirement': [],
      'Total': [],
    }    

    @context = new SimContext(@startYear, @startAccounts, @family)
    
    that = this
    setTimeout =>
      @_runYear(onDone)
    , 1          
      
  _runYear: (onDone) ->
    @context.balances.earnFromInvestments(@context.oldestAdultAge())
    @context.balances.payLoans()
    for m in @manipulators
      m.adjustForInflation()
      m.exec(@context)

    #first income
#    for m in @manipulators
#      if m.kind == 'income'
#        m.exec(@context)
#
#
#    #pay expenses
#    @context.balances.payLoans()
#    for m in @manipulators
#      if m.kind == 'factor' || m.kind == 'hidden' #TODO: break out more. taxes, etc
#        m.exec(@context)
#
#    #goals
#    for m in @manipulators
#      if m.kind == 'goal'
#        m.exec(@context)
    
    @context.balances.rebalance()
    @context.balances.addYear()

    if @xtype == 'year'
      x = @context.simYear+'-01-01 4:00PM'
    else
      x = @context.family.members[0].ageInYear(@context.simYear)

    for name,set of @datasets
      set.push [x, @context.balances["get#{name}"]()]

    @dialog.find('#simulate_year_progress').progressbar("option", "value", @context.simYear - @startYear+1)
    @dialog.find('#current_simulate_year').html(@context.simYear)
    
    @context.nextSimYear(@manipulators)
    @_markGoalProgress()
    if @context.simYear <= @endYear
      setTimeout =>
        @_runYear(onDone)
      , 1
    else
      onDone()
      @_markGoals()
      @dialog.find('.close').show()
      @dialog.find('.close button').click =>
        @dialog.dialog('close')
  
  _markGoalProgress: ->
    num = 0
    achieved = 0
    for m in @manipulators
      if m.kind == 'goal'
        num++
        if m.goalAchieved()
          achieved++
          
    @dialog.find('#goal_progress span').html("#{achieved} of #{num}")
  
  _markGoals: ->
    for m in @manipulators
      if m.kind == 'goal'
        if m.goalAchieved()
          $('li.goal[data-id="'+m.id+'"] .achieved').html('<img src="'+Icons.GOAL_YES+'">')
        else
          $('li.goal[data-id="'+m.id+'"] .achieved').html('<img src="'+Icons.GOAL_NO+'">')
      
window.Simulator = Simulator