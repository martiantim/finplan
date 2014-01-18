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
    html += "  <div class=\"achievements col\">#{@achievements()}</div>"
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
  
  achievements: ->
    log = @simContext.balances.logForYear(@year)
    html = ""
    html += @showBalances(@simContext.balances.snapshotForYear(@year), log)
    html

  showBalances: (snap, log) ->
    html = ""
    for name, amnt of snap.accountBalances
      if amnt != 0
        html += @showBalance(name, amnt, log)
    html
  
  showBalance: (name, amount, log) ->
    cnt = 0
    log.each_entry_of_kind "account:#{name}", (entry) ->
      cnt++

    html = "<div class='entry title'><div class='name'>[<a href='#' class='expander' style='width:15px;display:inline-block;text-align:center;#{'display:none' if cnt == 0}' data-kind='account:#{name}'>+</a>] #{name}</div><div class='amount'>#{FUtils.formatMoney(amount)}</div></div>"
    html += "<div class='kind_details' data-kind=\"account:#{name}\" style='display:none'>"
    log.each_entry_of_kind "account:#{name}", (entry) ->
      html += "<div class='entry detail'><div class='name'>#{entry.description}</div><div class='amount money'>#{entry.amount}</div></div>"
    html += "</div>"
    html

  marketChanges: ->
    html = '<div class="market_performance"><ul>'
    for itype in @simContext.markets.ITYPES
      if itype != 'None'
        rates = @simContext.markets.ratesForYear(@year)
        html += "<li>#{itype}: <span class=\"percentage\">#{rates[itype]*100}</span></li>"

    html += "</ul></div>"
    html

  yearChanges: ->
    log = @simContext.balances.logForYear(@year)
    html = @kindChanges(log, 'Income')
    html += @kindChanges(log, 'Taxes')
    html += @kindChanges(log, 'Living')
    html += @kindChanges(log, 'Capital', 'Goal Spending')
    html += @kindChanges(log, 'Savings')
    html
  
  kindChanges: (log, kind, title) ->
    title = kind if !title

    html = "<div class='entry title'><div class='name'>[<a href='#' class='expander' style='width:15px;display:inline-block;text-align:center;' data-kind='#{kind}'>+</a>] #{title}</div><div class='amount'>#{FUtils.formatMoney(log.sumOfKind(kind))}</div></div>"
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
        $(this).text('+')
      else
        kd.show()
        $(this).text('-')
  
window.ResultsByyearYear = ResultsByyearYear