class Chart
  constructor: (@id, @plan) ->
    @startYear = 2013
  
  _getOptions: (balances) ->
    xAxisOptions = {
      min: "2013-01-01",
      tickOptions:{formatString:'%Y', angle: -30},      
      renderer:$.jqplot.DateAxisRenderer      
      tickInterval:'2 years'
      drawMajorGridlines: true
    }
    
    yAxisOptions = {
      min:-1000,
      max: balances.highestTotal()*1.25,
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
    that = this
    age = 34    
    endYear = @startYear + (85-age)
    
    total = []
    cash = []
    
    balances = new Balances({age: age, year: @startYear})
    balances.printState()
    for year in [@startYear..endYear]
      for m in manipulators
        m.exec(balances)      
      balances.rebalance()
      balances.addYear()
      balances.printState()
      total.push [year+'-01-01 4:00PM', balances.getTotal()]
      cash.push [year+'-01-01 4:00PM', balances.getCash()]
    
    $.jqplot @id, [total, cash], @_getOptions(balances)
    $('#'+@id).bind 'jqplotDataClick', (ev, seriesIndex, pointIndex, data) ->
      that.showDetails pointIndex, balances


window.Chart = Chart