class Simulator
  constructor: (@user, @manipulators, @startAccounts, @dialog) ->
    @startYear = new Date().getYear()+1900
    @age = 34  #TODO: use age from user object
    @endYear = @startYear + (85-@age)
    
    @dialog.find('.close').hide()
    @dialog.find('#simulate_year_progress').progressbar({
      max: @endYear - @startYear + 1
    })
    @_markGoalProgress()    
    
  disable: (name) ->    
    for m in @manipulators
      if m.template_name == name        
        m.setDisabled()
    
  sim: (onDone) ->    
    that = this
    age = 34  #TODO: use age from user object
    
    @xtype = $('#xtype').attr('data-value')    
    
    for m in @manipulators
      m.reset(that)
    
    @datasets = {
      'Cash': [],
      'Savings': [],
      'Retirement': [],
      'Total': [],
    }    
    
    @balances = new Balances(@startAccounts, {age: age, year: @startYear})
    
    @simYear = @startYear
    that = this
    setTimeout =>
      @_runYear(onDone)
    , 1          
      
  _runYear: (onDone) ->
    for m in @manipulators
      m.exec(@balances)
    @balances.rebalance()
    @balances.addYear()

    if @xtype == 'year'
      x = @simYear+'-01-01 4:00PM'
    else
      x = @age + @simYear - @startYear

    for name,set of @datasets
      set.push [x, @balances["get#{name}"]()]

    @dialog.find('#simulate_year_progress').progressbar("option", "value", @simYear - @startYear+1)
    @dialog.find('#current_simulate_year').html(@simYear)
    
    @simYear++
    @_markGoalProgress()
    if @simYear <= @endYear
      setTimeout =>
        @_runYear(onDone)
      , 25
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