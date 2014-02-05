class ResultsByyearYear
  constructor: (@year, @simContext) ->
  
  render: (el)->
    el.html @getHTML()
    finFormat(el)
    @_setup(el)
    @_wire(el)
  
  getHTML: ->
    html = ''
    html += "<div class=\"clearit cols\">"
    html += "  <div class=\"numbers col\">#{@yearChanges()} #{@marketChanges()}</div>"
    html += "  <div class=\"achievements col\">#{@showBalances()}</div>"
    html += "  <div class=\"people col\">#{@people()}</div>"
    html += "</div>"
    html

  people: ->
    html =  "<div class='people'>"
    pos = 0
    @simContext.family.membersOfYear(@year, (person, kind) =>
      html += "<div class=\"person_wrapper\" style=\"position: absolute;left: #{pos}px;top: 0px\">"
      html += "  <div class=\"person_drawing small\" data-id=\"#{person.id}\"></div>"
      html += '</div>'
      pos += 100
    )
    html += "</div>"
    html

  showBalances: () ->
    snap = @simContext.balances.snapshotForYear(@year)
    log = @simContext.balances.logForYear(@year)
    html = '<div class="panel panel-info"><div class="panel-heading">'
    html += "<h3 class=\"panel-title\">Account Balances</h3></div>"
    html += '<div class="panel-body">'
    for name, amnt of snap.accountBalances
      if amnt != 0 || name == 'checking' || name == 'savings' || name == 'emergency'
        html += @showBalance(name, amnt, log)

    html += "<div class='entry title total'><div class='name'>Net Worth</div><div class='amount money'>#{snap.netWorth()}</div></div>"
    html += "</div></div>"
    html
  
  showBalance: (name, amount, log) ->
    cnt = 0
    log.each_entry_of_kind "account:#{name}", (entry) ->
      cnt++

    html = @_entryTitle(name, "account:#{name}", amount, cnt > 0)
    html += "<div class='kind_details' data-kind=\"account:#{name}\" style='display:none'>"
    log.each_entry_of_kind "account:#{name}", (entry) ->
      html += "<div class='entry detail'><div class='name'>#{entry.description}</div><div class='amount money'>#{entry.amount}</div></div>"
    html += "</div>"
    html

  _entryTitle: (name, kind, amount, expandable) ->
    html = "<div class='entry title'>"
    html += "  <div class='name'>"
    if expandable
      html += "<a href='#' class='expander' style='width:15px;display:inline-block;text-align:center;' data-kind='#{kind}'><span class=\"glyphicon glyphicon-chevron-right\"></span></a>"
    else
      html += "<span class=\"glyphicon glyphicon-chevron-right\"></span>"
    html += " #{name}</div>"
    html += "  <div class='amount money'>#{amount}</div>"
    html += "</div>"
    html

  marketChanges: ->
    html = '<div class="panel panel-success" style="margin-top: 15px;"><div class="panel-heading">'
    html += "<h3 class=\"panel-title\">#{@year} Market Performance</h3></div>"
    html += '<div class="panel-body"><table class="table table-striped" style="width:100%">'
    html += "<thead><tr><th>Investment Type</th><th>Return</th></tr></thead>"
    html += "<tbody>"
    for itype in @simContext.markets.ITYPES
      if itype != 'None'
        rates = @simContext.markets.ratesForYear(@year)
        html += "<tr><td>#{itype}</td><td><span class=\"percentage\">#{rates[itype]*100}</span></td></tr>"

    html += "</tbody></table></div></div>"
    html

  yearChanges: ->
    log = @simContext.balances.logForYear(@year)

    html = '<div class="panel panel-info"><div class="panel-heading">'
    html += "<h3 class=\"panel-title\">Earning and Spending</h3></div>"
    html += '<div class="panel-body">'

    html += @kindChanges(log, 'Income')
    html += @kindChanges(log, 'Taxes')
    html += @kindChanges(log, 'Living')
    html += @kindChanges(log, 'Capital', 'Goal Spending')
    html += @kindChanges(log, 'Savings')

    html += "</div></div>"
    html
  
  kindChanges: (log, kind, title) ->
    title = kind if !title


    sum = log.sumOfKind(kind)
    html = @_entryTitle(title, kind, sum, sum != 0)
    html += "<div class='kind_details' data-kind=\"#{kind}\" style='display:none'>"
    log.each_entry_of_kind kind, (entry) ->
      html += "<div class='entry detail'><div class='name'>#{entry.description}</div><div class='amount money'>#{entry.amount}</div></div>"
    html += "</div>"
    html

  _setup: (el) ->
    @simContext.family.membersOfYear(@year, (person, kind) =>
      drawEl = el.find(".person_drawing[data-id=\"#{person.id}\"]")
      draw = new PersonDrawing(drawEl, kind, person.name)
      draw.setAge(person.ageInYear(@year))

      if @simContext.familyStatus[@year][person.id]['working'] == true
        draw.setProfession(person.profession)

    )

  _wire: (el) ->
    el.find('.expander').click ->
      kind = $(this).attr('data-kind')
      kd = el.find(".kind_details[data-kind=\"#{kind}\"]")
      if kd.css('display') == 'block'
        kd.hide()
        $(this).find('.glyphicon').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-right')
      else
        kd.show()
        $(this).find('.glyphicon').addClass('glyphicon-chevron-down').removeClass('glyphicon-chevron-right')
  
window.ResultsByyearYear = ResultsByyearYear