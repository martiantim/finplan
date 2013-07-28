class Chart
  constructor: (@id, @plan) ->
    @startYear = 2013 #TODO
      
  _getOptions: (balances, xtype, labels) ->
    if xtype == 'year'
      xAxisOptions = {
        min: "2013-01-01",
        max: "2063-01-01",
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
      title:'Finances',
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
    
  showDetails: (index, balances) ->    
    year = @startYear + index
    new DetailsView(year, balances).render()        

  display: (simulator) ->
    that = this
    $('#'+@id).empty()
    
    #display chart
    labels = []
    sets = []
    for name, set of simulator.datasets
      sets.push set
      labels.push name
    
    $.jqplot @id, sets, @_getOptions(simulator.balances, simulator.xtype, labels)
    $('#'+@id).bind 'jqplotDataClick', (ev, seriesIndex, pointIndex, data) ->
      that.showDetails pointIndex, simulator.balances


window.Chart = Chart