# source : jas_daynum.jl  (./extras/tm4julia/days/)
# partof : Time for Julia
#
# purpose: provide interconvertable integer mapped dates
#
# author : Jeffrey A. Sarnoff
#
# created: 2012-Jun-15
# refined: 2012-Aug-07
# settled: 2012-Sep-02

export _ymd_to_daynum, 
       ymd_to_daynum, daynum_to_ymd, ymd_to_secnum, secnum_to_ymd,
       daynum_to_secnum, secnum_to_daynum, secnum_to_daysec, daysec_to_secnum,
       ymd_to_secnum, secnum_to_ymd, ymdsec_to_secnum, secnum_to_ymdsec,

       _minYear, _maxYear, _topYear, 
       _minDayNumber, _maxDayNumber, _topDayNumber,
       _minSecNumber, _maxSecNumber, _topSecNumber,

       _NIX_day0, _NIX_day0sec,
       _TAI_day0, _TAI_day0sec,
       _MJD_day0, _MJD_day0sec

# algorithmic parameters 

const _topYear  = 4000
const _minYear  = 1 - _topYear
const _maxYear  = 0 - _minYear




# verified
# daynum_to_ymd(unchecked_ymd_to_daynum(y,m,d)) == y,m,d forall dates allowed

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
#   to obtain the corresponding Int64 daynum subtract 1607067
#
#   (y,m,d)       --> daynum, Int64 correspondant
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


# _ymd_to_daynum original form
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


function _ymd_to_daynum(y::Int, m::Int, d::Int)
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
     _ymd_to_daynum(y,m,d)
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


# daynum --> secnum =def= daynum * _daysecs
# secnum is proleptic Gregorian + year 0 TAI: SI seconds, no leap seconds

daynum_to_secnum(daynum::Int64) = daynum * _daysecs
secnum_to_daynum(secnum::Int64) = div(secnum, _daysecs)
secnum_to_daysec(secnum::Int64) = quorem(secnum, _daysecs)
daysec_to_secnum(daynum::Int64, secs::Int) = daynum_to_secnum(daynum) + secs

ymd_to_secnum(y::Int, m::Int, d::Int) = daynum_to_secnum( ymd_to_daynum(y,m,d) )
secnum_to_ymd(secnum::Int64) = daynum_to_ymd( idiv(secnum, _daysecs) )
ymdsec_to_secnum(y::Int, m::Int, d::Int, s::Int) = ymd_to_secnum(y,m,d) + s
function secnum_to_ymdsec(secnum::Int64) 
    q,r = quorem(secnum, _daysecs)
    y,m,d = daynum_to_ymd(q) 01-Jan-1970 00:00:00 UTC,
    y,m,d,r
end

function daynum_to_yearday(daynum::Int64)
    y,m,d = daynum_to_ymd(daynum)
    y, (days_to_month_start(m) + d)
end
yearday_to_daynum(year::Int, yday::Int) = ymd_to_daynum(year,1,1)+yday

secnum_to_yearday(secnum::Int64) = 
  y,m,d = secnum_to_ymd(secnum)
  y, (days_to_month_start(m) + d)
end
yearday_to_secnum(year::Int, yday::Int) = daynum_to_secnum(yearday_to_daynum(year,yday))

function daysec_to_yearsec(daynum::Int64, secs::Int)
   y,m,d = daynum_to_ymd(daynum)
   secs += daynum_to_secnum(days_to_month_start(m) + d)
   y,secs
end
yearsec_to_daysec(year::Int, secs::Int)
   sdnum = secnum_to_daynum(secs)
   snum  = secs - daynum_to_secnum(sdnum)
   dnum = yearday_to_daynum(year, sdnum)
   dnum, snum
end



# daynum, secnum <--> time_t seconds since Unix Epoch 
# Unix Epoch: 01-Jan-1970 00:00:00 UTC  ~ 01-Jan-1970 00:00:10 TAI (IANA library uses this)

const Unix_Epoch_day0 = ymd_to_daynum(1970,  1,  1)
const Unix_Epoch_sec0 = daynum_to_secnum(Unix_Epoch_day0)

daynum_to_unix_daynum(daynum::Int64)       =  daynum  - Unix_Epoch_day0
unix_daynum_to_daynum(unixnum::Int64)      =  unixnum + Unix_Epoch_day0
unix_daynum_to_ymd(unixnum::Int64)         =  daynum_to_ymd(unix_daynum_to_daynum(unixnum))
ymd_to_unix_daynum(y::Int, m::Int, d::Int) =  daynum_to_unix_daynum(ymd_to_daynum(y,m,d))

