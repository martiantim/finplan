class Manipulator
  constructor: (@id, @name, @kind, @template_name, start, end, prms) ->
    @params = {}
    @achieved = false
    @enabled = true    
    if start
      @startYear = new Date(start).getYear()+1900 
    else
      @startYear = null
    if end
      @endYear = new Date(end).getYear()+1900 
    else
      @endYear = null
    
    for k,v of $.parseJSON(prms)
      if v.match(/\./)
        @params[k] = parseFloat(v)
      else
        @params[k] = parseInt(v)
  
  setDisabled: ->    
    @enabled = false
  
  reset: (sim) ->
    @curSim = sim
    @achieved = false
    @achievedYear = null
    @enabled = true    
    @failMessage = null
  
  setGoalAchieved: (year) ->    
    @achievedYear = year
    @achieved = true
  
  setGoalFailureMessage: (msg) ->    
    @failMessage = msg
  
  goalAchieved: ->
    @achieved
  
  inRange: (year) ->
    
    return false if @startYear && year < @startYear
    return false if @endYear && year > @endYear
    
    true
  
  disable: (name) ->
    @curSim.disable(name)
  
  exec: (balances) ->
    if @kind == 'goal'
      if !@goalAchieved()
        if @inRange(balances._currentYear())
          if @canAchieve(balances)
            @setGoalAchieved(balances._currentYear())
            
      if @goalAchieved() && @enabled
        @execOne(balances)
    else
      if @enabled
        @execOne(balances)
  
  @fromJSON: (json) ->
    m = new Manipulator(json.id, json.name, json.kind, json.template_name, json.start, json.end, json.params);
    
    func = "m.canAchieve = function(balances) { "+json.can_formula+"}"    
    eval(func)
    
    func = "m.execOne = function(balances) { "+json.formula+"}"
    eval(func)
    m
    
  
window.Manipulator = Manipulator