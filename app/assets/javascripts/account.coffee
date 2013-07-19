class Account
  constructor: (@type, @balance) ->
  
  deposit: (amnt) ->
    @balance += amnt
  
  spend: (amnt) ->
    @balance -= amnt
  
  transfer: (fromAcct, amnt) ->
    if fromAcct.balance < amnt
      alert "Error trying to transfer #{amnt} from #{fromAcct.type}"
    fromAcct.spend(amnt)
    @deposit(amnt)    
      
window.Account = Account