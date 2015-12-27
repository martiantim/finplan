class Scenarios
  constructor: (@plan) ->


  show: ->
    that = this
    @dialog = $("#scenarios_dialog")

    table = @dialog.find('table')
    table.find('tr').removeClass('success')
    table.find('tr').click ->
      table.find('tr').removeClass('success')
      $(this).addClass('success')
      that.dialog.find('.modal-footer button').removeClass('disabled')

    @dialog.find('.modal-footer button').click =>
      scenario = JSON.parse(table.find('tr.success').attr('data-scenario'))
      @plan.simulate(scenario)
      @dialog.modal('hide')

    @dialog.modal({
      show: true
    })


window.Scenarios = Scenarios