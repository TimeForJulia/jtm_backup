# source : JAS_daynum.jl  (./extras/tm4julia/days/)
# partof : Time for Julia
#
# purpose: provide interconvertable integer mapped dates
#
# author : Jeffrey A. Sarnoff
#
# created: 2012-Jun-15
# refined: 2012-Aug-07
# settled: 2012-Sep-02

module JAS_daynum

export ymd_to_daynum, daynum_to_ymd, _daynum,
       _minDaynum, _maxDaynum,
       _NIX_day0, _NIX_day0sec,
       _TAI_day0, _TAI_day0sec,
       _MJD_day0, _MJD_day0sec


import Base.*

import Main._minYear
import Main._maxYear

# verified
# daynum2ymd(unchecked_daynum(y,m,d)) == y,m,d forall dates allowed

# convert date into a nonnegative daynum
#   dates change at midnight (a fact not used in this function)
#   months: Jan=1,..,Dec=12, days: 1..31
#   supports years (-4000..,-2,-1,0,1,2,..4000)
#   aligns with the Gregorian 400 year cycle (146907 days)
#      multiples of 400 years have daynums multiples of 146097
#      this is true for positive and for negative years
#   requires year numbered using the non-historical Year 0
#   uses a non-historical proleptic Gregorian calendar
#     historically, year 8 is the first year properly a leap year
#
#   Notes
#   to obtain the corresponding signed daynum subtract 1607067
#
#   (y,m,d)       --> daynum, signed correspondant
#
#   ( 4400, 1, 1) --> 3214134  [and that is the soft clopen upper bound]
#   ( 4399,12,31) --> 3214133  [and that is the soft realized upper bound]
#   ( 1970, 1, 1) --> 2326595  [UNIX date zero]
#   (    1, 1, 1) --> 1607433
#   (    0, 1, 1) --> 1607067  [0 + 4400 Gregorian years]
#   (   -1, 1, 1) --> 1606702
#   (-4399, 1, 1) -->     366  [and that is the soft lower bound]
#   all intervals are clopen so do not use this as a spec:
#         (-4400, 3, 1) -->      60  [and that is the hard lower bound]
#
#   daynum    requires 22 bits (for this date range)
#   hour,min,sec requires 17 bits (for one day)
#                         39 bits (for date and time-of-day)
#
#   timezone num requires  9 bits
#                         48 bits (for date, time-of-day, timezone)
#
#   millisecs    requires 10 bits
#   or year      requires 13 bits

#require("tm4julia/etc/config.jl")


# uncheckd_daynum original form
# function daynum_unsafe(y,m,d)
#    # this is div(((152*m)-2),5) with entries 13,14 folded into 1,2
#    monthdays = [ 397,428,91,122,152,183,213,244,275,305,336,366 ]
#    if (m<3)
#        y += 4399 # y-= 1; y+=4400
#    else
#        y += 4400
#    end
#    int64(d + monthdays[m]+(365*y)+udiv4(y)-udiv100(y)+udiv400(y)-32)
# end


function _daynum(y::Int, m::Int, d::Int)
    # if (m<3)  y += 4399  else  y += 4400  end;
    y += 4400
    y -= (m >= 3) ? 0 : 1
    d += (365*y)
    # assert(y >= 0), tally leap years through year y
    # (+udiv4(y)-udiv100(y)+udiv400(y))
    y100  = (y * 42949673) >> 32
    d    +=  (y>>2) - y100 + (y100 >> 2)
    #  d +=  ( div(((152*m)-2),5) with entries 13,14 folded into 1,2) - 32
    #  monthdays = [ 365, 396, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ]
    d += [ 365, 396, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ][m]
    int64(d)
end


function ymd_to_daynum(y::Int, m::Int, d::Int)
  if (_minYear <= y <= _maxYear)
     _daynum(y,m,d)
  end
end


# this is a date-shifted version of the reference code
# the only change is the addtion of the first line
#
# ref: # http://www.merlyn.demon.co.uk/daycount.htm
# credit appearing on reference page:
# Adapted from Henry Fliegel and Thomas van Flandern, ACM Vol 11, 1968 #
# (by mail from HJW 20051228)


function daynum_to_ymd(J::Int64)
    # J -= 2286008  # untranslate Julian Day Number (1607067 -32 +678973)
    # J = J + 2400001 + 68569
    J += 182562
    # K = div(4*J, 146097)
    K = div( (J<<2), 146097 )
    #J = J - div((146097*K + 3), 4)
    J -= ((146097*K + 3) >> 2)
    Y = div(4000*(J+1), 1461001)
    #J = J - div(1461*Y, 4) + 31
    J -= (((1461*Y) >> 2) - 31)
    M = div(80*J, 2447)
    D = J - div(2447*M,80)
    J = div(M,11)
    #M = M + 2 - 12*J
    M += (2 - 12*J)
    #Y = 100*(K-49) + Y + J
    Y += 100*(K-49) + J
    (Y, M, D)
end


# daynum extrema
const _minDaynum = daynum(_minYear,  1,  1)
const _maxDaynum = daynum(_maxYear, 12, 31)

# daycounts given as Modified Julian Dates and as relative to TAI and Unix Epochs

const _MJD_day0 = daynum(1858, 11, 17)
const _TAI_day0 = daynum(1958,  1,  1)
const _NIX_day0 = daynum(1970,  1,  1)

const _MJD_day0sec = daynum(1858, 11, 17) * 86400
const _TAI_day0sec = daynum(1958,  1,  1) * 86400
const _NIX_day0sec = daynum(1970,  1,  1) * 86400


daynum2mjday(daynum::Integer)  =  daynum - _MJD_day0
mjday2daynum(mjday::Integer)   =  mjday  + _MJD_day0
mjday2ymd(mjday::Integer)      =  daynum2ymd(mjday2daynum(mjday))


daynum2taiday(daynum::Integer) =  daynum - _TAI_day0
taiday2daynum(taiday::Integer) =  taiday + _TAI_day0
taiday2ymd(taiday::Integer)    =  daynum2ymd(taiday2daynum(taiday))


daynum2nixday(daynum::Integer) =  daynum - _NIX_day0
nixday2daynum(nixday::Integer) =  nixday + _NIX_day0
nixday2ymd(nixday::Integer)    =  daynum2ymd(nixday2daynum(nixday))

nixday2mjday(nixday::Integer)  =  daynum2mjday(nixday2daynum(nixday))
mjday2nixday(mjday::Integer)   =  daynum2nixday(mjday2daynum(mjday))


# isLeapYearGregorian(y::Integer) = ((y % 4) == 0) ? (((y % 100) != 0) | ((y % 400) == 0)) : false;

# function monthdaysGregorian(yr::Int, mo::Int)
#   ans = [31,28,31,30,31,30,31,31,30,31,30,31][mo]
#   if ((mo == 2) && (isLeapYearGregorian(yr)))
#      ans+1
#   else
#      ans
#   end
# end


# for y in -4399:4399
#     for m in 1:12

#         for d in 1:monthdaysGregorian(y,m)
#             dnum = unchecked_daynum(y,m,d)
#             yy,mm,dd = daynum2ymd(dnum)
#             if ((yy!=y)||(mm!=m)||(dd!=d))
#                 error("not ok y,m,d=$(y),$(m),$(d) dn=$(dn) yymmdd=$(yy),$(mm),$(dd)",(y,m,d))
#             end
#         end
#     end
# end



end # module

