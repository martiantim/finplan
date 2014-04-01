class Log
  constructor: (@year) ->
    @arr = []
    @totals = []
    @rates = {}

  log: (kind, desc, amount) ->
    entry = new LogEntry(kind, desc, amount)
    @arr.push entry
    if !entry.account && kind != 'event'
      tot = null
      for t in @totals
        tot = t if t.kind == kind
      if !tot
        tot = {kind: kind, value: 0}
        @totals.push(tot)

      tot.value += amount

  each_entry: (func) ->    
    for e in @arr
      func(e)      
      
  each_entry_of_kind: (kind, mergeSame, func) ->
    if mergeSame
      data = {}
      for e in @arr
        if e.kind == kind
          data[e.description] ||= new LogEntry(kind, e.description, 0)
          data[e.description].amount += e.amount

      for desc, e of data
        func(e)
    else
      for e in @arr
        if e.kind == kind
          func(e)
  
  sumOfKind: (kind) ->
    sum = 0
    @each_entry_of_kind kind, false, (entry) ->
      sum += entry.amount
    sum

window.Log = Log