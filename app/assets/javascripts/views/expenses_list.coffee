class ExpensesList extends NiceList
  constructor: (@wrapper, @plan) ->    
    super(@wrapper, {
      controller: 'expenses'
    })

window.ExpensesList = ExpensesList