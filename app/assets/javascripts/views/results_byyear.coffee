class ResultsByYear
  constructor: (@el)->
    @el.find('#year_slider').slider({
      min: 2013,
      max: 2064,
      slide: (event, ui) =>
        @el.find('#curyear').html(ui.value)
      change: (event, ui) =>
        @showYear(ui.value)
    })

  showYear: (year) ->
    new DetailsView(year, plan.lastSimulator().balances).render(@el.find('#byyear_data'))

window.ResultsByYear = ResultsByYear