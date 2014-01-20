class GoalListResults extends GoalList

  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      editable: false,
      click: (itemID) =>
        @showGoal itemID
    })

  showGoal: (itemID) ->
    @viewer().load "/goals/#{itemID}/show_results?plan_id=#{@plan.id}", =>
      m = @plan.findManipulatorByID(itemID)
      if m && m.achievedYear
        @viewer().find('.goal_status').html('<div class="alert alert-success"><span class="glyphicon glyphicon-ok"></span> Congradulations! Goal will be achieved in '+m.achievedYear+'</div>')
      else if m && m.failMessage
        @viewer().find('.goal_status').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign"></span> '+m.failMessage + '</div>')
      
      @showProgressChart(m)
      @showProgressTable(m)

  showProgressChart: (m) ->
    labels = ['Have','Need']
    sets = [[],[]]
    for d in m.progress
      y = "#{d[0]}-01-01 4:00PM"
      sets[0].push [y, d[1]['have']]
      sets[1].push [y, d[1]['need']]
  
    new YearlyChart('goal_results_chart', labels, sets).display()
    
  showProgressTable: (m) ->
    tbody = @viewer().find('#progress_table tbody')
    for d in m.progress
      tr = $('<tr></tr>')
      tr.append("<td><a href='#' class='jump_to_year' data-year='#{d[0]}'>#{d[0]}</a></td><td class='money'>#{d[1]['have']}</td><td class='money'>#{d[1]['need']}</td>")
      tbody.append(tr)

    that = this
    tbody.find('.jump_to_year').click ->
      that.plan.resultsByYear.jumpToYear($(this).attr('data-year'))
      navigation.jumpToSection('byyear')
    finFormat(tbody)
  
window.GoalListResults = GoalListResults