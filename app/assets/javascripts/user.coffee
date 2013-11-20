class User
  constructor: (@name, @born, @gender) ->    
    @bornYear = new Date(@born).getYear() + 1900
    if @gender == 'M'
      @projectedDeathYear = @bornYear + 76
    else if @gender == 'F'
      @projectedDeathYear = @bornYear + 81
    else
      @projectedDeathYear = @bornYear + 79
      
    console.log("#{@name} will live #{@bornYear} to #{@projectedDeathYear}")
    
  @fromJSON: (json) ->
    new User(json.name, json.born, json.gender);    
  
  isAliveInYear: (year) ->
    year >= @bornYear && year < @projectedDeathYear

  ageInYear: (year) ->
    year - @bornYear

  descriptor: (year) ->
    age = year - @bornYear
    if age >= 18
      if @gender == 'F'
        'woman'
      else
        'man'
    else if age > 3
      if @gender == 'F'
        'girl'
      else
        'boy'
    else
      'baby'
    
  
window.User = User