finplan.controller 'NavController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->

  $scope.simulate = () ->
    console.log("SIMULATE!")
    window.plan.simulate()
]