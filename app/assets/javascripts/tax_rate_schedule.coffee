class TaxRateSchedule
  constructor: (@name, initialBrackets) ->
    @brackets = []
    for b in initialBrackets
      @addBracket(b['range_top'], b['rate'])

  addBracket: (range_top, rate) ->
    @brackets.push([range_top, rate])

  @findByName: (name) ->
    for trs in window.taxSchedules
      return trs if trs.name == name

window.TaxRateSchedule = TaxRateSchedule