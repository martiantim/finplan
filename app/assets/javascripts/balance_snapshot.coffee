class BalanceSnapshot
  constructor: (@year, balances) ->
    @accountBalances = {}
    for name, a of balances.accounts      
      @accountBalances[name] = a.balance
          
  highestTotal: ->
    h = 0
    for name, amnt of @accountBalances
      h = Math.max(0, amnt)
    h
    
  lowestTotal: ->
    l = 0
    for name, amnt of @accountBalances
      l = Math.min(0, amnt)
    l

window.BalanceSnapshot = BalanceSnapshot