class Account
  constructor: (@type, @balance) ->
  
  setBalance: (bal) ->
    console.log("setting balance of #{@type} to #{bal}")
    @balance = bal
  
  deposit: (amnt) ->
    @balance += amnt
  
  spend: (amnt) ->
    @balance -= amnt
  
  transfer: (fromAcct, amnt) ->
    if fromAcct.balance < amnt
      alert "Error trying to transfer #{amnt} from #{fromAcct.type}"
    fromAcct.spend(amnt)
    @deposit(amnt)    
    
  transferUpTo: (fromAcct, amnt) ->
    if fromAcct.balance < amnt
      amnt = fromAcct.balance
    fromAcct.spend(amnt)
    @deposit(amnt)        
    
  @fromJSON: (json) ->
    new Account(json.name, json.balance)    
  
window.Account = Account