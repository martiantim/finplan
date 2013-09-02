class NiceList
  constructor: (@el, @options) ->
    @_wire()
  
  rewire: ->
    @_wire()
  
  viewer: ->
    @el.closest('.content').find('.content_main')
    
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
    @el.find('a.expander').click ->
      state = $(this).attr('data-expanded')
      if state == 'true'
        $(this).find('span').removeClass('ui-icon-triangle-1-s').addClass('ui-icon-triangle-1-e')
        $(this).attr('data-expanded', false)
        that.el.find('ul').hide()
      else
        $(this).find('span').removeClass('ui-icon-triangle-1-e').addClass('ui-icon-triangle-1-s')
        $(this).attr('data-expanded', true)
        that.el.find('ul').show()
    

window.NiceList = NiceList