class PersonDrawing
  constructor: (@el, @role, @name) ->
    @accessories = {}

    if !@role
      @role = el.attr('data-role')

    body = $('<div class="body"></div>')
    path = image_path('people/'+(@role || '')+'.png')
    body.append($("<img src=\"#{path}\">"))
    body.append($('<div class="accessories"></div>'))

    details = $('<div class="details"></div>')
    details.append("<div class=\"name\">#{@name}</div>") if @name
    details.append("<div class=\"age\"></div>")

    @el.append(body).append(details)

    if el.attr('data-profession')
      @setProfession(el.attr('data-profession'))
    @draw()

  clearAccessories: ->
    @accessories = {}

  setGender: (gender) ->
    if gender == 'M'
      @role = 'man'
    else if gender == 'F'
      @role = 'woman'
    else
      @role = ''
    @draw()

  setProfession: (profession) ->
    @clearAccessories()

    if profession == 'Software Engineer'
      @accessories = ['keyboard']
    else if profession == 'Chef'
      @accessories = ['chef_hat']
    else if profession == 'Waiter'
      @accessories = ['tie', 'servingtray']
    else if profession == 'Pirate'
      @accessories = ['parrot', 'eyepatch']
    else if profession == 'Nurse'
      @accessories = ['nurse_hat']
    else if profession == 'Doctor'
      @accessories = ['stethoscope', 'doctor_headpiece']
    else if profession == 'Lawyer'
      @accessories = ['tie', 'briefcase']
    else if profession == 'Teacher'
      @accessories = ['teacher_props']
    else if profession == 'Acrobat'
      @accessories = ['juggling_balls']

    @draw()

  setAge: (age) ->
    @el.find('.details .age').html("(#{age} years old)")

  draw: ->
    @el.find('.body > img').attr('src', image_path('people/'+(@role || '')+'.png'))

    @el.find('.accessories').html('')
    for obj in @accessories
      console.log("obj = #{obj}")
      @el.find('.accessories').append('<img src="/assets/people/accessories/'+obj+'.png"></img>')
#    if @accessories['hand']
#      @el.find('.accessories').append('<img class="hand" src="/assets/people/accessories/hand_'+@accessories['hand']+'.png"></img>')
#    if @accessories['hat']
#      @el.find('.accessories').append('<img class="hat" src="/assets/people/accessories/hat_'+@accessories['hat']+'.png"></img>')


window.PersonDrawing = PersonDrawing