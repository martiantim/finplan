class Investment extends Manipulator

  exec: (balances) ->
    inc = balances.getSavings() * 0.04
    balances.addSavings(inc)


window.Investment = Investment