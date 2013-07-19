class Chart
  constructor: (@id, @plan) ->
    @startYear = 2013    
      
  _getOptions: (balances, xtype) ->
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
      series:[{color:'#5FAB78', fill: true}],
      highlighter: {
        show: true,
        sizeAdjust: 7.5
      },
    }
    
  showDetails: (index, balances) ->    
    year = @startYear + index
    new DetailsView(year, balances).render()        

  display: (manipulators) ->
    $('#'+@id).empty()
  
    that = this
    age = 34    
    endYear = @startYear + (85-age)
    xtype = $('#xtype').attr('data-value')    
    for m in manipulators
      m.reset()
      
    total = []
    cash = []
    
    balances = new Balances({age: age, year: @startYear})
    for year in [@startYear..endYear]
      for m in manipulators
        m.exec(balances)      
      balances.rebalance()
      balances.addYear()
      
      
      if xtype == 'year'
        x = year+'-01-01 4:00PM'
      else
        x = age + year - @startYear
      total.push [x, balances.getSavings()]
      cash.push [x, balances.getCash()]
    
    $.jqplot @id, [total, cash], @_getOptions(balances, xtype)
    $('#'+@id).bind 'jqplotDataClick', (ev, seriesIndex, pointIndex, data) ->
      that.showDetails pointIndex, balances


window.Chart = Chart