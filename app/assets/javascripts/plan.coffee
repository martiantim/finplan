class Plan
  constructor: (@name) ->
    @chart = new Chart 'chart', this
    @manipulators = [];

  display: ->    
    @chart.display(@manipulators)
  
  add: (m) ->
    @manipulators.push m
  
  each_point: (func) ->    
    p = @point.dup()    
    for i in [1..@length]      
      func(p, @direction)
      p.incr(@direction)
      
window.Plan = Plan