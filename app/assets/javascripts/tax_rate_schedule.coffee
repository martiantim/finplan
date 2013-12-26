class TaxRateSchedule
  constructor: (@name) ->
    @brackets = []

  addBracket: (range_top, rate) ->
    @brackets.push([range_top, rate])

  @findByName: (name) ->
    for trs in window.taxSchedules
      return trs if trs.name == name

window.TaxRateSchedule = TaxRateSchedule