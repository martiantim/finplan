class PeopleList extends NiceList
  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'plan_users'
    })

  extraWireItem: (itemID) ->
    @drawing = new PersonDrawing(@viewer().find('.person_drawing'))

    @viewer().find('.nav-tabs').click (e) ->
      e.preventDefault()
      $(this).tab('show')

    @viewer().find('#plan_user_profession_id').change =>
      profession = @viewer().find('#plan_user_profession_id option:selected').text()
      @drawing.setProfession(profession)


window.PeopleList = PeopleList