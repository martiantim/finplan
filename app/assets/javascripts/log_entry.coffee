class LogEntry
  constructor: (@kind, @description, @amount) ->
    @account = null
    m = @kind.match(/account:(.+)/)
    @account = m[1] if m

  
  
window.LogEntry = LogEntry