finplan = angular.module('FinPlan', [
    'ngRoute',
    'FinPlan.services',
    'FinPlan.controllers'
  ]);

finplan.config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/goals', {templateUrl: '/templates/goals.html', controller: 'GoalsController'});
    $routeProvider.when('/goals/:goalId', {templateUrl: '/templates/goals.html', controller: 'GoalController'});

    $routeProvider.when('/setup', {templateUrl: '/templates/family.html', controller: 'FamilyController'});
    $routeProvider.when('/family/:userId', {templateUrl: '/templates/family.html', controller: 'FamilyController'});

    $routeProvider.otherwise({redirectTo: '/goals'});
  }]);

