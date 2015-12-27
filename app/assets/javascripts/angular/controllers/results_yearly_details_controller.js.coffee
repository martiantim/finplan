finplan.controller 'ResultsYearlyDetailsController', ['$scope', '$routeParams', '$location', '$http', '$timeout', 'plan', ($scope, $routeParams, $location, $http, $timeout, plan) ->
  $scope._initSlider = ->
    $scope.slider = $('#year_slider').slider({
      min: $scope.minYear,
      max: $scope.maxYear,
    }).on('slideStop', (ev) ->
      $scope.$apply ->
        $scope.viewYear = parseInt(ev.value)
        $scope.showYear($scope.viewYear)
    )
    $scope.showYear($scope.viewYear)

  $scope.changeYear = (change) ->
    $scope.viewYear += change
    $scope.viewYear = $scope.minYear if $scope.viewYear < $scope.minYear
    $scope.viewYear = $scope.maxYear if $scope.viewYear > $scope.maxYear
    $scope._updateYear()
    $scope.showYear($scope.viewYear)

  $scope._updateYear = (skipSlider = false) ->
    if !skipSlider
      $('#year_slider').slider('setValue', $scope.viewYear)

  $scope.showYear = (year) ->
    $scope.context = plan.lastSimulator().context
    $scope.log = $scope.context.balances.logForYear($scope.viewYear)
    $scope.balances = []
    for name, obj of $scope.context.balances.snapshotForYear($scope.viewYear).accountBalances
      $scope.balances.push(obj)

    $scope.rates = plan.lastSimulator().context.markets.ratesForYearAsArray($scope.viewYear)
    $scope.updateFamilyDrawing()

  $scope.updateFamilyDrawing = ->
    return if $('#family_portrait > div').length == 0

    portrait = $('#family_portrait > div')
    portrait.html('')
    left = 0
    for uid, person of $scope.context.familyStatus[$scope.viewYear]
      drawEl = $("<div class=\"person_wrapper\" style=\"left: #{left}px;\"><div class=\"person_drawing small\" data-id=\"#{uid}\"></div></div>")
      portrait.append(drawEl)

      draw = new PersonDrawing(drawEl.find('.person_drawing'), person.kind, person.name)
      draw.setAge(person.age)
      draw.setProfession(person.profession) if person.working
      left += 100


  $scope.expands = {}
  $scope.changeExpand = (ev) ->
    exp = $(ev.currentTarget).attr('data-expand')
    $scope.expands[exp] = !$scope.expands[exp]

  $scope.minYear = finData['current_year']
  $scope.viewYear = finData['current_year']
  $scope.maxYear = 2064
  $scope._initSlider()

  $scope.nets = []
  $scope.nets.push({number: 0})
  $scope.$watch('balances', (balances) ->
    netWorth = 0
    angular.forEach(balances, (bal) ->
      netWorth += bal.balance
    )
    $scope.nets = []
    $scope.nets.push({number: netWorth})
  )



]