secnum_to_unix_secnum(secnum::Int64)       =  secnum  - Unix_Epoch_sec0
unix_secnum_to_secnum(unixnum::Int64)      =  unixnum + Unix_Epoch_sec0
daynum_to_unix_secnum(daynum::Int64)       =  secnum_to_unix_secnum( daynum_to_secnum(daynum) )
unix_secnum_to_daynum(unixnum::Int64)      =  secnum_to_daynum( unix_secnum_to_secnum(unixnum) )
unix_secnum_to_daysec(unixnum::Int64)      =  secnum_to_daysec( unix_secnum_to_secnum(unixnum) )
daysec_to_unix_secnum(daynum::Int64, secs::Int) = daynum_to_unix_secnum(daynum) + secs

ymd_to_unix_secnum(y::Int, m::Int, d::Int) = secnum_to_unix_secnum(ymd_to_secnum(y,m,d))
ymdsec_to_unix_secnum(y::Int, m::Int, d::Int, s::Int) = secnum_to_unix_secnum(ymd_to_secnum(y,m,d) + s)
unix_secnum_to_ymd(unixnum::Int64)         = daynum_to_ymd(secnum_to_daynum(unix_secnum_to_secnum(unixnum)))
function unix_secnum_to_ymdsec(unixnum::Int64)
    dnum,s = unix_secnum_daysec(unixnum)
    y,m,d  = daynum_to_ymd(dnum)
    y,m,d,s
end


# TAI  Epoch: 01-Jan-1958 00:00:00 GMT  TAI is based on one day being exactly 86,400 seconds


# daynum extrema

const _minDayNumber = ymd_to_daynum(_minYear,  1,  1)
const _maxDayNumber = ymd_to_daynum(_maxYear, 12, 31)
const _topDayNumber = _maxDayNumber + 1

const _minSecNumber = _minDayNumber * _daysecs
const _maxSecNumber = _maxDayNumber * _daysecs + 
                          ifloor((_maxYear-2012)*((2012-1972)/_leapsecs))
const _topSecNumber = _maxSecNumber + 1


# daycounts given as Modified Julian Dates and as relative to TAI and Unix Epochs

const _MJD_day0 = ymd_to_daynum(1858, 11, 17)
const _TAI_day0 = ymd_to_daynum(1958,  1,  1)
const _NIX_day0 = ymd_to_daynum(1970,  1,  1)

const _MJD_day0sec = ymd_to_daynum(1858, 11, 17) * _daysecs
const _TAI_day0sec = ymd_to_daynum(1958,  1,  1) * _daysecs
const _NIX_day0sec = ymd_to_daynum(1970,  1,  1) * _daysecs

daynum_to_nixday(daynum::Integer)     =  daynum - _NIX_day0
nixday_to_daynum(nixday::Integer)     =  nixday + _NIX_day0
nixday_to_ymd(nixday::Integer)        =  daynum_to_ymd(nixday_to_daynum(nixday))
ymd_to_nixday(y::Int, m::Int, d::Int) =  daynum_to_nixday(ymd_to_daynum(y,m,d))
daynum_to_nixsec(daynum::Integer)     =  
nixsec_to_daynum(nixsec::Integer)     =  

daynum_to_taiday(daynum::Integer)     =  daynum - _TAI_day0
taiday_to_daynum(taiday::Integer)     =  taiday + _TAI_day0
taiday_to_ymd(taiday::Integer)        =  daynum_to_ymd(taiday_to_daynum(taiday))
ymd_to_taiday(y::Int, m::Int, d::Int) = daynum_to_taiday(ymd_to_daynum(y,m,d))



daynum_to_mjday(daynum::Integer)  =  daynum - _MJD_day0
mjday_to_daynum(mjday::Integer)   =  mjday  + _MJD_day0
mjday_to_ymd(mjday::Integer)      =  daynum_to_ymd(mjday_to_daynum(mjday))


daynum_to_taiday(daynum::Integer) =  daynum - _TAI_day0
taiday_to_daynum(taiday::Integer) =  taiday + _TAI_day0
taiday_to_ymd(taiday::Integer)    =  daynum_to_ymd(taiday_to_daynum(taiday))



nixday_to_mjday(nixday::Integer)  =  daynum_to_mjday(nixday_to_daynum(nixday))
mjday_to_nixday(mjday::Integer)   =  daynum_to_nixday(mjday_to_daynum(mjday))

# eof #
