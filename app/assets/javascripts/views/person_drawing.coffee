class PersonDrawing
  constructor: (@el, @role) ->
    @accessories = {}
    if @role
      path = image_path('people/'+@role+'.png')
      @el.append($("<img src=\"#{path}\">"))
      @el.append($('<div class="accessories"></div>'))

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

  draw: ->
    @el.find('.accessories').html('')
    console.log(@accessories)
    if @accessories['hand']
      @el.find('.accessories').append('<img src="/assets/people/accessories/hand_'+@accessories['hand']+'.png" style="position:absolute;left:0px;top:375px"></img>')
    if @accessories['hat']
      @el.find('.accessories').append('<img src="/assets/people/accessories/hat_'+@accessories['hat']+'.png" style="position:absolute;left:0px;top:0px"></img>')


window.PersonDrawing = PersonDrawing