finplan.controller 'NavController', ['$scope', '$routeParams', '$location', '$http', 'plan', ($scope, $routeParams, $location, $http, plan) ->

  $scope.plan = plan
  $scope.simulate = () ->
    plan.simulate()

  $scope.scenarios = () ->
    new Scenarios(plan).show()

  $scope.visit = (loc) ->
    $location.path(loc.replace('#', ''))

  $scope.viewResults = () ->
    window.location = '#/results/goals'
]