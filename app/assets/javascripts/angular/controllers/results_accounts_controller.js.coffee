finplan.controller 'ResultsAccountsController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->
  $scope.showChart = ->
    id = 'chart'
    $('#'+id).empty()

    #display chart
    labels = []
    sets = []
    simulator = window.plan.lastSimulator()
    for name, set of simulator.datasets
      labels.push name
      sets.push set

    $.jqplot id, sets, $scope._getOptions(simulator.context.balances, simulator.xtype, labels)
    $('#'+id).bind 'jqplotDataClick', (ev, seriesIndex, pointIndex, data) ->
      #that.showDetails pointIndex, simulator.context.balances
      console.log("show details")

  $scope._getOptions = (balances, xtype, labels) ->
    if xtype == 'year'
      xAxisOptions = {
        min: "#{$scope.minYear}-01-01",
        max: "#{$scope.maxYear}-01-01",
        tickOptions:{formatString:'%Y', angle: -30},
        renderer:$.jqplot.DateAxisRenderer
        tickInterval:'2 years'
        drawMajorGridlines: true
      }
    else
      xAxisOptions = {
        min: 34,
        max: 85,
        tickOptions:{formatString:'%d', angle: 0},
        drawMajorGridlines: true
      }

    yAxisOptions = {
      autoscale: true,
      tickOptions: {formatString: "$%'d" }
    }

    {
      title:'Account Balances',
      axesDefaults: {
        tickRenderer: $.jqplot.CanvasAxisTickRenderer ,
        tickOptions: {
          angle: -30,
          fontSize: '10pt'
        }
      },
      axes: {xaxis: xAxisOptions, yaxis: yAxisOptions},

      legend: {
        renderer: $.jqplot.EnhancedLegendRenderer,
        labels: labels,
        show:true,
        location: 'se',
        showSwatches: true,
        placement: 'insideGrid'
      },
      highlighter: {
        show: true,
        sizeAdjust: 7.5
      },
    }

  $scope.minYear = 2014
  $scope.maxYear = 2063
]