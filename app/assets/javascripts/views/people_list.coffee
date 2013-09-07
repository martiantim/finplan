class PeopleList extends NiceList
  constructor: (@wrapper, @plan) ->    
    that = this
    super(@wrapper, {
      click: (itemID) ->
        that.showPerson itemID       
    })    
    
  showPerson: (itemID) ->
    that = this    
    @viewer().load "/plan_users/#{itemID}?plan_id=#{@plan.id}", ->
      that.viewer().find('button.remove').click ->
        that.removePerson itemID
        false
      
      that.viewer().find('form').on 'ajax:success', (event, xhr, status) ->  
        plan.markDirty()        
        that.reload()

  reload: ->    
    that = this
    $.ajax({
      url: "/plan_users",
      type: 'GET',
      data: {'plan_id': @plan.id},
      success: (data) ->
        that.wrapper.html data
        that.rewire()
    })
    
  removePerson: (itemID) ->
    that = this
    $.ajax({
      url: "/plan_users/#{itemID}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        that.viewer().html('')
        plan.markDirty()
        that.reload()
      ,error: (request) ->      
        showMessageDialog('error', request.responseText);
      
    })

window.PeopleList = PeopleList