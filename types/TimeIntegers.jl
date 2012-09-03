# source : TimeIntegers.jl (./extras/tm4julia/types)
# purpose: Time indexes given as sequential integers
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-02 in New York, USA
#
# license: This work is donated to Julia, she be timely.
#
# Copyright (c) 2012 by the author. All Rights Reserved.

# these TimeIntegers sequence the clopen interval [_minYear, _topYear)
# using their respective granularity as the integral step size
#
# TECHNOTE:  It is possible to have occasional gaps in a sequence
#            with granularity of a day or less.  Whether any number
#            is skipped is determined by the specific measure of time,
#            the granularity of the integer step, the sort of calendar,
#            aspectes of the timezone, polar wobble and arithmetic care.

bitstype 64 DayNumber <: Integer   # the civil day (0h is midnight)
                                   # at the Prime meridian or wrt a given timezone
bitstype 64 SecNumber <: Integer   # the SI second unless noted otherwise


# provide (and control) integer interconversion

convert(::Type{Unsigned}, j::DayNumber) = convert(Unsigned, convert(Int64,j))
convert(::Type{Signed}  , j::DayNumber) = convert(Signed  , convert(Int64,j))

convert(::Type{  Int64}, j::DayNumber) = box(Int64, unbox(DayNumber,j))
convert(::Type{ Uint64}, j::DayNumber) = convert( Uint64, convert(Int64,j))
convert(::Type{ Int128}, j::DayNumber) = convert( Int128, convert(Int64,j))
convert(::Type{Uint128}, j::DayNumber) = convert(Uint128, convert(Int128,j))
convert(::Type{  Int32}, j::DayNumber) = (abs(j) <= typemax(Int32)) ? convert(Int32, convert(Int64,j)) : throw(ValueError)
convert(::Type{ Uint32}, j::DayNumber) = ((j) >= 0) ? convert(Uint64, convert(Int64,j)) : throw(ValueError)


convert(::Type{Unsigned}, j::SecNumber) = convert(Unsigned, convert(Int64,j))
convert(::Type{Signed}  , j::SecNumber) = convert(Signed  , convert(Int64,j))

convert(::Type{  Int64}, j::SecNumber) = box(Int64, unbox(SecNumber,j))
convert(::Type{ Uint64}, j::SecNumber) = convert( Uint64, convert(Int64,j))
convert(::Type{ Int128}, j::SecNumber) = convert( Int128, convert(Int64,j))
convert(::Type{Uint128}, j::SecNumber) = convert(Uint128, convert(Int128,j))
convert(::Type{  Int32}, j::SecNumber) = (abs(j) <= typemax(Int32)) ? convert(Int32,convert(Int64,j)) : throw(ValueError)
convert(::Type{ Uint32}, j::SecNumber) = ((j) >= 0) ? convert(Uint64, convert(Int64,j)) : throw(ValueError)



convert(::Type{DayNumber}, i::  Int64) = box(DayNumber, unbox(Int64,i))
convert(::Type{DayNumber}, i:: Uint64) = convert(DayNumber, convert(Uint64,i))
convert(::Type{DayNumber}, i:: Int128) = convert(DayNumber, convert(Int64,i))
convert(::Type{DayNumber}, i::Uint128) = convert(DayNumber, convert(Int64,i))
convert(::Type{DayNumber}, i::  Int32) = convert(DayNumber, convert(Int64,i))
convert(::Type{DayNumber}, i:: Uint32) = convert(DayNumber, convert(Int64,i))

convert(::Type{SecNumber}, i::  Int64) = box(SecNumber, unbox(Int64,i))
convert(::Type{SecNumber}, i:: Uint64) = convert(SecNumber, convert(Uint64,i))
convert(::Type{SecNumber}, i:: Int128) = convert(SecNumber, convert(Int64,i))
convert(::Type{SecNumber}, i::Uint128) = convert(SecNumber, convert(Int64,i))
convert(::Type{SecNumber}, i::  Int32) = convert(SecNumber, convert(Int64,i))
convert(::Type{SecNumber}, i:: Uint32) = convert(SecNumber, convert(Int64,i))

