class Manipulator
  constructor: (@name, @startYear, @endYear, prms) ->
    @params = {}
    
    for k,v of $.parseJSON(prms)
      @params[k] = parseInt(v)
  
  inRange: (year) ->
    return false if @startYear && year < @startYear
    return false if @endYear && year > @endYear
    
    true
  
  @fromJSON: (json) ->
    console.log(json)
    m = new Manipulator(json.name, json.start, json.end, json.params);
    
    func = "m.exec = function(balances) { "+json.formula+"}"    
    eval(func)
    m
    
  
window.Manipulator = Manipulator