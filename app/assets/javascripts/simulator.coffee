class Simulator
  constructor: (@user, @manipulators) ->
    @startYear = new Date().getYear()+1900
    
  disable: (name) ->    
    for m in @manipulators
      if m.template_name == name        
        m.setDisabled()
    
  sim: ->    
    that = this
    age = 34  #TODO: use age from user object
    endYear = @startYear + (85-age)
    @xtype = $('#xtype').attr('data-value')    
    
    for m in @manipulators
      m.reset(that)
    
    @datasets = {
      'Cash': [],
      'Savings': [],
      'Retirement': [],
      'Total': [],
    }    
    
    @balances = new Balances({age: age, year: @startYear})
    for year in [@startYear..endYear]
      for m in @manipulators
        m.exec(@balances)      
      @balances.rebalance()
      @balances.addYear()
      
      if @xtype == 'year'
        x = year+'-01-01 4:00PM'
      else
        x = age + year - @startYear
      
      for name,set of @datasets
        set.push [x, @balances["get#{name}"]()]
    
    for m in @manipulators
      if m.kind == 'goal'
        if m.goalAchieved()
          $('li.goal[data-id="'+m.id+'"] .achieved').html('<img src="'+Icons.GOAL_YES+'">')
        else
          $('li.goal[data-id="'+m.id+'"] .achieved').html('<img src="'+Icons.GOAL_NO+'">')
      
window.Simulator = Simulator