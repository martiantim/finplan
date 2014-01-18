window.finFormat = (el) ->
  el.find('.money').autoNumeric('init',{aSign:'$', mDec: 0, vMin: -99999999})
  el.find('.percentage').autoNumeric('init',{aSign: ' %', pSign:'s', vMin: -100.0})

window.finShowStatus = (msg) ->
  $('#global_status').html(msg).show()

window.finHideStatus = () ->
  $('#global_status').hide()

window.finData = {
  current_year: 2014
}