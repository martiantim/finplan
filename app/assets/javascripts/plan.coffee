class Plan
  constructor: (@id, @name) ->
    @resultsChart = new ResultsChart 'chart', this
    @resultsByYear = new ResultsByYear($('.content[data-name="byyear"]'))
    @resultsGoals = new GoalListResults($('.section[data-name="results"] .goals.list'), this);        
    @simulator = null
    @manipulators = []
    @startAccounts = []
    @family = new Family()
    @_wire()
    
  reloadData: ->
    that = this
    $.ajax({
      url: "/plans/#{@id}/reload",
      type: 'GET',      
      success: (data) =>
        @manipulators = []
        @startAccounts = []
        @family = new Family()
        
        for mjson in data.manipulators
          m = Manipulator.fromJSON(mjson)
          @add(m)
        for ajson in data.accounts
          acct = Account.fromJSON(ajson)
          @addAccount(acct)
        for fjson in data.family_members
          u = User.fromJSON(fjson)
          @addFamilyMember(u)          
    })
    
  _wire: ->

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
    @resultsChart.display(@lastSimulator())
  
  simulate: ->
    that = this
    dialog = $("#simulate_dialog").dialog({
      modal: true
      height: 300,
      width: 500
    })    
    @simulator = new Simulator(@family, @manipulators, @startAccounts, dialog)
    @simulator.sim ->
      that.resultsChart.display(that.simulator)
      that.resultsByYear.displayDefault()
      window.navigation.showDirty(false)
  
  lastSimulator: ->
    @simulator
  
  add: (m) ->
    @manipulators.push m

  addAccount: (acct) ->
    @startAccounts.push acct

  addFamilyMember: (u) ->
    @family.add(u)

  findManipulatorByID: (id) ->
    for m in @manipulators
      if parseInt(m.id) == parseInt(id)
        return m
    null
        
window.Plan = Plan