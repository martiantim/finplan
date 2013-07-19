class Manipulator
  constructor: (@name, @startYear, @endYear, prms) ->
    @params = {}
    @achieved = false
    
    for k,v of $.parseJSON(prms)
      @params[k] = parseInt(v)
  
  reset: ->
    @achieved = false
  
  setGoalAchieved: ->
    @achieved = true
    
  goalAchieved: ->
    @achieved
  
  inRange: (year) ->
    return false if @startYear && year < @startYear
    return false if @endYear && year > @endYear
    
    true
  
  @fromJSON: (json) ->
    m = new Manipulator(json.name, json.start, json.end, json.params);
    
    func = "m.exec = function(balances) { "+json.formula+"}"    
    eval(func)
    m
    
  
window.Manipulator = Manipulator