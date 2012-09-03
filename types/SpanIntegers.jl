# source : SpanIntegers.jl (./extras/tm4julia/types)
# purpose: Spanning time indexes, span and indexes as integers
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-03 in New York, USA
#
# license: This work is donated to Julia, she be timely.
#
# Copyright (c) 2012 by the author. All Rights Reserved.

# These TimeSpanIntegers cover TimeInteger clopen pair bounded
#    subsequences in the clopen interval [_minYear, _topYear)
#    using the granularity of the TimeInteger sequence as the
#    granularity of integral _tocs_ that form the duration spanned.
#
# TECHNOTE:  It is possible to have gaps in the TimeInteger sequence
#            underpinning (determining) the SpanInteger breadth. See
#            this annoation in TimeInteger.jl for possible causes.


bitstype 64 DaysNumber <: Integer   # the civil day (0h is midnight)
                                   # at the Prime meridian or wrt a given timezone
bitstype 64 SecsNumber <: Integer   # the SI second unless noted otherwise


# provide (and control) integer interconversion

convert(::Type{Unsigned}, j::DaysNumber) = convert(Unsigned, convert(Int64,j))
convert(::Type{Signed}  , j::DaysNumber) = convert(Signed  , convert(Int64,j))

convert(::Type{  Int64}, j::DaysNumber) = box(Int64, unbox(DaysNumber,j))
convert(::Type{ Uint64}, j::DaysNumber) = convert( Uint64, convert(Int64,j))
convert(::Type{ Int128}, j::DaysNumber) = convert( Int128, convert(Int64,j))
convert(::Type{Uint128}, j::DaysNumber) = convert(Uint128, convert(Int128,j))
convert(::Type{  Int32}, j::DaysNumber) = (abs(j) <= typemax(Int32)) ? convert(Int32, convert(Int64,j)) : throw(ValueError)
convert(::Type{ Uint32}, j::DaysNumber) = ((j) >= 0) ? convert(Uint64, convert(Int64,j)) : throw(ValueError)


convert(::Type{Unsigned}, j::SecsNumber) = convert(Unsigned, convert(Int64,j))
convert(::Type{Signed}  , j::SecsNumber) = convert(Signed  , convert(Int64,j))

convert(::Type{  Int64}, j::SecsNumber) = box(Int64, unbox(SecsNumber,j))
convert(::Type{ Uint64}, j::SecsNumber) = convert( Uint64, convert(Int64,j))
convert(::Type{ Int128}, j::SecsNumber) = convert( Int128, convert(Int64,j))
convert(::Type{Uint128}, j::SecsNumber) = convert(Uint128, convert(Int128,j))
convert(::Type{  Int32}, j::SecsNumber) = (abs(j) <= typemax(Int32)) ? convert(Int32,convert(Int64,j)) : throw(ValueError)
convert(::Type{ Uint32}, j::SecsNumber) = ((j) >= 0) ? convert(Uint64, convert(Int64,j)) : throw(ValueError)



convert(::Type{DaysNumber}, i::  Int64) = box(DaysNumber, unbox(Int64,i))
convert(::Type{DaysNumber}, i:: Uint64) = convert(DaysNumber, convert(Uint64,i))
convert(::Type{DaysNumber}, i:: Int128) = convert(DaysNumber, convert(Int64,i))
convert(::Type{DaysNumber}, i::Uint128) = convert(DaysNumber, convert(Int64,i))
convert(::Type{DaysNumber}, i::  Int32) = convert(DaysNumber, convert(Int64,i))
convert(::Type{DaysNumber}, i:: Uint32) = convert(DaysNumber, convert(Int64,i))

convert(::Type{SecsNumber}, i::  Int64) = box(SecsNumber, unbox(Int64,i))
convert(::Type{SecsNumber}, i:: Uint64) = convert(SecsNumber, convert(Uint64,i))
convert(::Type{SecsNumber}, i:: Int128) = convert(SecsNumber, convert(Int64,i))
convert(::Type{SecsNumber}, i::Uint128) = convert(SecsNumber, convert(Int64,i))
convert(::Type{SecsNumber}, i::  Int32) = convert(SecsNumber, convert(Int64,i))
convert(::Type{SecsNumber}, i:: Uint32) = convert(SecsNumber, convert(Int64,i))

