finplan.controller 'FamilyController', ['$scope', '$routeParams', '$location', '$http', 'plan', ($scope, $routeParams, $location, $http, plan) ->

  $scope.plan = plan

  $http.get('/plan_users/states.json').success (data) ->
    $scope.states = data

  if $routeParams.userId
    $scope.selectedUserId = $routeParams.userId
    $http.get('/plan_users/'+$routeParams.userId+'.json').success (data) ->
      $scope.planUser = data
      $scope.curParams = data.salary.params

      if $scope.planUser.age >= 0
        for i in [18..100]
          $scope.ageRange.push(i)
      else
        for i in [-20..-1]
          $scope.ageRange.push({label: "in #{i*-1} years", id: i})

      setTimeout ->
        $scope.updateDrawing()
      , 100

    $scope.familyViewUrl = "/templates/family_member.html"
  else
    $scope.selectedUserId = 'summary'
    $scope.familyViewUrl = "/templates/family_summary.html"


  $http.get('/professions.json').success (data) ->
    $scope.professions = data
    $scope.updateDrawing()

  $scope.ageRange = []

  $scope.genders = [{id: 'F', label: 'Female'},
                    {id: 'M', label: 'Male'},
                    {id: 'U', label: 'Unknown'}]



  $scope.$watch('planUser', (pu, oldValue) ->
    $scope.updateDrawing()
  , true)
  $scope.$watch('plan.family', (pu, oldValue) ->
    $scope.updateFamilyDrawing()
  , true)

  $scope.familyViewLoaded = ->
    $scope.updateDrawing()
    $scope.updateFamilyDrawing()

  $scope.updateDrawing = ->
    return if !$scope.planUser
    return if $('.person_drawing').length == 0

    pu = $scope.planUser
    if !$scope.drawing
      $scope.drawing = new PersonDrawing($('.person_drawing'))

    $scope.drawing.setGender(pu.gender)
    $scope.drawing.setAge(pu.age)
    prof = null
    if $scope.professions
      for p in $scope.professions
        prof = p.name if p.id == pu.profession_id
    $scope.drawing.setProfession(prof)

  $scope.updateFamilyDrawing = ->
    if $('#family_portrait > div').length == 0
      console.log("div not here yet")
      return

    portrait = $('#family_portrait > div')
    left = 0
    $scope.plan.family.membersOfYear(finData['current_year'], (person, kind) =>
      drawEl = $("<div class=\"person_wrapper\" style=\"left: #{left}px;\"><div class=\"person_drawing small\" data-id=\"#{person.id}\"></div></div>")
      portrait.append(drawEl)

      draw = new PersonDrawing(drawEl.find('.person_drawing'), kind, person.name)
      draw.setAge(person.ageInYear(finData['current_year']))
      draw.setProfession(person.profession)
      left += 100
    )

  $scope.updatePlan = (plan) ->
    formSaving()
    formData = {
      '_method': 'patch',
      'plan[id]': plan.id,
      'plan[state]': plan.state
    }

    $.ajax({
      type 		: 'POST',
      url 		: '/plans/'+plan.id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        formSuccess()
        plan.markDirty(true)
    })


  $scope.update = (planUser) ->
    formSaving()
    born = (finData['current_year'] - planUser.age + 1) + '-01-01'

    formData = {
      'plan_user[name]': planUser.name,
      'plan_user[gender]': planUser.gender,
      'plan_user[born]': born,
      'plan_user[profession_id]': planUser.profession_id,

      'salary_manipulator_id': planUser.salary.id
    }
    if planUser.id
      formData['_method'] = 'patch'
      formData['plan_user[id]'] = planUser.id

    for param in $scope.curParams
      formData["variables[#{param.name}]"] = param.value

    id = ''
    id = planUser.id if planUser.id

    #process the form
    $.ajax({
      type 		: 'POST',
      url 		: '/plan_users/'+id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        formSuccess()
        plan.markDirty(true)
    })
]