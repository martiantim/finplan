class Plan
  constructor: (@name, @user) ->
    @chart = new Chart 'chart', this    
    @manipulators = [];
    @_wire()
    
  _wire: ->
    that = this
    $('#xtype a').click ->
      $('#xtype').attr('data-value',$(this).attr('data-xtype'))
      that.display()

  display: ->    
    @simulator = new Simulator(@user, @manipulators)
    @simulator.sim()
    @chart.display(@simulator)
  
  add: (m) ->
    @manipulators.push m
        
window.Plan = Plan