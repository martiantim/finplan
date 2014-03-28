finplan.controller 'ResultsByYearController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->
  $scope.minYear = finData['current_year']
  $scope.viewYear = finData['current_year']
  $scope.maxYear = 2064
  @_initSlider()
  @el = $('#not_sure')



  _updateYear: (skipSlider = false) ->
    if !skipSlider
      @el.find('#year_slider').slider('setValue', $scope.viewYear)

  _initSlider: ->
    @el.find('#year_slider_wrapper').html('<div id="year_slider" class="slider slider-horizontal" style="width: 900px;"></div>')
    @slider = @el.find('#year_slider').slider({
      min: $scope.minYear,
      max: $scope.maxYear,
    }).on('slideStop', (ev) =>
      $scope.viewYear = parseInt(ev.value)
      @showYear(ev.value)
      @_updateYear()
    )

  showYear: (year) ->
    $scope.details = findPlan().lastSimulator().context
    $scope.log = context.balances.logForYear($scope.viewYear)
    $scope.snap = context.balances.snapshotForYear($scope.viewYear)
]