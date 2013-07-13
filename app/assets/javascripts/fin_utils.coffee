class FUtils
  @formatMoney: (n) ->  
    sign = ''
    if n < 0
      sign = '-'
    n = Math.abs(n|0)
    
    nstr = n + ''
    str = ""
    while nstr.length > 3
      str = ',' + str if str.length > 0
      str = nstr.substring(nstr.length-3, nstr.length) + str
      nstr = nstr.substring(0, nstr.length-3)

    str = ',' + str if str.length > 0    
    "#{sign}$#{nstr}#{str}"
    
window.FUtils = FUtils