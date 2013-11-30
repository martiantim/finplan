class ResultsByYear
  constructor: (@el)->
    @curYear = 2013
    @el.find('#year_slider').slider({
      min: 2013,
      max: 2064,
      slide: (event, ui) =>
        @el.find('#cur_year').html(ui.value)
        @curYear = parseInt(ui.value)
      change: (event, ui) =>
        @el.find('#cur_year').html(ui.value)
        @showYear(ui.value)
    })
    @el.find('a.year_prev').click =>
      @curYear -= 1
      @el.find('#year_slider').slider('value', @curYear)
    @el.find('a.year_next').click =>
      @curYear += 1
      @el.find('#year_slider').slider('value', @curYear)

  displayDefault: ->
    @jumpToYear(2013)

  jumpToYear: (year) ->
    @curYear = year
    @el.find('#year_slider').slider('value', @curYear)

  showYear: (year) ->
    new DetailsView(year, plan.lastSimulator().context).render(@el.find('#byyear_data'))

window.ResultsByYear = ResultsByYear