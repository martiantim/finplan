class Spending extends Manipulator
  constructor: (name, start, end, @cost) ->
    super name, start, end
    
  exec: (balances) ->
    balances.spendCash(@cost)

window.Spending = Spending