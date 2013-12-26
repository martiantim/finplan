window.finFormat = (el) ->
  el.find('.money').autoNumeric('init',{aSign:'$', mDec: 0})
  el.find('.percentage').autoNumeric('init',{aSign: ' %', pSign:'s'})

window.finShowStatus = (msg) ->
  $('#global_status').html(msg).show()

window.finHideStatus = () ->
  $('#global_status').hide()