class AccountList extends NiceList
  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'accounts',
      showFirst: true
    })

  extraWireItem: (itemID) ->
    @_showProperFields()
    @viewer().find('#account_name').change =>
      @_showProperFields()

  _showProperFields: ->
    if @viewer().find('#account_name').length > 0
      acctType = @viewer().find('#account_name').val()
    else
      acctType = @viewer().find('h3').text()

    visibles = {
      invest: false,
      rate: false,
      term: false,
      limit: false
    }
    if acctType == 'Credit Cards'
      visibles['rate'] = true
      visibles['limit'] = true
    else if acctType == 'Loan'
      visibles['rate'] = true
      visibles['term'] = true
    else if acctType == 'Savings'  || acctType == 'Investment' || acctType == '401K' || acctType == 'Traditional IRA' || acctType == 'Roth IRA'
      visibles['invest'] = true

    if visibles['invest']
      @viewer().find('#account_investment_type').closest('.form-group').show()
    else
      @viewer().find('#account_investment_type').closest('.form-group').hide()
    if visibles['rate']
      @viewer().find('#account_interest_rate').closest('.form-group').show()
    else
      @viewer().find('#account_interest_rate').closest('.form-group').hide()
    if visibles['term']
      @viewer().find('#account_term').closest('.form-group').show()
    else
      @viewer().find('#account_term').closest('.form-group').hide()
    if visibles['limit']
      @viewer().find('#account_limit').closest('.form-group').show()
    else
      @viewer().find('#account_limit').closest('.form-group').hide()

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