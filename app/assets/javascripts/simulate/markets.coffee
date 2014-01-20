class Markets
  constructor: (@simContext) ->
    @ITYPES = ['None', 'Money Market', 'Bonds', 'Stock', 'International Stock']
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


  ratesForYear: (year) ->
    return @rates[year] if @rates[year]

    yrates = {}
    for itype in @ITYPES
      yrates[itype] = @calcReturnRate(itype)

    @rates[year] = yrates
    yrates



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
      avg = 0.104
      stdev = 0.202
      @stdrnd(avg, stdev)
    else if iType == 'International Stock'
      avg = 0.124
      stdev = 0.25
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