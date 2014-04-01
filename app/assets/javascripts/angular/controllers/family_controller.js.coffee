finplan.controller 'FamilyController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->

  $http.get('/plan_users.json').success (data) ->
    $scope.family = data

  if $routeParams.userId
    $scope.selectedUserId = $routeParams.userId
    $http.get('/plan_users/'+$routeParams.userId+'.json').success (data) ->
      $scope.planUser = data
      $scope.curParams = data.salary.params

    $scope.familyViewUrl = "/templates/family_member.html"
  else
    $scope.selectedUserId = 'summary'
    $scope.familyViewUrl = "/templates/family_summary.html"

  $http.get('/professions.json').success (data) ->
    $scope.professions = data

  $scope.ageRange = []
  for i in [18..100]
    $scope.ageRange.push(i)

  $scope.genders = [{id: 'F', label: 'Female'},
                    {id: 'M', label: 'Male'},
                    {id: 'U', label: 'Unknown'}]


  $scope.update = (planUser) ->
    born = (finData['current_year'] - planUser.age) + '-01-01'

    formData = {
      '_method': 'patch',
      'plan_user[id]': planUser.id,
      'plan_user[name]': planUser.name,
      'plan_user[gender]': planUser.gender,
      'plan_user[born]': born,

      'salary_manipulator_id': planUser.salary.id
    }
    console.log($scope.curParams)
    for param in $scope.curParams
      formData["variables[#{param.name}]"] = param.value

    #process the form
    $.ajax({
      type 		: 'POST',
      url 		: '/plan_users/'+planUser.id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        console.log("success!")
    })
]