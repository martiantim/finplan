finplan.controller 'ResultsYearlyDetailsController', ['$scope', '$routeParams', '$location', '$http', '$timeout', ($scope, $routeParams, $location, $http, $timeout) ->
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
    $scope.context = window.plan.lastSimulator().context
    $scope.log = $scope.context.balances.logForYear($scope.viewYear)
    $scope.balances = []
    for name, obj of $scope.context.balances.snapshotForYear($scope.viewYear).accountBalances
      $scope.balances.push(obj)
    $scope.rates = window.plan.lastSimulator().context.markets.ratesForYearAsArray($scope.viewYear)

  $scope.expands = {}
  $scope.changeExpand = (ev) ->
    exp = $(ev.currentTarget).attr('data-expand')
    $scope.expands[exp] = !$scope.expands[exp]

  $scope.minYear = finData['current_year']
  $scope.viewYear = finData['current_year']
  $scope.maxYear = 2064
  $scope._initSlider()



]