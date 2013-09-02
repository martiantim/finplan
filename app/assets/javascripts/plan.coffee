class Plan
  constructor: (@id, @name, @user) ->
    @chart = new Chart 'chart', this    
    @simulator = null
    @manipulators = []
    @startAccounts = []
    @_wire()
    
  reloadData: ->
    that = this
    $.ajax({
      url: "/plans/#{@id}/reload",
      type: 'GET',      
      success: (data) ->
        that.manipulators = []
        that.startAccounts = []
        
        for mjson in data.manipulators
          m = Manipulator.fromJSON(mjson)
          that.add(m)
        for ajson in data.accounts
          acct = Account.fromJSON(ajson)
          that.addAccount(acct)
    })
    
  _wire: ->
    that = this
    $('#xtype a').click ->
      $('#xtype').attr('data-value',$(this).attr('data-xtype'))
      that.display()

  markDirty: (andData = false) ->
    if andData
      @reloadData()
    window.goalList.markAllUnknown()
    @simulator = null
    window.navigation.showDirty(true)

  onDisplay: ->
    if !@simulator
      @simulate()
      
  onChartDisplay: ->
    @chart.display(@lastSimulator())
  
  simulate: ->
    that = this
    dialog = $("#simulate_dialog").dialog({
      modal: true
      height: 300,
      width: 500
    })    
    @simulator = new Simulator(@user, @manipulators, @startAccounts, dialog)
    @simulator.sim ->
      that.chart.display(that.simulator)
      window.navigation.showDirty(false)
  
  lastSimulator: ->
    @simulator
  
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