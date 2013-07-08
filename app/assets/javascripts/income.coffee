class Income extends Manipulator
  constructor: (name, @salary) ->
    super name
    
  exec: (balances) ->
    if balances.getOption('age') >= 67
      amnt = 0
    else
      amnt = @salary
    
    balances.addCash(amnt)



window.Income = Income