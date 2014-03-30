finplan.controller 'GoalsController', ['$scope', '$routeParams', '$location', '$http', 'goalsCache', 'planCache', ($scope, $routeParams, $location, $http, goalsCache, planCache) ->
  $scope.loadGoal = (goalId) ->
    $scope.selectedGoalId = goalId
    $http.get('/goals/'+goalId+'.json').success (data) ->
      $scope.curgoal = data
      $scope.curgoal.startYear = new Date($scope.curgoal.start).getFullYear()
      $scope.curParams = data.params


  $http.get('/plans/1/reload.json', {cache: planCache}).success (data) ->
    $scope.plan = data

  $http.get('/goals.json', {cache: goalsCache}).success (data) ->
    $scope.goals = data
    $scope.loadGoal($scope.goals[0].id) if !$routeParams.goalId



  if $routeParams.goalId
    $scope.loadGoal($routeParams.goalId)

  $scope.goalViewUrl = "/templates/goal.html"

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
    for param in $scope.curParams
      formData["variables[#{param.name}]"] = param.value

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