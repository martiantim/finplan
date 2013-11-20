class AccountList extends NiceList
  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'accounts'
    })    

  reload: ->    
    that = this
    $.ajax({
      url: "/accounts",
      type: 'GET',
      data: {'plan_id': @plan.id},
      success: (data) ->
        that.wrapper.html data
        that.rewire()
    })



  removeItem: (itemID) ->
    that = this
    $.ajax({
      url: "/accounts/#{itemID}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        that.viewer().html('')
        plan.markDirty()        
        that.reload()        
      ,error: (request) ->      
        showMessageDialog('error', request.responseText);
      
    })


window.AccountList = AccountList