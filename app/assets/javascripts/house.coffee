class House extends Manipulator
  constructor: (name, start, end, @cost) ->
    super name, start, end
    
  exec: (balances) ->
    if balances.getOption('year') - @startYear < 30
      balances.spendCash(@cost)
  

window.House = House