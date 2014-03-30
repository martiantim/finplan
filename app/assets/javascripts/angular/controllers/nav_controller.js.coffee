finplan.controller 'NavController', ['$scope', '$routeParams', '$location', '$http', 'planCache', ($scope, $routeParams, $location, $http, planCache) ->

  $scope.simulate = () ->
    console.log("SIMULATE!")
    window.plan.simulate()
]