class Log
  constructor: (@year) ->
    @arr = []

  log: (kind, desc, amount) ->
    @arr.push new LogEntry(kind, desc, amount)    
    
  each_entry: (func) ->    
    for e in @arr
      func(e)      
      
  each_entry_of_kind: (kind, func) ->    
    for e in @arr
      if e.kind == kind
        func(e)            
  
  sumOfKind: (kind) ->
    sum = 0
    @each_entry_of_kind kind, (entry) ->
      sum += entry.amount
    sum

window.Log = Log