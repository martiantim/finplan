class GoalListResults extends GoalList

  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      editable: false,
      click: (itemID) =>
        @showGoal itemID
    })

  showGoal: (itemID) ->
    if itemID == 'summary'
      @showSummary(null)
      return

    @viewer().load "/goals/#{itemID}/show_results?plan_id=#{@plan.id}", =>
      m = @plan.findManipulatorByID(itemID)
      if m && m.achievedYear
        @viewer().find('.goal_status').html('<div class="alert alert-success"><span class="glyphicon glyphicon-ok"></span> Congradulations! Goal will be achieved in '+m.achievedYear+'</div>')
      else if m && m.failMessage
        @viewer().find('.goal_status').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign"></span> '+m.failMessage + '</div>')
      finFormat(@viewer().find('.goal_status'))
      
      @showProgressChart(m)
      @showProgressTable(m)

  showProgressChart: (m) ->
    labels = ['Have','Need']
    sets = [[],[]]
    endYear = finData['current_year']
    for d in m.progress
      y = "#{d[0]}-01-01 4:00PM"
      endYear = d[0] if d[0] > endYear
      sets[0].push [y, d[1]['have']]
      sets[1].push [y, d[1]['need']]
  
    new YearlyChart('goal_results_chart', labels, sets, endYear+1).display()
    
  showProgressTable: (m) ->
    tbody = @viewer().find('#progress_table tbody')
    for d in m.progress
      tr = $('<tr></tr>')
      tr.addClass('warning') if d[1]['inRange']
      tr.append("<td><a href='#' class='jump_to_year' data-year='#{d[0]}'>#{d[0]}</a></td><td class='money'>#{d[1]['have']}</td><td class='money'>#{d[1]['need']}</td>")
      tbody.append(tr)

    that = this
    tbody.find('.jump_to_year').click ->
      that.plan.resultsByYear.jumpToYear($(this).attr('data-year'))
      navigation.jumpToSection('byyear')
    finFormat(tbody)

  showSummary: (simulator) ->
    simulator = plan.lastSimulator() if !simulator

    html = '<h3>Summary</h3>'
    html += '<div class="well">'

    if simulator.context.scenario
      html += @_scenarioHTML(simulator.context.scenario)

    if simulator.bankruptcy
      html += '<h2>Bankruptcy :(</h2>'
      html += '<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign"></span> ' +simulator.bankruptcy.message + '</div>'
    else
      html += @_successSummary(simulator)

    html += '</div>'
    @viewer().html(html)

  _scenarioHTML: (scenario) ->
    html = ""
    html += '<div class="panel panel-default">'
    html += '<table class="table"><tr><td>'
    html += "<h4>Scenario: #{scenario['name']}</h4>"
    html += "<span class=\"help-block\">#{scenario['description']}</span>"
    html += "<td style=\"vertical-align: middle;\"><img src=\"#{scenario['image_url']}\" style=\"width: 120px;\"></td>"
    html += '</td></tr></table>'
    html += '</div>'
    html

  _successSummary: (simulator) ->
    html = "<h2>Goals: #{simulator.goalProgress()}</h2>"
    html += "<table class=\"table table-striped\">"
    html += "<thead><tr><th>Goal</th><th>Result</th></tr></thead>"
    for m in @plan.manipulators
      if m.kind == 'goal'
        html += "<tr><td>#{m.name}</td>"
        if m.achievedYear
          if m.achievedTimes > 1
            html += "<td><span class=\"glyphicon glyphicon-ok\"></span> Goal will be achieved #{m.achievedTimes} times</td>"
          else
            html += "<td><span class=\"glyphicon glyphicon-ok\"></span> Goal will be achieved in #{m.achievedYear}</td>"
        else
          html += "<td><span class=\"glyphicon glyphicon-remove\"></span>Unable to achieve</td>"
        html += "</tr>"
    html += "</table>"
    html


window.GoalListResults = GoalListResults