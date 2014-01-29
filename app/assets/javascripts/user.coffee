class User
  constructor: (@id, @name, @born, @gender, @species, @profession) ->
    @bornYear = new Date(@born).getYear() + 1900
    @projectedDeathYear = @bornYear + @projectedLongevity()

  @fromJSON: (json) ->
    new User(json.id, json.name, json.born, json.gender, json.species, json.profession)

  projectedLongevity: ->
    if @gender == 'M'
      76
    else if @gender == 'F'
      81
    else
      79


  isHuman: ->
    @gender != 'P'

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