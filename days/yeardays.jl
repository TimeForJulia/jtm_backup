# source : yeardays.jl  (./extras/tm4julia/days/)
# partof : Time for Julia
#
# purpose: provide ymdhms normalization
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-05 in New York, USA

export daysToMonthEndJulian,     daysToPriorMonthEndJulian,      daysToNextMonthEndJulian,
       daysToMonthEndGregorian,  daysToPriorMonthEndGregorian,   daysToNextMonthEndGregorian,
       daysToMonthEndCommon,     daysToPriorMonthEndCommon,      daysToNextMonthEndCommon,

       daysToMonthStartJulian,    daysToPriorMonthStartJulian,    daysToNextMonthStartJulian,
       daysToMonthStartGregorian, daysToPriorMonthStartGregorian, daysToNextMonthStartGregorian,
       daysToMonthStartCommon,    daysToPriorMonthStartCommon,    daysToNextMonthStartCommon



function daysToMonthEndJulian(yr::Int, mo::Int)
  ans  = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearJulian(yr)))
  ans
end

function daysToMonthEndGregorian(yr::Int, mo::Int)
  ans  = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearGregorian(yr)))
  ans
end

function daysToMonthEndCommon(yr::Int, mo::Int)
  ans  = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearCommon(yr)))
  ans
end

function daysToMonthEndCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  =  [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearCommon(yr, firstGregorianYear)))
  ans
end


function daysToPriorMonthEndJulian(yr::Int, mo::Int)
  ans  = [31, 62, 90, 121, 151, 182, 212, 243, 274, 304, 335, 365][mo]
  ans += ((mo >= 3) && (isLeapYearJulian(yr)))
  ans
end

function daysToPriorMonthEndGregorian(yr::Int, mo::Int)
  ans  = [31, 62, 90, 121, 151, 182, 212, 243, 274, 304, 335, 365][mo]
  ans += ((mo >= 3) && (isLeapYearGregorian(yr)))
  ans
end

function daysToPriorMonthEndCommon(yr::Int, mo::Int)
  ans  = [31, 62, 90, 121, 151, 182, 212, 243, 274, 304, 335, 365][mo]
  ans += ((mo >= 3) && (isLeapYearCommon(yr)))
  ans
end

function daysToPriorMonthEndCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  = [31, 62, 90, 121, 151, 182, 212, 243, 274, 304, 335, 365][mo]
  ans += ((mo >= 3) && (isLeapYearCommon(yr, firstGregorianYear)))
  ans
end


function daysToNextMonthEndJulian(yr::Int, mo::Int)
  ans  = [28, 59, 89, 120, 150, 181, 212, 242, 273, 303, 334, 365][mo]
  ans += ((mo >= 1) && (isLeapYearJulian(yr)))
  ans
end

function daysToNextMonthEndGregorian(yr::Int, mo::Int)
  ans  = [28, 59, 89, 120, 150, 181, 212, 242, 273, 303, 334, 365][mo]
  ans += ((mo >= 1) && (isLeapYearGregorian(yr)))
  ans
end

function daysToNextMonthEndCommon(yr::Int, mo::Int)
  ans  = [28, 59, 89, 120, 150, 181, 212, 242, 273, 303, 334, 365][mo]
  ans += ((mo >= 1) && (isLeapYearCommon(yr)))
  ans
end

function daysToNextMonthEndCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  = [28, 59, 89, 120, 150, 181, 212, 242, 273, 303, 334, 365][mo]
  ans += ((mo >= 1) && (isLeapYearCommon(yr,firstGregorianYear)))
  ans
end

# days to start of month


function daysToMonthStartJulian(yr::Int, mo::Int)
  ans  = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334][mo]
  ans += ((mo >= 3) && (isLeapYearJulian(yr)))
  ans
end

function daysToMonthStartGregorian(yr::Int, mo::Int)
  ans  = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334][mo]
  ans += ((mo >= 3) && (isLeapYearGregorian(yr)))
  ans
end

function daysToMonthStartCommon(yr::Int, mo::Int)
  ans  = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334][mo]
  ans += ((mo >= 3) && (isLeapYearCommon(yr)))
  ans
end

function daysToMonthStartCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  =  [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334][mo]
  ans += ((mo >= 3) && (isLeapYearCommon(yr, firstGregorianYear)))
  ans
end


function daysToPriorMonthStartJulian(yr::Int, mo::Int)
  ans  = [-31, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304][mo]
  ans += ((mo >= 4) && (isLeapYearJulian(yr)))
  ans
end

function daysToPriorMonthStartGregorian(yr::Int, mo::Int)
  ans  = [-31, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304][mo]
  ans += ((mo >= 4) && (isLeapYearGregorian(yr)))
  ans
end

function daysToPriorMonthStartCommon(yr::Int, mo::Int)
  ans  = [-31, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304][mo]
  ans += ((mo >= 4) && (isLeapYearCommon(yr)))
  ans
end

function daysToPriorMonthStartCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  = [-31, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304][mo]
  ans += ((mo >= 4) && (isLeapYearCommon(yr, firstGregorianYear)))
  ans
end


function daysToNextMonthStartJulian(yr::Int, mo::Int)
  ans  = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearJulian(yr)))
  ans
end

function daysToNextMonthStartGregorian(yr::Int, mo::Int)
  ans  = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearGregorian(yr)))
  ans
end

function daysToNextMonthStartCommon(yr::Int, mo::Int)
  ans  = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearCommon(yr)))
  ans
end

function daysToNextMonthStartCommon(yr::Int, mo::Int, firstGregorianYear::Int)
  ans  = [31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365][mo]
  ans += ((mo >= 2) && (isLeapYearCommon(yr,firstGregorianYear)))
  ans
end


# eof #
