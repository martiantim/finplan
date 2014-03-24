finplan.controller 'FamilyController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->

  $http.get('/plan_users.json').success (data) ->
    $scope.family = data

  if $routeParams.userId
    $http.get('/plan_users/'+$routeParams.userId+'.json').success (data) ->
      $scope.planUser = data
      $scope.curParams = data.salary.params

    $scope.familyViewUrl = "/templates/family_member.html"
  else
    $scope.familyViewUrl = "/templates/family_summary.html"

  $http.get('/professions.json').success (data) ->
    $scope.professions = data

  $scope.ageRange = []
  for i in [18..100]
    $scope.ageRange.push(i)

  $scope.genders = [{id: 'F', label: 'Female'},
                    {id: 'M', label: 'Male'},
                    {id: 'U', label: 'Unknown'}]
]