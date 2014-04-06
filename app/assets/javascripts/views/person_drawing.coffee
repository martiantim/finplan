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
    @gender = 'U'
    @age = 0

    if el.attr('data-profession')
      @setProfession(el.attr('data-profession'))
    @draw()

  clearAccessories: ->
    @accessories = {}

  setGender: (gender) ->
    @gender = gender
    @updateRole()

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
    @age = age
    @el.find('.details .age').html("(#{age} years old)")
    @updateRole()

  updateRole: ->
    @role = @getRole(@gender, @age)
    @draw()

  getRole: (gender, age) ->
    if age >= 18
      if gender == 'M'
        "man"
      else if gender == 'F'
        "woman"
      else
        "unsure"
    else if age >= 0
      if gender == 'M'
        "boy"
      else if self.gender == 'F'
        "girl"
      else
        "unsure"
    else
      "baby"

  draw: ->
    @el.find('.body > img').attr('src', image_path('people/'+(@role || '')+'.png'))

    @el.find('.accessories').html('')
    for obj in @accessories
      @el.find('.accessories').append('<img src="/assets/people/accessories/'+obj+'.png"></img>')


window.PersonDrawing = PersonDrawing