# interconversion
# CAUTION -- only for time measures that do not use leapseconds and use SI second
# convert(::Type{SecsNumber}, n::DaysNumber) = convert(SecsNumber, (convert(Int64,_daysecs) * convert(Int64,n)))
# convert(::Type{DaysNumber}, n::SecsNumber) = convert(DaysNumber, div(convert(Int64,n), convert(Int64,_daysecs)))

# promotion

promote_rule(::Type{DaysNumber}, ::Type{Unsigned}) =  Unsigned
promote_rule(::Type{DaysNumber}, ::Type{Signed})   =  Signed

promote_rule(::Type{DaysNumber}, ::Type{  Int64}) =   Int64
promote_rule(::Type{DaysNumber}, ::Type{ Uint64}) =  Uint64
promote_rule(::Type{DaysNumber}, ::Type{ Int128}) =   Int64
promote_rule(::Type{DaysNumber}, ::Type{Uint128}) =  Uint64
promote_rule(::Type{DaysNumber}, ::Type{  Int32}) =   Int32
promote_rule(::Type{DaysNumber}, ::Type{ Uint32}) =  Uint32


promote_rule(::Type{SecsNumber}, ::Type{Unsigned}) =  Unsigned
promote_rule(::Type{SecsNumber}, ::Type{Signed})   =  Signed

promote_rule(::Type{SecsNumber}, ::Type{  Int64}) =   Int64
promote_rule(::Type{SecsNumber}, ::Type{ Uint64}) =  Uint64
promote_rule(::Type{SecsNumber}, ::Type{ Int128}) =   Int64
promote_rule(::Type{SecsNumber}, ::Type{Uint128}) =  Uint64
promote_rule(::Type{SecsNumber}, ::Type{  Int32}) =   Int32
promote_rule(::Type{SecsNumber}, ::Type{ Uint32}) =  Uint32


# instantiation with validation

errorDaysNumber(n) = error("DaysNumber domain error: $(n) not in [$(_minDaysNumber), $(_topDaysNumber)).")
validDaysNumber(n) = (_minDaysNumber <= n < _topDaysNumber) ? n : errorDaysNumber(n)

DaysNum(n::  Int32) = validDaysNumber( convert(DaysNumber, n) )
DaysNum(n:: Uint32) = validDaysNumber( convert(DaysNumber, n) )
DaysNum(n::  Int64) = validDaysNumber( convert(DaysNumber, n) )
DaysNum(n:: Uint64) = validDaysNumber( convert(DaysNumber, n) )
DaysNum(f::Float64) = (isfinite(f) & (abs(f)<typemax(Int64))) ?
                        validDaysNumber( convert(DaysNumber, n) ) :
                        raise(ValueError)
DaysNum(f::Float32) = DaysNumber(convert(Float64,f))


errorSecsNumber(n) = error("SecsNumber domain error: $(n) not in [$(_minSecsNumber), $(_topSecsNumber)).")
validSecsNumber(n) = (_minSecsNumber <= n < _topSecsNumber) ? n : errorSecsNumber(n)

SecsNum(n::  Int32) = validSecsNumber( convert(SecsNumber, n) )
SecsNum(n:: Uint32) = validSecsNumber( convert(SecsNumber, n) )
SecsNum(n::  Int64) = validSecsNumber( convert(SecsNumber, n) )
SecsNum(n:: Uint64) = validSecsNumber( convert(SecsNumber, n) )
SecsNum(f::Float64) = (isfinite(f) & (abs(f)<typemax(Int64))) ?
                        validSecsNumber( convert(SecsNumber, n) ) :
                        raise(ValueError)
SecsNum(f::Float32) = SecsNumber(convert(Float64,f))



# show(x)
# Write an informative text representation of a value to the
# current output stream. New types should overload show(io, x)
# where the first argument is a stream.
#
# print(x)
# Write (to the default output stream) a canonical (un-decorated)
# text representation of a value if there is one, otherwise call show.

show (io::IO, j::DaysNumber) = show (io, "DaysNum($(int64(j)))")
show (io::IO, j::SecsNumber) = show (io, "SecsNum($(int64(j)))")

print(io::IO, j::DaysNumber) = print(io, "$(int64(j))")
print(io::IO, j::SecsNumber) = print(io, "$(int64(j))")
