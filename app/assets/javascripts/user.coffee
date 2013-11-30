class User
  constructor: (@id, @name, @born, @gender, @species) ->
    @bornYear = new Date(@born).getYear() + 1900
    if @gender == 'M'
      @projectedDeathYear = @bornYear + 76
    else if @gender == 'F'
      @projectedDeathYear = @bornYear + 81
    else if @gender == 'P'
      @projectedDeathYear = @bornYear + 18
    else
      @projectedDeathYear = @bornYear + 79

  @fromJSON: (json) ->
    new User(json.id, json.name, json.born, json.gender, json.species)
  
  isAliveInYear: (year) ->
    year >= @bornYear && year < @projectedDeathYear

  ageInYear: (year) ->
    year - @bornYear

  descriptor: (year) ->
    age = year - @bornYear
    if @gender == 'P'
      @species
    else if age >= 18
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