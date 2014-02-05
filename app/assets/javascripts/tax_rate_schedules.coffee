class TaxSchedules
  constructor: ->

  @load: ->
    $.ajax({
      url: "/tax_rate_schedules.json",
      type: 'GET',
      success: (data) =>
        for ts in data
          trs = new TaxRateSchedule(ts.name, ts.brackets)
          window.taxSchedules.push(trs)
    })

window.TaxSchedules = TaxSchedules
window.taxSchedules = []