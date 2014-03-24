finplan.controller 'GoalsController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->

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

  $scope.ageRange = []
  for i in [0..99]
    $scope.ageRange.push(i)

  $scope.yearRange = []
  for y in [2014..2100]
    $scope.yearRange.push(y)

  $scope.update = (goal) ->
    formData = {
      '_method': 'patch',
      'manipulator[id]': goal.id,
      'manipulator[name]': goal.name,
      'when_type': goal.start_type,
      'when_year': goal.startYear,
      'when_person': goal.start_plan_user_id,
      'when_age': goal.start_plan_user_age
    }

    #process the form
    $.ajax({
      type 		: 'POST',
      url 		: '/goals/'+goal.id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        console.log("success!")
    })
]