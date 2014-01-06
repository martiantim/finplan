class ResultsByYear
  constructor: (@el)->
    @curYear = finData['current_year']
    @maxYear = 2064
    @el.find('#year_slider').slider({
      min: @curYear,
      max: @maxYear,
      slide: (event, ui) =>
        @el.find('#cur_year').html(ui.value)
        @curYear = parseInt(ui.value)
      change: (event, ui) =>
        @el.find('#cur_year').html(ui.value)
        @showYear(ui.value)
    })
    @el.find('a.year_prev').click =>
      @curYear -= 1
      @curYear = finData['current_year'] if @curYear < finData['current_year']
      @el.find('#year_slider').slider('value', @curYear)
    @el.find('a.year_next').click =>
      @curYear += 1
      @curYear = @maxYear if @curYear > @maxYear
      @el.find('#year_slider').slider('value', @curYear)

  displayDefault: ->
    @jumpToYear(finData['current_year'])

  jumpToYear: (year) ->
    @curYear = year
    @el.find('#year_slider').slider('value', @curYear)

  showYear: (year) ->
    new ResultsByyearYear(year, plan.lastSimulator().context).render(@el.find('#byyear_data'))

window.ResultsByYear = ResultsByYear