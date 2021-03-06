class Simulator
  constructor: (@scenario, familyIn, @manipulators, @startAccounts, @dialog) ->
    @family = familyIn.dupe()
    @startYear = new Date().getYear()+1900

    @goalStatus = {}
    @_markGoalProgress()    

  findManipulatorByName: (name) ->
    for m in @manipulators
      if m.template_name == name
        return m

  goalEndYear: ->
    @family.endYear()

  endYear: ->
    @context.simYear

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
    if name == 'Housing' #special case for owned house
      houseValue = ms[0].cpiAdjustedParams['house_value']
      if houseValue
        @context.balances.addCash(houseValue, null, "Living", "Home Sale", {skip_income: true}) #XXX: really might need to pay some taxes

  enable: (name) ->
    ms = @findAllManipulatorsByName(name)
    for m in ms
      m.setEnabled()

  sim: (onDone) ->    
    that = this

    progressBar = @dialog.find('#simulate_year_progress')
    progressBar.removeClass('progress-bar-danger')
    progressBar.removeClass('progress-bar-success')

    #TODO: this is broken
    @xtype = $('#xtype').attr('data-value')
    $('#xtype a').click =>
      $('#xtype').attr('data-value',$(this).attr('data-xtype'))
      @display()
    
    for m in @manipulators
      m.reset(that)
    
    @datasets = {
      'Savings': [],
      'Retirement': [],
      'Loans': [],
      'Net Worth': [],
    }

    @context = new SimContext(@scenario, @startYear, @startAccounts, @family)
    if @context.isScenario('extra_baby')
      @family.addUnexpected()

    that = this
    setTimeout =>
      @_runYear(onDone)
    , 1          
      
  _runYear: (onDone) ->
    try
      @_runYearCanRaise(onDone)
    catch ex
      console.log(ex.stack)
      @_onDone(ex)
      onDone(ex)


  _runYearCanRaise: (onDone) ->
    @context.family.membersOfYear(@context.simYear, (u, desc) =>
      if u.ageInYear(@context.simYear) == 0
        @context.balances.curLog().log("event", "#{u.name} is born!", 0)
    )

    @context.balances.earnFromInvestments(@context.markets)
    @context.balances.payLoans()
    for m in @manipulators
      m.adjustForInflation(@context.markets.rate('Inflation'))
      m.exec(@context)
    
    @context.balances.rebalance()
    @context.balances.addYear()

    if @xtype == 'year'
      x = @context.simYear+'-01-01 4:00PM'
    else
      x = @context.family.members[0].ageInYear(@context.simYear)

    for name,set of @datasets
      set.push [x, @context.balances["get#{name.replace(' ', '_')}"]()]

    percentDone = (@context.simYear - @startYear)/(@goalEndYear() - @startYear)*100
    @dialog.find('#simulate_year_progress').css('width', percentDone+'%')

    @dialog.find('#current_simulate_year').html(@context.simYear)
    
    @context.nextSimYear(@manipulators)
    @_markGoalProgress()
    if @context.simYear <= @goalEndYear()
      setTimeout =>
        @_runYear(onDone)
      , 1
    else
      @_onDone()
      onDone()

  _onDone: (ex) ->
    @_markGoals()

    progressBar = @dialog.find('#simulate_year_progress')
    progressBar.css('width', '100%')
    if ex
      progressBar.addClass('progress-bar-danger')
    else
      progressBar.addClass('progress-bar-success')
    progressBar.parent().removeClass('active')
    @dialog.find('#simyear label').html('Simulation Finished')
    @dialog.find('.sim_done button').removeClass('disabled')
    @dialog.find('.sim_done button').click =>
      @dialog.modal('hide')
  
  _markGoalProgress: ->
    @dialog.find('#goal_progress span').html(@goalProgress())

  goalProgress: ->
    num = 0
    achieved = 0
    for m in @manipulators
      if m.kind == 'goal'
        num++
        if m.goalAchieved()
          achieved++
          
    "#{achieved} of #{num}"
  
  _markGoals: ->
    @goalsAchieved = 0
    @goalsTotal = 0
    for m in @manipulators
      if m.kind == 'goal'
        @goalsTotal += 1
        @goalStatus[m.id] = m.goalStatus()

        if m.goalAchieved()
          @goalsAchieved++
          $('li.goal[data-id="'+m.id+'"] .achieved').attr('data-success', 'true').html('<span class="glyphicon glyphicon-ok"></span>')
        else
          $('li.goal[data-id="'+m.id+'"] .achieved').attr('data-success', 'false').html('<span class="glyphicon glyphicon-remove"></span>')
      
window.Simulator = Simulator