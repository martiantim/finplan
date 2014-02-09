class NiceList
  constructor: (@el, @options) ->
    @_wire(true)
  
  rewire: ->
    @_wire()
  
  viewer: ->
    @el.closest('.content').find('.content_main')
    
  _wire: (firstView = false) ->
    @el.find('li').click (event) =>
      target = $(event.delegateTarget)
      return false if target.hasClass('active')
      gid = target.attr('data-id')
      gname = target.attr('data-name')
      @el.closest('.content').find('.content_title').html(gname) if gname
      if @options.click
        @options.click(gid)
      else
        @showItem(gid)
      @el.find('li').removeClass('active')
      target.addClass('active')
      false

    if firstView && @options['showFirst']
      @el.find('li:first').click()

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

  selectItem: (item) ->
    @el.find("li[data-name=\"#{item}\"]").click()

  showItem: (itemID) ->
    @viewer().load "/#{@options.controller}/#{itemID}?plan_id=#{@plan.id}", =>
      @wireItem(itemID)

  wireItem: (itemID) ->
    @viewer().find('button.remove').click =>
      @removeItem itemID
      false

    @viewer().find('form').on 'ajax:success', (event, xhr, status) =>
      finHideStatus()
      itemID = xhr.id
      controller = @options.controller
      controller = xhr.controller if xhr.controller
      @viewer().find('form').attr('action', "/#{controller}/#{itemID}")
      if @viewer().find('form input[name="_method"]').length == 0
        @viewer().find('form').append('<input type="hidden" name="_method" value="put"></input>')
      finFormat(@viewer())
      @plan.markDirty(true)
      @reload()

    @viewer().find('form').on 'ajax:error', (event, xhr, status) =>
      finHideStatus()
      errMsg = xhr.error_message
      if xhr.responseJSON && xhr.responseJSON.length > 0
        for err in xhr.responseJSON
          errMsg = err.messages
      errMsg = "There was an error saving." if !errMsg
      @viewer().find('form .save_status').removeClass('hide').html(errMsg)
      finFormat(@viewer())

    @viewer().find('form').submit (e) ->
      finShowStatus('saving...')
      form = $(this)
      form.find('.save_status').addClass('hide')
      form.find('input.money, input.percentage').each (i) ->
        self = $(this);
        try
          v = self.autoNumeric('get')
          self.autoNumeric('destroy')
          self.val(v)
        catch err
          console.log("Error converting: " + err)
      true

    @wireButtonGroups()

    finFormat(@viewer())

    if @viewer().find('form').hasClass('autosave')
      @viewer().find('input, select').change =>
        @viewer().find('form').submit()
    else

      @viewer().find('button.save').click =>
        @viewer().find('form').submit()

    @extraWireItem(itemID)

  wireButtonGroups: ->
    that = this
    @viewer().find('.btn-group').each ->
      btngroup = $(this)
      that._setDependVars(btngroup.find('button.active'))
      btngroup.find('button').click (e) ->
        btngroup.find('input').val($(this).attr('data-depend-val'))
        btngroup.find('button').removeClass('active')
        $(this).addClass('active')
        that._setDependVars($(this))
        false

  _setDependVars: (el) ->
    return if el.length == 0

    type = el.attr('data-depend-type')
    val =  el.attr('data-depend-val')
    @viewer().find("div[data-depends-type=\"#{type}\"]").hide()
    @viewer().find("div[data-depends-type=\"#{type}\"][data-depends-val=\"#{val}\"]").show()

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
    $.ajax({
      url: "/#{@options.controller}",
      type: 'GET',
      data: {'plan_id': @plan.id, 'editable': @options.editable},
      success: (data) =>
        activeID = @el.find('.active').attr('data-id')
        @el.html data
        if activeID
          @el.find("li[data-id=\"#{activeID}\"]").addClass('active')
        @rewire()

    })


window.NiceList = NiceList