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

    $routeProvider.when('/expenses', {templateUrl: '/templates/expenses.html', controller: 'ExpensesController'});
    $routeProvider.when('/expenses/:expenseId', {templateUrl: '/templates/expenses.html', controller: 'ExpensesController'});

    $routeProvider.when('/results/goals', {templateUrl: '/templates/results_goals.html', controller: 'ResultsGoalsController'});
    $routeProvider.when('/results/goals/:goalId', {templateUrl: '/templates/results_goals.html', controller: 'ResultsGoalsController'});
    $routeProvider.when('/results/accounts', {templateUrl: '/templates/results_accounts.html', controller: 'ResultsAccountsController'});
    $routeProvider.when('/results/yearly_details', {templateUrl: '/templates/results_yearly_details.html', controller: 'ResultsYearlyDetailsController'});

    $routeProvider.otherwise({redirectTo: '/goals'});
  }]);

finplan.run(function($rootScope) {
  $rootScope.$on('$routeChangeSuccess', function(ev,data) {
    if (data.$$route && data.$$route.controller)
      $rootScope.controller = data.$$route.controller;
  })
});


finplan.directive('finFormatDirective', function() {
    return function(scope, element, attrs) {
      finFormat($(element));
    };
  });