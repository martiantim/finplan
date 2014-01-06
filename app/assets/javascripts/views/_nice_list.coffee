class NiceList
  constructor: (@el, @options) ->
    @_wire()
  
  rewire: ->
    @_wire()
  
  viewer: ->
    @el.closest('.content').find('.content_main')
    
  _wire: ->
    @el.find('.item').hover ->
      $(this).addClass('hover')
    , ->
      $(this).removeClass('hover')
    
    @el.find('.item').click (event) =>
      target = $(event.delegateTarget)
      return false if target.hasClass('selected')
      gid = target.attr('data-id')
      if @options.click
        @options.click(gid)
      else
        @showItem(gid)
      @el.find('.item').removeClass('selected')
      target.addClass('selected')
      false

    @el.find('a.expander').click (event) =>
      target = $(event.delegateTarget)
      state = $(this).attr('data-expanded')
      if state == 'true'
        target.find('span').removeClass('ui-icon-triangle-1-s').addClass('ui-icon-triangle-1-e')
        target.attr('data-expanded', false)
        @el.find('ul').hide()
      else
        target.find('span').removeClass('ui-icon-triangle-1-e').addClass('ui-icon-triangle-1-s')
        target.attr('data-expanded', true)
        @el.find('ul').show()

  showItem: (itemID) ->
    @viewer().load "/#{@options.controller}/#{itemID}?plan_id=#{@plan.id}", =>
      @viewer().find('button.remove').click =>
        @removeItem itemID
        false

      @viewer().find('form').on 'ajax:success', (event, xhr, status) =>
        finHideStatus()
        itemID = xhr.id
        @viewer().find('form').attr('action', "/#{@options.controller}/#{itemID}")
        if @viewer().find('form input[name="_method"]').length == 0
          @viewer().find('form').append('<input type="hidden" name="_method" value="put"></input>')
        finFormat(@viewer())
        @plan.markDirty(true)
        @reload()

      @viewer().find('form').on 'ajax:error', (event, xhr, status) =>
        finHideStatus()
        errMsg = xhr.error_message
        errMsg = "There was an error saving." if !errMsg
        @viewer().find('form .save_status').html(errMsg)

      @viewer().find('form').submit (e) ->
        finShowStatus('saving...')
        form = $(this);
        form.find('input.money, input.percentage').each (i) ->
          self = $(this);
          try
            v = self.autoNumeric('get')
            self.autoNumeric('destroy')
            self.val(v)
          catch err
            console.log("Error converting: " + err)
        true

      finFormat(@viewer())

      @viewer().find('input, select').change =>
        @viewer().find('form').submit()

      @extraWireItem(itemID)

  extraWireItem: (itemID) ->
    #nada

  removeItem: (itemID) ->
    $.ajax({
      url: "/#{@options.controller}/#{itemID}",
      type: 'POST',
      data: {'_method': 'delete', 'plan_id': @plan.id},
      success: (data) =>
        @viewer().html('')
        @plan.markDirty(true)
        @reload()
      ,error: (request) ->
        showMessageDialog('error', request.responseText);

    })

  reload: ->
    curSelected = @el.find('li.selected').attr('data-id')
    $.ajax({
      url: "/#{@options.controller}",
      type: 'GET',
      data: {'plan_id': @plan.id, 'editable': @options.editable},
      success: (data) =>
        @el.html data
        @rewire()
        if curSelected
          @el.find("li[data-id=\"#{curSelected}\"]").addClass('selected')
    })


window.NiceList = NiceList