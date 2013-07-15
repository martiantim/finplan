class Plan
  constructor: (@name) ->
    @chart = new Chart 'chart', this
    @manipulators = [];
    @_wire()
    
  _wire: ->
    that = this
    $('#xtype a').click ->
      $('#xtype').attr('data-value',$(this).attr('data-xtype'))
      that.display()

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