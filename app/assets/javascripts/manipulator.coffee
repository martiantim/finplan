class Manipulator
  constructor: (@id, @name, @kind, @template_name, @user, start, end, prms) ->
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
      else if v.match(/^\d/)
        @params[k] = parseInt(v)
      else
        @params[k] = v

  setDisabled: ->
    @enabled = false

  setEnabled: ->
    @enabled = true

  reset: (sim) ->
    @curSim = sim
    @achieved = false
    @needAnother = false
    @achievedYear = null
    @achievedTimes = 0
    @failedTimes = 0
    @enabled = true
    @failMessage = null
    @tempParams = {}
    @cpiAdjustedParams = {}
    @progress = []

  adjustForInflation: (inflationRate) ->
    for k, v of @cpiAdjustedParams
      @cpiAdjustedParams[k] = v * (1 + inflationRate)

  setGoalProgress: (year, have, need) ->
    @progress.push [year, {have: have, need: need, inRange: @inRange(@curSim.context.simYear)}]

  setGoalAchieved: (year) ->
    @achievedTimes += 1
    @achievedYear = year
    @achieved = true

  addGoalFailed: (year) ->
    @failedTimes += 1

  setGoalNeedAnother: ->
    @needAnother = true

  setGoalFailureMessage: (msg) ->
    @failMessage = msg

  goalAchieved: ->
    @achieved

  inRange: (year) ->
    return false if @startYear && year < @startYear
    return false if @endYear && year > @endYear

    if @name == 'Retire'
      console.log(this)
      console.log("end = #{@endYear} year=#{year}")
      console.log("retire in range")
    true

  findManipulatorByName: (name) ->
    @curSim.findManipulatorByName(name)

  disable: (name) ->
    @curSim.disable(name)

  enable: (name) ->
    @curSim.enable(name)

  exec: (context) ->
    if @kind == 'goal'
      if !@goalAchieved() || @needAnother
        if @inRange(context.simYear)
          if @checkStatus(context)
            @setGoalAchieved(context.simYear)
            @doIt(context)
        else
          @checkStatus(context) #to get progress stats


      if @goalAchieved() && @enabled
        @execOne(context)
    else
      if @enabled
        @execOne(context)

  goalStatus: ->
    status = {status: '?', message: ''}
    if @achievedYear
      status['status'] = 'ok'
      if @achievedTimes > 1
        perc = (@achievedTimes * 100 / (@achievedTimes + @failedTimes))|0
        status['message'] = "Goal will be achieved #{perc}% of years"
      else
        status['message'] = "Goal will be achieved in #{@achievedYear}"
    else
      status['status'] = 'fail'
      status['message'] = 'Unable to achieve'
    status


  @fromJSON: (json, family) ->
    user = null
    user = family.findByID(json.user_id) if json.user_id
    m = new Manipulator(json.id, json.name, json.kind, json.template_name, user, json.start, json.end, json.params_str)
    func = "m.checkStatus = function(context) { "+json.can_formula+"}"
    eval(func)

    func = "m.doIt = function(context) { "+json.do_formula+"}"
    eval(func)

    func = "m.execOne = function(context) { "+json.formula+"}"
    eval(func)
    m


window.Manipulator = Manipulator