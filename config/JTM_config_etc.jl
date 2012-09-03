# source : JTM_config_etc.jl (./extras/tm4julia/config/)
# purpose: provides internal configuration settings
#
# author :p Jeffrey A. Sarnoff
# created: 2012-Jun-18 in New York, USA
# revised: 2012-Aug-14

# module JTM_config_etc

export _daysecs,
       _minDayNumber, _maxDayNumber, _topDayNumber,
       _minSecNumber, _maxSecNumber, _topSecNumber,
       _minDaysNumber, _maxDaysNumber, _topDaysNumber,
       _minSecsNumber, _maxSecsNumber, _topSecsNumber,
       _minYear, _maxYear, _topYear,  # prefer [_min .. _top ), clopen interval
       _minHour, _maxHour, _topHour,  # [ _min .. _max ], inclusive if needed
       _minSec,  _maxSec , _topSec,
       NaV, Unassignable, Unassigned,
       search_gte, checked_search_gte

# import Base.*

const _daysecs  = 86400 # unless leapsecond added
const _leapsecs = 35    # as of 2012-12-31

const _topYear  = 4000
const _minYear  = 1 - _topYear
const _maxYear  = 0 - _minYear
                                   # proleptic Gregorian, as it were
                                   # (see JAS_daynum.jl for details)
const _topDayNumber  = 3068037     #  4000-01-01
const _minDayNumber  =  146463     # -3999-01-01
const _maxDayNumber  = 3068036     #  3999-12-31

const _topSecNumber  = (_topDayNumber * _daysecs) + itrunc(((4000-2012)/(2012-1972))*_leapsecs)
const _minSecNumber  = (_minDayNumber * _daysecs)
const _maxSecNumber  = (_maxDayNumber * _daysecs) + itrunc(((4000-2012)/(2012-1972))*_leapsecs)

const _topDaysNumber = (_topDayNumber - _minDayNumber)
const _minDaysNumber = (0)
const _maxDaysNumber = (_topDayNumber - _minDayNumber - 1)

const _topSecsNumber = (_topSecNumber - _minSecNumber)
const _minSecsNumber = (0)
const _maxSecsNumber = (_topSecNumber - _minSecNumber - 1)


const _maxHour  = 24*8
const _minHour  = 0-_maxHour
const _topHour  = 1+_maxHour

const _maxSec   = 86401
const _minSec   = 0-_maxSec
const _topSec   = 1+_maxSec

# 60*60 == 3600 seconds per hour
# 15 minutes = 15*60 seconds == 900 seconds per 15 minutes
# (4 * 15 minutes) per hour

const _MIN_GMT2STD_SEC_   = -12*60*60 # -12 hours
const _MAX_GMT2STD_SEC_   =  13*60*60 # +13 hours

const _MIN_GMT2STD_MIN_   = -12*60    # -12 hours

const _MAX_GMT2STD_MIN_   =  13*60    # +13 hours
const _MIN_GMT2STD_15MIN_ = -12*4     # -12 hours (-12 * 900)
const _MAX_GMT2STD_15MIN_ =  13*4     # +13 hours (+13 * 900)
const _MIN_STD2DST_15MIN_ =     4     # - 1 hours
const _MAX_STD2DST_15MIN_ =  2*4+2    # + 2 1/2 hours

const _MIN_GMT2LCL_SEC_ = -12*60*60 # -12 hours
const _MAX_GMT2LCL_SEC_ =  14*60*60 # +14 hours (probably +13)

# for all index-finding vector searches
#
# returns
#              0    iff   x <  a[1]
#       length(a)   iff   x >= a[end]
#   otherwise  i    a[i] >= x    and   a[i+a] < x
#
# for all index-finding vector searches
#
# returns
#              0    iff   x <  a[1]
#       length(a)   iff   x >= a[end]
#   otherwise  i    a[i] >= x    and   a[i+a] < x
#
# invariants adapted from Go language binary search

function search_gte(a::Array{Int,1}, x::Int)
  # Define f(0) == false and f(length(a)+1)== true.
  # Invariant: f(i-1) == false, f(j) == true.
  i, j = 1, (length(a)+1)
  while(i < j)
    h = i + ((j-i) >> 1) # i <= h < j, avoids overflow
    if (a[h] <= x)
      i = h + 1        # preserves f(i-1) == false
    else
      j = h            # preserves f(j) == true
    end
  end
  # i == j, f(i-1) == false, and f(j) (= f(i)) == true  =>  answer is i.
  return i-1
end

function checked_search_gte(a::Array{Int,1}, x::Int)
    if (x < a[1])
       return 0
    elseif (x >= a[end])
       return length(a)
    end
    gte_search(a,x)
end
# invariants adapted from Go language binary search

function search_gte(a::Array{Int,1}, x::Int)
  # Define f(0) == false and f(length(a)+1)== true.
  # Invariant: f(i-1) == false, f(j) == true.
  i, j = 1, (length(a)+1)
  while(i < j)
    h = i + ((j-i) >> 1) # i <= h < j, avoids overflow
    if (a[h] <= x)
      i = h + 1        # preserves f(i-1) == false
    else
      j = h            # preserves f(j) == true
    end
  end
  # i == j, f(i-1) == false, and f(j) (= f(i)) == true  =>  answer is i.
  return i-1
end

function checked_search_gte(a::Array{Int,1}, x::Int)
    if (x < a[1])
       return 0
    elseif (x >= a[end])
       return length(a)
    end
    gte_search(a,x)
end



# Unassigned sentinal for use with Uint or Int variables
# requires isa(variable,Unassignable) !isa(variable,Float)

if (WORD_SIZE == 32)
   Unassignable = Union(Uint32,Int32,Float32)
   Unassigned   = float32(NaN)
else
   Unassignable = Union(Uint64,Int64,Float64)
   Unassigned   = float64(NaN)
end

# Not-a-Value
# for signed int var taking only nonneg values
#
# quasi-NaN-like for Ints, requires arithmetic
# to ignore the existence of typemin(Int),
# the only representable integer for which
# the absolute value is not representable.
#
# Float64(NaV(Int64)) == -0.0

NaV(t::Signed) = typemin(t)

# end # module
