class Markets
  constructor: (@simContext) ->
    @ITYPES = ['None', 'Money Market', 'Bonds', 'Stock', 'International Stock', 'Inflation', 'Mortgage']
    @myrng = new Math.seedrandom('yay');
    @rates = {}
    @FEE = 0.005

  returnOfType: (iType) ->
    age = @simContext.oldestAdultAge()
    if iType == 'Target Retirement'
      console.log("Target age=#{age}")
      if age < 40
        stocks = 0.65
        international_stock = 0.25
        bonds = 0.10
      else if age < 50
        stocks = 0.53
        international_stock = 0.22
        bonds = 0.25
      else if age < 60
        stocks = 0.42
        international_stock = 0.18
        bonds = 0.40
      else if age < 65
        stocks = 0.35
        international_stock = 0.15
        bonds = 0.5
      else if age < 70
        stocks = 0.25
        international_stock = 0.10
        bonds = 0.65
      else
        stocks = 0.21
        international_stock = 0.09
        bonds = 0.70

      if 1.0 - (stocks + bonds + international_stock) > 0.001
        alert("Targer retirement bug for age " + age + " (" + (stocks + bonds + international_stock) + ")")

      stocks * @rate('Stock') + bonds * @rate('Bonds') + international_stock * @rate('International Stock') - @FEE
    else
      @rate(iType) - @FEE

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
      yrates[itype] = HistoricMarkets.rateForYear(year, itype)
      #yrates[itype] = @calcReturnRate(itype)

    @rates[year] = yrates
    yrates

  ratesForYearAsArray: (year) ->
    h = @ratesForYear(year)
    arr = []
    for itype, rate of h
      arr.push({name: itype, rate: rate}) if itype != 'None'
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
