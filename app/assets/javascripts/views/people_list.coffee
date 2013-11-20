class PeopleList extends NiceList
  constructor: (@wrapper, @plan) ->
    super(@wrapper, {
      controller: 'users'
    })

window.PeopleList = PeopleList