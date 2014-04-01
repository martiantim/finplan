class Markets
  constructor: (@simContext) ->
    @ITYPES = ['None', 'Money Market', 'Bonds', 'Stock', 'International Stock', 'Inflation']
    @myrng = new Math.seedrandom('yay');
    @rates = {}

  returnOfType: (iType) ->
    age = @simContext.oldestAdultAge()
    if iType == 'Target Retirement'
      if age < 50
        stocks = 0.9
        bonds = 0.1
      else if age < 60
        stocks = 0.8
        bonds = 0.2
      else if age < 67
        stocks = 0.4
        bonds = 0.6
      else
        stocks = 0.1
        bonds = 0.9

      stocks * @rate('Stock') + bonds * @rate('Bonds')
    else
      @rate(iType)

  rate: (iType) ->
    @ratesForYear(@simContext.simYear)[iType]

  typesAndRates: (year) ->
    list = []
    for itype in ITYPES
      if itype != 'None'
        list.push({name: itype, rate: @ratesForYear(year)})
    list

  ratesForYear: (year) ->
    return @rates[year] if @rates[year]

    yrates = {}
    for itype in @ITYPES
      yrates[itype] = @calcReturnRate(itype)

    @rates[year] = yrates
    yrates

  ratesForYearAsArray: (year) ->
    h = @ratesForYear(year)
    arr = []
    for itype, rate of h
      arr.push({name: itype, rate: rate})
    arr

  calcReturnRate: (iType) ->
    if iType == 'Money Market'
      avg = 0.015
      stdev = 0.005
      @stdrnd(avg, stdev)
    else if iType == 'Bonds'
      avg = 0.04
      stdev = 0.005
      @stdrnd(avg, stdev)
    else if iType == 'Stock'
      if @simContext.isScenario('bad_market')
        avg = 0.060
        stdev = 0.10
      else
        avg = 0.104
        stdev = 0.202
      @stdrnd(avg, stdev)
    else if iType == 'International Stock'
      if @simContext.isScenario('bad_market')
        avg = 0.070
        stdev = 0.12
      else
        avg = 0.124
        stdev = 0.25
      @stdrnd(avg, stdev)
    else if iType == 'Inflation'
      avg = 0.03
      stdev = 0.02
      @stdrnd(avg, stdev)
    else if iType == 'None'
      0.0
    else
      alert("Unknown innvestment type: #{iType}")

  rnd_snd: ->
    (@myrng()*2-1)+(@myrng()*2-1)+(@myrng()*2-1)

  stdrnd: (mean, stdev) ->
    @rnd_snd()*stdev+mean



window.Markets = Markets
