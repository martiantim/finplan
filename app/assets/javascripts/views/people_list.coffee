class PeopleList extends NiceList
  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'users'
    })

  extraWireItem: (itemID) ->
    @drawing = new PersonDrawing(@viewer().find('.user_drawing'))
    profession = @viewer().find('#user_profession_id option:selected').text()
    @drawing.setProfession(profession)

    @viewer().find('#user_profession_id').change =>
      profession = @viewer().find('#user_profession_id option:selected').text()
      @drawing.setProfession(profession)


window.PeopleList = PeopleList