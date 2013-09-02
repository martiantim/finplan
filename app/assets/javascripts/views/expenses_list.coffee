class ExpensesList extends NiceList
  constructor: (@wrapper, @plan) ->    
    that = this
    super(@wrapper, {
      click: (itemID) ->
        that.showAccount itemID       
    })    

  reload: ->    
    that = this
    $.ajax({
      url: "/expenses",
      type: 'GET',
      data: {'plan_id': @plan.id},
      success: (data) ->
        that.wrapper.html data
        that.rewire()
    })

  showAccount: (itemID) ->
    that = this    
    @viewer().load "/expenses/#{itemID}?plan_id=#{@plan.id}", ->
      that.viewer().find('button.remove').click ->
        that.removeExpense itemID
        false
      
      that.viewer().find('form').on 'ajax:success', (event, xhr, status) ->  
        that.reload()

  removeExpense: (itemID) ->
    that = this
    $.ajax({
      url: "/expenses/#{itemID}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        that.viewer().html('')
        that.reload()
      ,error: (request) ->      
        showMessageDialog('error', request.responseText);
      
    })


window.ExpensesList = ExpensesList