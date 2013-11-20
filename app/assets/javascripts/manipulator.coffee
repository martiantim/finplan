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
      else if v.match(/^\$\d+/)
        @params[k] = parseInt(v.replace(',','').substring(1))
      else if v.match(/\d/)
        @params[k] = parseInt(v)
      else
        @params[k] = v
  
  setDisabled: ->    
    @enabled = false
  
  reset: (sim) ->
    @curSim = sim
    @achieved = false
    @achievedYear = null
    @enabled = true    
    @failMessage = null
    @tempParams = {}
    @progress = []
  
  setGoalProgress: (year, have, need) ->
    if !@inRange(@curSim.simYear)
      need = null
    @progress.push [year, {have: have, need: need}]
  
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
  
  exec: (context) ->
    if @kind == 'goal'
      if !@goalAchieved()
        if @inRange(context.simYear)
          if @checkStatus(context)
            @doIt(context)
            @setGoalAchieved(context.simYear)
        else
          @checkStatus(context) #to get progress stats

            
      if @goalAchieved() && @enabled
        @execOne(context)
    else
      if @enabled
        @execOne(context)
  
  @fromJSON: (json) ->
    m = new Manipulator(json.id, json.name, json.kind, json.template_name, json.start, json.end, json.params)
    
    func = "m.checkStatus = function(context) { "+json.can_formula+"}"
    eval(func)

    func = "m.doIt = function(context) { "+json.do_formula+"}"
    eval(func)
    
    func = "m.execOne = function(context) { "+json.formula+"}"
    eval(func)
    m
    
  
window.Manipulator = Manipulator