class Family
  constructor: ->
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
      if u.ageInYear(2013) >= 18
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
      if u.ageInYear(2013) >= 18
        end = u.projectedDeathYear if u.projectedDeathYear > end
    end

window.Family = Family