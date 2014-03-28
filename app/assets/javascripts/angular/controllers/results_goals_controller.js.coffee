finplan.controller 'ResultsGoalsController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->
  $http.get('/plans/1/reload.json').success (data) ->
    $scope.plan = data

  $http.get('/goals.json').success (data) ->
    $scope.goals = data

  if $routeParams.goalId
    $http.get('/goals/'+$routeParams.goalId+'.json').success (data) ->
      $scope.curgoal = data
      $scope.curgoal.startYear = new Date($scope.curgoal.start).getFullYear()
      $scope.curParams = data.params

    $scope.goalViewUrl = "/templates/goal.html"
  else
    $scope.goalViewUrl = "/templates/goal_summary.html"
]