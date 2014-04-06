finplan.controller 'GoalsController', ['$scope', '$routeParams', '$location', '$http', 'goalsCache', 'planCache', ($scope, $routeParams, $location, $http, goalsCache, planCache) ->
  $scope.loadGoal = (goalId) ->
    $scope.selectedGoalId = goalId
    $http.get('/goals/'+goalId+'.json').success (data) ->
      $scope.curgoal = data
      $scope.curgoal.startYear = new Date($scope.curgoal.start).getFullYear()
      $scope.curParams = data.params
      finFormat($('.manipulator'), 100)

  $http.get('/plans/1/reload.json', {cache: planCache}).success (data) ->
    $scope.plan = data

  $http.get('/goals.json', {cache: goalsCache}).success (data) ->
    $scope.goals = data
    $scope.selectFirst() if !$routeParams.goalId


  if $routeParams.goalId
    $scope.loadGoal($routeParams.goalId)

  $scope.goalViewUrl = "/templates/goal.html"

  $scope.ageRange = []
  for i in [0..99]
    $scope.ageRange.push(i)

  $scope.yearRange = []
  for y in [2014..2100]
    $scope.yearRange.push(y)

  $scope.selectFirst = ->
    $scope.selectedGoalId = $scope.goals[0].id
    $scope.loadGoal($scope.selectedGoalId)

  $scope.reloadList = ->
    goalsCache.removeAll()
    $http.get('/goals.json', {cache: goalsCache}).success (data) ->
      delete $scope.goals
      $scope.goals = data

  $scope.remove = (goal) ->
    $.ajax({
      url: "/goals/#{goal.id}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        $scope.$apply ->
          $scope.reloadList()
          $scope.selectFirst()
    })

  $scope.update = (goal) ->
    formData = {
      'manipulator[name]': goal.name,
      'manipulator[manipulator_template_id]': goal.manipulator_template_id,
      'when_type': goal.start_type,
      'when_year': goal.startYear,
      'when_person': goal.start_plan_user_id,
      'when_age': goal.start_plan_user_age
    }
    if goal.id
      formData['manipulator[id]'] = goal.id
      formData['_method'] = 'patch'
    for param in $scope.curParams
      formData["variables[#{param.name}]"] = param.value

    #process the form
    id = ''
    id = goal.id if goal.id
    $.ajax({
      type 		: 'POST',
      url 		: '/goals/'+id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        goal.id = data.id
        $scope.reloadList()
    })

]