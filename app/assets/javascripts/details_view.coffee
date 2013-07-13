class DetailsView
  constructor: (@year, @balances) ->

  
  render: ->
    $('#details').html @getHTML()
    $('#details').show()
    @_wire()
  
  getHTML: ->
    html =  "<div class=\"title\"><h2>Year #{@year}</h2></div>"
    html += "<div class=\"clearit\">"
    html += "  <div class=\"numbers section\">#{@yearChanges()}</div>"       
    html += "  <div class=\"achievements section\">#{@achievements()}</div>"       
    html += "  <div class=\"people section\">#{@people()}</div>"       
    html += "</div>"
    html

  personIMG: (name, left, top) ->
    path = image_path('people/'+name+'.png')
    "<img src=#{path}/ style=\"left: #{left}px;top: #{top}px;\">"

  people: ->
    html =  "<div class='people'>"
    html += "#{@personIMG('man')}"
    html += "#{@personIMG('woman', 100)}"
    html += "#{@personIMG('cat', 70, 140)}"
    html += "</div>"
    html
  
  achievements: ->
    log = @balances.logForYear(@year)
    html = @kindChanges(log, 'Capital')
    html

  yearChanges: ->
    log = @balances.logForYear(@year)
    html = @kindChanges(log, 'Income')
    html += @kindChanges(log, 'Taxes')
    html += @kindChanges(log, 'Living')
    html += @kindChanges(log, 'Savings')
    html
  
  kindChanges: (log, kind) ->    
    html = "<div class='entry title'><div class='name'>[<a href='#' class='expander' data-kind='#{kind}'>+</a>] #{kind}</div><div class='amount'>#{FUtils.formatMoney(log.sumOfKind(kind))}</div></div>"        
    html += "<div class='kind_details' data-kind=\"#{kind}\" style='display:none'>"
    log.each_entry_of_kind kind, (entry) ->
      html += "<div class='entry detail'><div class='name'>#{entry.description}</div><div class='amount'>#{FUtils.formatMoney(entry.amount)}</div></div>"
    html += "</div>"
    html

  _wire: ->
    $('#details .expander').click ->
      kind = $(this).attr('data-kind')
      console.log kind
      kd = $("#details .kind_details[data-kind=\"#{kind}\"]")
      if kd.css('display') == 'block'
        kd.hide()
        $(this).text('+')
      else
        kd.show()
        $(this).text('-')
  
window.DetailsView = DetailsView