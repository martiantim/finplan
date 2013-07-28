class Manipulator
  constructor: (@id, @name, @kind, @template_name, @startYear, @endYear, prms) ->
    @params = {}
    @achieved = false
    @enabled = true
    
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
    @enabled = true
  
  setGoalAchieved: ->
    @achieved = true
    
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
        if @canAchieve(balances)
          @setGoalAchieved()          
            
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