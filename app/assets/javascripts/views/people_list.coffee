class PeopleList extends NiceList
  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'plan_users'
    })

  extraWireItem: (itemID) ->
    if itemID == 'all'
      @wireFamily()
    else
      @_wireIndividual(itemID)

  _wireIndividual: (itemID) ->
    @drawing = new PersonDrawing(@viewer().find('.person_drawing'))

    @viewer().find('.nav-tabs').click (e) ->
      e.preventDefault()
      $(this).tab('show')

    @viewer().find('#plan_user_profession_id').change =>
      profession = @viewer().find('#plan_user_profession_id option:selected').text()
      @drawing.setProfession(profession)


  wireFamily: ->
    portrait = @viewer().find('#family_portrait')
    left = 0
    window.plan.family.membersOfYear(finData['current_year'], (person, kind) =>
      drawEl = $("<div class=\"person_wrapper\" style=\"left: #{left}px;\"><div class=\"person_drawing small\" data-id=\"#{person.id}\"></div></div>")
      portrait.append(drawEl)

      draw = new PersonDrawing(drawEl.find('.person_drawing'), kind, person.name)
      draw.setAge(person.ageInYear(finData['current_year']))
      draw.setProfession(person.profession)
      left += 100
    )



window.PeopleList = PeopleList