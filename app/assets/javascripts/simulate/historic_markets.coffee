class HistoricMarkets
  constructor: () ->

  @rateForYear: (year, itype) ->
    historicYear = (year - 2014 + 5)%28+1985
    window.HISTORIC_RATES[historicYear][itype]/100

window.HistoricMarkets = HistoricMarkets
window.HISTORIC_RATES = {
  1985: {
    Inflation: 3.60,
    Stock: 31.24,
    Bonds: 7.49,
    'International Stock': 14.70,
    'Money Market': 8.53,
    Mortgage: 11.55
  },
  1986: {
    Inflation: 1.90,
    Stock: 18.49,
    Bonds: 6.04,
    'International Stock': 18.90,
    'Money Market': 6.75,
    Mortgage: 10.17
  },
  1987: {
    Inflation: 3.60,
    Stock: 5.81,
    Bonds: 5.72,
    'International Stock': 2.00,
    'Money Market': 6.92,
    Mortgage: 9.31
  },
  1988: {
    Inflation: 4.10,
    Stock: 16.54,
    Bonds: 6.45,
    'International Stock': 4.70,
    'Money Market': 7.66,
    Mortgage: 9.19
  },
  1989: {
    Inflation: 4.80,
    Stock: 31.48,
    Bonds: 8.11,
    'International Stock': 35.10,
    'Money Market': 8.65,
    Mortgage: 10.13
  },
  1990: {
    Inflation: 5.40,
    Stock: -3.06,
    Bonds: 7.55,
    'International Stock': -11.50,
    'Money Market': 7.92,
    Mortgage: 10.05
  },
  1991: {
    Inflation: 4.20,
    Stock: 30.23,
    Bonds: 5.61,
    'International Stock': 16.30,
    'Money Market': 6.03,
    Mortgage: 9.32
  },
  1992: {
    Inflation: 3.00,
    Stock: 7.49,
    Bonds: 3.41,
    'International Stock': 14.20,
    'Money Market': 3.78,
    Mortgage: 8.24
  },
  1993: {
    Inflation: 3.00,
    Stock: 9.97,
    Bonds: 2.98,
    'International Stock': 20.10,
    'Money Market': 3.16,
    Mortgage: 7.20
  },
  1994: {
    Inflation: 2.60,
    Stock: 1.33,
    Bonds: 3.99,
    'International Stock': -10.30,
    'Money Market': 4.01,
    Mortgage: 7.49
  },
  1995: {
    Inflation: 2.80,
    Stock: 37.20,
    Bonds: 5.52,
    'International Stock': 20.30,
    'Money Market': 5.39,
    Mortgage: 7.87
  },
  1996: {
    Inflation: 3.00,
    Stock: 22.68,
    Bonds: 5.02,
    'International Stock': 11.60,
    'Money Market': 4.95,
    Mortgage: 7.80
  },
  1997: {
    Inflation: 2.30,
    Stock: 33.10,
    Bonds: 5.05,
    'International Stock': 24.70,
    'Money Market': 5.15,
    Mortgage: 7.71
  },
  1998: {
    Inflation: 1.60,
    Stock: 28.34,
    Bonds: 4.73,
    'International Stock': 14.50,
    'Money Market': 4.81,
    Mortgage: 7.07
  },
  1999: {
    Inflation: 2.20,
    Stock: 20.89,
    Bonds: 4.51,
    'International Stock': 17.80,
    'Money Market': 4.55,
    Mortgage: 7.04
  },
  2000: {
    Inflation: 3.40,
    Stock: -9.03,
    Bonds: 5.76,
    'International Stock': -10.20,
    'Money Market': 5.46,
    Mortgage: 7.52
  },
  2001: {
    Inflation: 2.80,
    Stock: -11.85,
    Bonds: 3.67,
    'International Stock': -16.20,
    'Money Market': 3.60,
    Mortgage: 7.00
  },
  2002: {
    Inflation: 1.60,
    Stock: -21.97,
    Bonds: 1.66,
    'International Stock': -24.50,
    'Money Market': 1.98,
    Mortgage: 6.43
  },
  2003: {
    Inflation: 2.30,
    Stock: 28.36,
    Bonds: 1.03,
    'International Stock': 13.60,
    'Money Market': 1.20,
    Mortgage: 5.80
  },
  2004: {
    Inflation: 2.70,
    Stock: 10.74,
    Bonds: 1.23,
    'International Stock': 7.50,
    'Money Market': 1.45,
    Mortgage: 5.77
  },
  2005: {
    Inflation: 3.40,
    Stock: 4.83,
    Bonds: 3.01,
    'International Stock': 16.70,
    'Money Market': 2.77,
    Mortgage: 5.94
  },
  2006: {
    Inflation: 3.20,
    Stock: 15.61,
    Bonds: 4.68,
    'International Stock': 10.70,
    'Money Market': 3.64,
    Mortgage: 6.63
  },
  2007: {
    Inflation: 2.80,
    Stock: 5.48,
    Bonds: 4.64,
    'International Stock': 3.80,
    'Money Market': 3.65,
    Mortgage: 6.41
  },
  2008: {
    Inflation: 3.80,
    Stock: -36.55,
    Bonds: 1.59,
    'International Stock': -31.30,
    'Money Market': 2.36,
    Mortgage: 6.05
  },
  2009: {
    Inflation: -0.40,
    Stock: 25.94,
    Bonds: 0.14,
    'International Stock': 22.10,
    'Money Market': 1.16,
    Mortgage: 5.14
  },
  2010: {
    Inflation: 1.60,
    Stock: 14.82,
    Bonds: 0.13,
    'International Stock': 9.00,
    'Money Market': 0.65,
    Mortgage: 4.80
  },
  2011: {
    Inflation: 3.20,
    Stock: 2.10,
    Bonds: 0.03,
    'International Stock': -5.60,
    'Money Market': 0.48,
    Mortgage: 4.69
  },
  2012: {
    Inflation: 2.10,
    Stock: 15.89,
    Bonds: 0.05,
    'International Stock': 5.80,
    'Money Market': 0.30,
    Mortgage: 4.45
  },
  2013: {
    Inflation: 1.50,
    Stock: 32.15,
    Bonds: 0.07,
    'International Stock': 14.40,
    'Money Market': 0.86,
    Mortgage: 3.66
  }
}