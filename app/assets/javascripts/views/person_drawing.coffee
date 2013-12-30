class PersonDrawing
  constructor: (@el, @role, @name) ->
    @accessories = {}
    if @role
      body = $('<div class="body"></div>')
      path = image_path('people/'+@role+'.png')
      body.append($("<img src=\"#{path}\">"))
      body.append($('<div class="accessories"></div>'))

      details = $('<div class="details"></div>')
      details.append("<div class=\"name\">#{@name}</div>")
      details.append("<div class=\"age\"></div>")

      @el.append(body).append(details)

    @draw()

  clearAccessories: ->
    @accessories = {}

  setProfession: (profession) ->
    @clearAccessories()

    if profession == 'Software Engineer'
      @accessories['hand'] = 'keyboard'
    else if profession == 'Chef'
      @accessories['hat'] = 'chef'

    @draw()

  setAge: (age) ->
    @el.find('.details .age').html("(#{age} years old)")

  draw: ->
    @el.find('.accessories').html('')
    if @accessories['hand']
      @el.find('.accessories').append('<img class="hand" src="/assets/people/accessories/hand_'+@accessories['hand']+'.png"></img>')
    if @accessories['hat']
      @el.find('.accessories').append('<img class="hat" src="/assets/people/accessories/hat_'+@accessories['hat']+'.png"></img>')


window.PersonDrawing = PersonDrawing