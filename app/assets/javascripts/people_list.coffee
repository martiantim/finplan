class PeopleList extends NiceList
  constructor: (el, @plan) ->
    that = this
    super(el, {
      click: (itemID) ->
        that.showPerson itemID       
    })

  showPerson: (itemID) ->
    $("#manipulator_options").load('/plan_users/'+itemID+'?plan_id='+@plan.id)

window.PeopleList = PeopleList