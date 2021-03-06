class Plan
  constructor: (@id, @name) ->
    @simulator = null
    @manipulators = []
    @startAccounts = []
    @family = new Family()
    @simulateOutOfDate = false
    @noSimulation = true
    @canSimulate = false
    @todoBeforeSimulate = []

  reloadData: ($http) ->
    that = this

    if $http
      $http.get("/plans/#{@id}/reload").success (data) =>
        @setData(data)
    else
      $.ajax({
        url: "/plans/#{@id}/reload",
        type: 'GET',
        success: (data) =>
          @setData(data)
      })

  setData: (data) ->
    @manipulators = []
    @startAccounts = []
    @family = new Family(data.state)

    for fjson in data.family_members
      u = User.fromJSON(fjson)
      @addFamilyMember(u)
    for mjson in data.manipulators
      m = Manipulator.fromJSON(mjson, @family)
      @add(m)
    for ajson in data.accounts
      acct = Account.fromJSON(ajson)
      @addAccount(acct)
    @todoBeforeSimulate = data.todos

  markDirty: (andData = false) ->
    if andData
      @reloadData()
    @simulateOutOfDate = true

  onSimulateClick: (scenario = null) ->
    @simulateOutOfDate = false
    @simulate(scenario)
    window.navigation.simulateDone()

  onScenarioClick: ->
    new Scenarios().show()

  onChartDisplay: ->
    @resultsChart.display(@lastSimulator())
  
  simulate: (scenario) ->
    that = this

    dialog = $("#simulate_dialog")
    dialog.find('#simyear label').html('Simulating Year <span id="current_simulate_year">2014</span>')
    dialog.find('.sim_done button').addClass('disabled')
    dialog.find('#simulate_year_progress').css('width', '0%').removeClass('progress-bar-success').parent().addClass('active')
    dialog.modal({
      show: true
    })

    @simulator = new Simulator(scenario, @family, @manipulators, @startAccounts, dialog)
    @simulator.sim (ex) ->
      that.simulator.bankruptcy = ex
#      that.resultsGoals.selectItem('summary', true)
#      that.resultsChart.display(that.simulator)
#      that.resultsByYear.setEndYear(that.simulator.endYear())
#      that.resultsChart.setEndYear(that.simulator.endYear())
#      that.resultsByYear.displayDefault()
      that.noSimulation = false
      window.location = '#/results/goals'
#      window.navigation.showDirty(false)
  
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