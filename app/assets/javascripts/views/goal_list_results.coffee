class GoalListResults extends GoalList

  showGoal: (itemID) ->
    @viewer().load "/goals/#{itemID}/show_results?plan_id=#{@plan.id}", =>
      m = @plan.findManipulatorByID(itemID)
      if m && m.achievedYear
        @viewer().find('.goal_status').html('<span class="ui-icon ui-icon-info"></span> Will achieve in '+m.achievedYear)
      else if m && m.failMessage
        @viewer().find('.goal_status').html('<span class="ui-icon ui-icon-alert"></span> '+m.failMessage)
      
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
      tr.append("<td>#{d[0]}</td><td class='money'>#{d[1]['have']}</td><td class='money'>#{d[1]['need']}</td>")
      tbody.append(tr)
    tbody.find('.money').autoNumeric('init',{aSign:'$', mDec: 0});
  
window.GoalListResults = GoalListResults