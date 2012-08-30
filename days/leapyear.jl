# source : leapyear.jl (./extras/tm4julia/days/)
# partof : Time for Julia
#
# purpose: leapyear tests for Gregorian, Julian and Common calendars
#
# author : Jeffrey A. Sarnoff
# created: 2012-Jun-15 in New York, USA
# revised: 2012-Aug-07
#
# offers : isLeapYearJulian, isLeapYearGregorian, isLeapYearCommon


# These tests work for positive and negative years
#  (isLeapYearGregorian(-abs(y)) == isLeapYearGregorian(y))

isLeapYearGregorian(y::Integer) = ((y % 4) == 0) ? (((y % 100) != 0) | ((y % 400) == 0)) : false;

isLeapYearJulian(y::Integer)    = ((y % 4) == 0)


# isLeapYearCommon(year) = 
#   (year >= 1582) ? isGregorianLeapYear(year) : isJulianLeapYear(year)

function isLeapYearCommon(year::Integer) # year of date
  if ((y % 4) == 0)
     (year < 1582) || (((y % 100) != 0) | ((y % 400) == 0))
  else   
     false
  end       
end
