finplan.controller 'ResultsGoalsController', ['$scope', '$routeParams', '$location', '$http', 'goalsCache', 'plan', ($scope, $routeParams, $location, $http, goalsCache, plan) ->
  $scope.showChart = (m) ->
    labels = ['Have','Need']
    sets = [[],[]]
    endYear = finData['current_year']
    for d in m.progress
      y = "#{d[0]}-01-01 4:00PM"
      endYear = d[0] if d[0] > endYear
      sets[0].push [y, d[1]['have']]
      sets[1].push [y, d[1]['need']]

    new YearlyChart('goal_results_chart', labels, sets, endYear+1).display()
    null

  $scope.plan = plan

  $http.get('/goals.json?unused=false', {cache: goalsCache}).success (data) ->
    $scope.goals = data

  if $routeParams.goalId
    $scope.selectedGoalId = $routeParams.goalId
    $scope.goal = plan.findManipulatorByID($routeParams.goalId)
    $scope.goalViewUrl = "/templates/result_goal.html"
  else
    $scope.selectedGoalId = 'summary'
    $scope.goalViewUrl = "/templates/result_goal_summary.html"

  $scope.simulator = plan.lastSimulator()
  $scope.context = $scope.simulator.context
]