class PeopleList extends NiceList
  constructor: (el, @plan) ->
    that = this
    super(el, {
      click: (itemID) ->
        that.showPerson itemID       
    })

  viewer: ->
    $("#manipulator_options")

  showPerson: (itemID) ->
    that = this    
    @viewer().load "/plan_users/#{itemID}?plan_id=#{@plan.id}", ->
      that.viewer().find('button.remove').click ->
        that.removePerson itemID
        false

  reload: ->
    el.load "/plan_users", ->
      @reload()

  removePerson: (itemID) ->
    that = this
    $.ajax({
      url: "/plan_users/#{itemID}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        that.viewer().html('')
        that.reload()
      ,error: (request) ->      
        showMessageDialog('error', request.responseText);
      
    })

window.PeopleList = PeopleList