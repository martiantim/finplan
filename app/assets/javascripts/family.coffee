class Family
  constructor: (@stateLivingIn) ->
    @members = []
    
  add: (u) ->
    @members.push(u)

  findByID: (id) ->
    for u in @members
      return u if u.id == id

    null

  numAdults: ->
    num = 0
    for u in @members
      if u.ageInYear(finData['current_year']) >= 18
        num += 1
    num

  numMembersOfYear: (year, onlyHumans = false) ->
    num = 0
    for u in @members
      num += 1 if u.isAliveInYear(year) && (!onlyHumans || u.isHuman())
    num

  membersOfYear: (year, func) ->
    for u in @members
      if u.isAliveInYear(year)
        func(u, u.descriptor(year))

  oldestMember: (year) ->
    oldest = null
    oldestAge = 0
    for u in @members
      if u.ageInYear(year) > oldestAge
        oldestAge = u.ageInYear(year)
        oldest = u

    oldest

  #year last adult member dies
  endYear: ->
    end = 2030
    for u in @members
      if u.ageInYear(finData['current_year']) >= 18
        end = u.projectedDeathYear if u.projectedDeathYear > end
    end

  dupe: ->
    fam = new Family(@stateLivingIn)
    for u in @members
      fam.add(u)
    fam

  addUnexpected: ->
    h = User.randomPopularNameAndGender()
    year = 2014 + (Math.random()%5)|0
    @add(new User(0, h['name'], "1/1/#{year}", h['gender'], 'H', null))

window.Family = Family