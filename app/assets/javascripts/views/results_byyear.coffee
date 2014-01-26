class ResultsByYear
  constructor: (@el)->
    @curYear = finData['current_year']
    @maxYear = 2064
    @_initSlider()

    @_updateYear(true)
    @el.find('a.year_prev').click =>
      @curYear -= 1
      @curYear = finData['current_year'] if @curYear < finData['current_year']
      @_updateYear()
      @showYear(@curYear)

    @el.find('a.year_next').click =>
      @curYear += 1
      @curYear = @maxYear if @curYear > @maxYear
      @_updateYear()
      @showYear(@curYear)

  setEndYear: (year) ->
    @maxYear = year
#    @el.find('.slider').slider('destroy')
#    @_initSlider()

  _initSlider: ->
    @el.find('#year_slider_wrapper').html('<div id="year_slider" class="zzz slider slider-horizontal" style="width: 900px;"></div>')
    console.log(@el.find('#year_slider'))
    @slider = @el.find('#year_slider').slider({
      min: @curYear,
      max: @maxYear,
    }).on('slideStop', (ev) =>
      @curYear = parseInt(ev.value)
      @showYear(ev.value)
      @_updateYear()
    )

  _updateYear: (skipSlider = false) ->
    if !skipSlider
      @el.find('#year_slider').slider('setValue', @curYear)

    @el.find('#cur_year').html(@curYear)
    if @curYear == finData['current_year']
      @el.find('a.year_prev').addClass('disabled')
    else
      @el.find('a.year_prev').removeClass('disabled')

    if @curYear == @maxYear
      @el.find('a.year_next').addClass('disabled')
    else
      @el.find('a.year_next').removeClass('disabled')

  displayDefault: ->
    @jumpToYear(finData['current_year'])

  jumpToYear: (year) ->
    @curYear = year
    @el.find('#year_slider').slider('setValue', @curYear)
    @showYear(@curYear)

  showYear: (year) ->
    new ResultsByyearYear(year, plan.lastSimulator().context).render(@el.find('#byyear_data'))

window.ResultsByYear = ResultsByYear