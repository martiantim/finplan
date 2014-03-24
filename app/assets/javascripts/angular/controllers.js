angular.module('FinPlan.controllers', [])
  .controller('NavController', function($scope, $http) {

  })

  .controller('GoalsController', function($scope, $http) {
    $http.get('/goals.json').success(function(data) {
      $scope.goals = data;
    });
    $scope.goalViewUrl = "/templates/goal_summary.html"
  })

