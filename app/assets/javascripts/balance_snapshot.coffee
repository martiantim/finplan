class BalanceSnapshot
  constructor: (@year, balances) ->
    @cash = balances.getCash()
    @savings = balances.getSavings()
    
  highestTotal: ->
    Math.max(@cash, @savings)
    
  lowestTotal: ->
    Math.min(@cash, @savings)

window.BalanceSnapshot = BalanceSnapshot