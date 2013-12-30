class SimContext
  constructor: (@simYear, startAccounts, @family) ->
    age = -1
    @balances = new Balances(startAccounts, {age: age, year: @simYear})
    @stateLivingIn = 'Oregon'
    @familyStatus = {}

  oldestAdultAge: ->
    max = 0
    @family.membersOfYear(@simYear, (user, kind) =>
      max = user.ageInYear(@simYear) if user.ageInYear(@simYear) > max
    )
    max

  familySize: (onlyHumans) ->
    @family.numMembersOfYear(@simYear, onlyHumans)

  nextSimYear: (manipulators) ->
    @familyStatus[@simYear] = {}
    @family.membersOfYear(@simYear, (person, kind) =>
      @familyStatus[@simYear][person.id] = {'working': false}

      for m in manipulators
        if m.template_name == 'Salary' && m.user.id == person.id
          @familyStatus[@simYear][person.id]['working'] = m.enabled
    )
    @simYear++

window.SimContext = SimContext