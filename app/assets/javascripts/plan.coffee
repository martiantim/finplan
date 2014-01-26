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

        for fjson in data.family_members
          u = User.fromJSON(fjson)
          @addFamilyMember(u)
        for mjson in data.manipulators
          m = Manipulator.fromJSON(mjson, @family)
          @add(m)
        for ajson in data.accounts
          acct = Account.fromJSON(ajson)
          @addAccount(acct)
    })
    
  _wire: ->

  markDirty: (andData = false) ->
    if andData
      @reloadData()
    window.goalList.markAllUnknown()
    @simulator = null
    window.navigation.showDirty(true)

  onResultsClick: ->
    if !@simulator
      @simulate()
      
  onChartDisplay: ->
    @resultsChart.display(@lastSimulator())
  
  simulate: ->
    that = this

    dialog = $("#simulate_dialog")
    dialog.find('#simyear label').html('Simulating Year <span id="current_simulate_year">2014</span>')
    dialog.find('.sim_done button').addClass('disabled')
    dialog.find('#simulate_year_progress').css('width', '0%').removeClass('progress-bar-success').parent().addClass('active')
    dialog.modal({
      show: true
    })    
    @simulator = new Simulator(@family, @manipulators, @startAccounts, dialog)
    @simulator.sim ->
      that.resultsChart.display(that.simulator)
      that.resultsByYear.setEndYear(that.simulator.endYear())
      that.resultsChart.setEndYear(that.simulator.endYear())
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