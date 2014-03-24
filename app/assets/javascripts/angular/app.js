finplan = angular.module('FinPlan', [
    'ngRoute',
    'FinPlan.services',
    'FinPlan.controllers'
  ]);

finplan.config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/goals', {templateUrl: '/templates/goals.html', controller: 'GoalsController'});
    $routeProvider.when('/goals/:goalId', {templateUrl: '/templates/goals.html', controller: 'GoalsController'});

    $routeProvider.when('/setup', {templateUrl: '/templates/family.html', controller: 'FamilyController'});
    $routeProvider.when('/family', {templateUrl: '/templates/family.html', controller: 'FamilyController'});
    $routeProvider.when('/family/:userId', {templateUrl: '/templates/family.html', controller: 'FamilyController'});

    $routeProvider.when('/accounts', {templateUrl: '/templates/accounts.html', controller: 'AccountsController'});
    $routeProvider.when('/accounts/:accountId', {templateUrl: '/templates/accounts.html', controller: 'AccountsController'});

    $routeProvider.otherwise({redirectTo: '/goals'});
  }]);

finplan.run(function($rootScope) {
  $rootScope.$on('$routeChangeSuccess', function(ev,data) {
    if (data.$$route && data.$$route.controller)
      $rootScope.controller = data.$$route.controller;
  })
});