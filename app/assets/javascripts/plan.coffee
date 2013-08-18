class Plan
  constructor: (@id, @name, @user) ->
    @chart = new Chart 'chart', this    
    @manipulators = []
    @startAccounts = []
    @_wire()
    
  _wire: ->
    that = this
    $('#xtype a').click ->
      $('#xtype').attr('data-value',$(this).attr('data-xtype'))
      that.display()

  display: ->    
    @simulator = new Simulator(@user, @manipulators, @startAccounts)
    @simulator.sim()
    @chart.display(@simulator)
  
  add: (m) ->
    @manipulators.push m

  addAccount: (acct) ->
    @startAccounts.push acct

  findManipulatorByID: (id) ->
    for m in @manipulators
      if parseInt(m.id) == parseInt(id)
        return m
    null
        
window.Plan = Plan