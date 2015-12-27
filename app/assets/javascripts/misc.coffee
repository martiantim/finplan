window.finFormat = (el, delay = 0) ->
  setTimeout =>
    finFormatNow(el)
  , delay

window.finFormatNow = (el) ->
  el.find('.money').autoNumeric('init',{aSign:'$', mDec: 0, vMin: -99999999})
  el.find('.percentage').autoNumeric('init',{aSign: ' %', pSign:'s', vMin: -100.0})

window.finShowStatus = (msg) ->
  $('#global_status').html(msg).show()

window.finHideStatus = () ->
  $('#global_status').hide()

window.finData = {
  current_year: 2014
}

window.BankruptcyException = (message) ->
  this.message = message
  this.name = "BankruptcyException"


window.formSaving = ->
  $(".form_status").text('Saving...').show()
  $(".form_status").parents("form").find('input.money, input.percentage').each (i) ->
    self = $(this)
    try
      v = self.autoNumeric('get')
      self.autoNumeric('destroy')
      self.val(v)
    catch err
      console.log("Error converting: " + err)

window.formSuccess = ->
  $(".form_status").text('Saved').fadeOut()
  finFormat($(".form_status").parents('form'))