# interconversion
# CAUTION -- only for time measures that do not use leapseconds and use SI second
# convert(::Type{SecNumber}, n::DayNumber) = convert(SecNumber, (convert(Int64,_daysecs) * convert(Int64,n)))
# convert(::Type{DayNumber}, n::SecNumber) = convert(DayNumber, div(convert(Int64,n), convert(Int64,_daysecs)))

# promotion

promote_rule(::Type{DayNumber}, ::Type{Unsigned}) =  Unsigned
promote_rule(::Type{DayNumber}, ::Type{Signed})   =  Signed

promote_rule(::Type{DayNumber}, ::Type{  Int64}) =   Int64
promote_rule(::Type{DayNumber}, ::Type{ Uint64}) =  Uint64
promote_rule(::Type{DayNumber}, ::Type{ Int128}) =   Int64
promote_rule(::Type{DayNumber}, ::Type{Uint128}) =  Uint64
promote_rule(::Type{DayNumber}, ::Type{  Int32}) =   Int32
promote_rule(::Type{DayNumber}, ::Type{ Uint32}) =  Uint32


promote_rule(::Type{SecNumber}, ::Type{Unsigned}) =  Unsigned
promote_rule(::Type{SecNumber}, ::Type{Signed})   =  Signed

promote_rule(::Type{SecNumber}, ::Type{  Int64}) =   Int64
promote_rule(::Type{SecNumber}, ::Type{ Uint64}) =  Uint64
promote_rule(::Type{SecNumber}, ::Type{ Int128}) =   Int64
promote_rule(::Type{SecNumber}, ::Type{Uint128}) =  Uint64
promote_rule(::Type{SecNumber}, ::Type{  Int32}) =   Int32
promote_rule(::Type{SecNumber}, ::Type{ Uint32}) =  Uint32

# instantiation with validation

errorDayNumber(n) = error("DayNumber domain error: $(n) not in [$(_minDayNumber), $(_topDayNumber)).")
validDayNumber(n) = (_minDayNumber <= n < _topDayNumber) ? n : errorDayNumber(n)

DayNum(n::  Int32) = validDayNumber( convert(DayNumber, n) )
DayNum(n:: Uint32) = validDayNumber( convert(DayNumber, n) )
DayNum(n::  Int64) = validDayNumber( convert(DayNumber, n) )
DayNum(n:: Uint64) = validDayNumber( convert(DayNumber, n) )
DayNum(f::Float64) = (isfinite(f) & (abs(f)<typemax(Int64))) ?
                        validDayNumber( convert(DayNumber, n) ) :
                        raise(ValueError)
DayNum(f::Float32) = DayNumber(convert(Float64,f))


errorSecNumber(n) = error("SecNumber domain error: $(n) not in [$(_minSecNumber), $(_topSecNumber)).")
validSecNumber(n) = (_minSecNumber <= n < _topSecNumber) ? n : errorSecNumber(n)

SecNum(n::  Int32) = validSecNumber( convert(SecNumber, n) )
SecNum(n:: Uint32) = validSecNumber( convert(SecNumber, n) )
SecNum(n::  Int64) = validSecNumber( convert(SecNumber, n) )
SecNum(n:: Uint64) = validSecNumber( convert(SecNumber, n) )
SecNum(f::Float64) = (isfinite(f) & (abs(f)<typemax(Int64))) ?
                        validSecNumber( convert(SecNumber, n) ) :
                        raise(ValueError)
SecNum(f::Float32) = SecNumber(convert(Float64,f))





# show(x)
# Write an informative text representation of a value to the
# current output stream. New types should overload show(io, x)
# where the first argument is a stream.
#
# print(x)
# Write (to the default output stream) a canonical (un-decorated)
# text representation of a value if there is one, otherwise call show.

show( io::IO,j::DayNumber) = show(io,"DayNum($(int64(j)))")
show( io::IO,j::SecNumber) = show(io,"SecNum($(int64(j)))")

print(io::IO,j::DayNumber) = print(io,"$(int64(j))")
print(io::IO,j::SecNumber) = print(io,"$(int64(j))")
