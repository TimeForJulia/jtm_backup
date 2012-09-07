# source : monthdays.jl  (./extras/tm4julia/days/)
# partof : Time for Julia
#
# purpose: provide ymdhms normalization
#
# author : Jeffrey A. Sarnoff
# created: 2012-Jun-21 in New York, USA
# revised: 2012-Aug-10

export daysInMonthJulian, daysInPriorMonthJulian, daysInNextMonthJulian,
       daysInMonthGregorian, daysInPriorMonthGregorian, daysInNextMonthGregorian,
       daysInMonthCommon, daysInPriorMonthCommon, daysInNextMonthCommon



function daysInMonthJulian(yr::Int, mo::Int)
  ans  = [31,28,31,30,31,30,31,31,30,31,30,31][mo]
  ans += ((mo == 2) && (isLeapYearJulian(yr)))
  ans
end

function daysInMonthGregorian(yr::Int, mo::Int)
  ans  = [31,28,31,30,31,30,31,31,30,31,30,31][mo]
  ans += ((mo == 2) && (isLeapYearGregorian(yr)))
  ans
end

function daysInMonthCommon(yr::Int, mo::Int)
  ans  = [31,28,31,30,31,30,31,31,30,31,30,31][mo]
  ans += ((mo == 2) && (isLeapYearCommon(yr)))
  ans
end

function daysInMonthCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  = [31,28,31,30,31,30,31,31,30,31,30,31][mo]
  ans += ((mo == 2) && (isLeapYearCommon(yr, firstGregorianYear)))
  ans
end


function daysInPriorMonthJulian(yr::Int, mo::Int)
  ans  = [31,31,28,31,30,31,30,31,31,30,31,30][mo]
  ans += ((mo == 3) && (isLeapYearJulian(yr)))
  ans
end

function daysInPriorMonthGregorian(yr::Int, mo::Int)
  ans  = [31,31,28,31,30,31,30,31,31,30,31,30][mo]
  ans += ((mo == 3) && (isLeapYearGregorian(yr)))
  ans
end

function daysInPriorMonthCommon(yr::Int, mo::Int)
  ans  = [31,31,28,31,30,31,30,31,31,30,31,30][mo]
  ans += ((mo == 3) && (isLeapYearCommon(yr)))
  ans
end

function daysInPriorMonthCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  = [31,31,28,31,30,31,30,31,31,30,31,30][mo]
  ans += ((mo == 3) && (isLeapYearCommon(yr, firstGregorianYear)))
  ans
end


function daysInNextMonthJulian(yr::Int, mo::Int)
  ans  = [28,31,30,31,30,31,31,30,31,30,31,31][mo]
  ans += ((mo == 1) && (isLeapYearJulian(yr)))
  ans
end

function daysInNextMonthGregorian(yr::Int, mo::Int)
  ans  = [28,31,30,31,30,31,31,30,31,30,31,31][mo]
  ans += ((mo == 1) && (isLeapYearGregorian(yr)))
  ans
end

function daysInNextMonthCommon(yr::Int, mo::Int)
  ans  = [28,31,30,31,30,31,31,30,31,30,31,31][mo]
  ans += ((mo == 1) && (isLeapYearCommon(yr)))
  ans
end

function daysInNextMonthCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  = [28,31,30,31,30,31,31,30,31,30,31,31][mo]
  ans += ((mo == 1) && (isLeapYearCommon(yr,firstGregorianYear)))
  ans
end


# eof #
