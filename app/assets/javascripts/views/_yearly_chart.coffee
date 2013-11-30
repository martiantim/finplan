class YearlyChart
  constructor: (@id, @labels, @sets) ->
      
  _getOptions: (xtype, labels) ->
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

    high = 1000
    for set in @sets
      for item in set
        high = item[1] if item[1] > high
    yAxisOptions = {
      min: 0,
      max: high*1.1,
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
    
  display: ->
    $('#'+@id).empty()
    
    $.jqplot @id, @sets, @_getOptions('year', @labels)
    $('#'+@id).bind 'jqplotDataClick', (ev, seriesIndex, pointIndex, data) ->
      console.log("CLICK")

window.YearlyChart = YearlyChart