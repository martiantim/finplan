class BalanceSnapshot
  constructor: (@year, balances) ->
    @accountBalances = {}
    for name, a of balances.accounts      
      @accountBalances[name] = {name: name, balance: a.balance}
          
  highestTotal: ->
    h = 0
    for name, obj of @accountBalances
      h = Math.max(0, obj.balance)
    h
    
  lowestTotal: ->
    l = 0
    for name, obj of @accountBalances
      l = Math.min(0, obj.balance)
    l

  netWorth: ->
    net = 0
    for name, obj of @accountBalances
      net += obj.balance

    net

window.BalanceSnapshot = BalanceSnapshot