finplan.controller 'ResultsGoalsController', ['$scope', '$routeParams', '$location', '$http', 'goalsCache', 'planCache', ($scope, $routeParams, $location, $http, goalsCache, planCache) ->
  $http.get('/plans/1/reload.json', {cache: planCache}).success (data) ->
    $scope.plan = data

  $http.get('/goals.json', {cache: goalsCache}).success (data) ->
    $scope.goals = data

  if $routeParams.goalId
    $scope.selectedGoalId = $routeParams.goalId
    $http.get('/goals/'+$routeParams.goalId+'.json').success (data) ->
      $scope.curgoal = data
    $scope.goalViewUrl = "/templates/goal.html"
  else
    $scope.selectedGoalId = 'summary'
    $scope.goalViewUrl = "/templates/goal_summary.html"

  $scope.plan = window.plan
  $scope.simulator = window.plan.lastSimulator()
  $scope.context = $scope.simulator.context
]