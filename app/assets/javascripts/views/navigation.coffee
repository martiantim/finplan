class Navigation
  constructor: (showNav, showSubNav)->
    @_wireNavigation()
    @_wireSubNavigation()
    $("#navigation li a[data-section=\"#{showNav}\"]").click()    
    @currentSection().find("#subnav a[data-content=\"#{showSubNav}\"]").click()    
    
  _wireNavigation: ->
    that = this
    $('#navigation li a').click ->
      $('.section').hide()      
      name = $(this).attr('data-section')
      section = that._sectionOfName(name)
      section.show()
      
      $('#navigation li a').removeClass('active')
      $(this).addClass('active')
      
      if section.find('#subnav a.active').length == 0
        section.find('#subnav a:first').click()
        
      if name == 'results'
        plan.onResultsClick()
        
      false

  _wireSubNavigation: ->
    that = this
    $('.section').each ->
      section = $(this)
      sectionName = section.attr('data-name')
      section.find('#subnav a').click ->
        section.find('.content').hide()
        contentName = $(this).attr('data-content')
        that._subSectionOfName(sectionName, contentName).show()
            
        section.find('#subnav a').removeClass('active')
        $(this).addClass('active')
        
        if contentName == 'graph'
          plan.onChartDisplay()
          
        false
  
  _sectionOfName: (name) ->
    $(".section[data-name=\"#{name}\"]")
    
  _subSectionOfName: (section, name) ->
    @_sectionOfName(section).find(".content[data-name=\"#{name}\"]")

  currentSection: ->
    sectionName = $('#navigation li a.active').attr('data-section')
    @_sectionOfName(sectionName)

  jumpToSection: (name) ->
    $("a[data-content=\"#{name}\"]").click()

  showDirty: (val) ->
    span = $('#navigation li[data-section="results"] span')
    if val == true
      span.show()
    else
      span.hide()

window.Navigation = Navigation