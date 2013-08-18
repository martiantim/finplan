class NiceList
  constructor: (@el, @options) ->
    @_wire()
  
  rewire: ->
    @_wire()
  
  _wire: ->
    that = this
    @el.find('.item').hover ->
      $(this).addClass('hover')
    , ->
      $(this).removeClass('hover')
    
    @el.find('.item').click ->
      gid = $(this).attr('data-id')
      that.options.click(gid)
      that.el.find('.item').removeClass('selected')
      $(this).addClass('selected')

window.NiceList = NiceList