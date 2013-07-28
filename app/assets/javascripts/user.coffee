class User
  constructor: (@name, @born) ->    
    
  @fromJSON: (json) ->
    new User(json.name, json.born);    
  
window.User = User