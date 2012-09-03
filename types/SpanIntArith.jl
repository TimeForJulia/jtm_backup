# source : SpanIntArith.jl (./extras/tm4julia/types)
# purpose: Spanning time indexes, span and indexes as integers
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-03 in New York, USA
#
# license: This work is donated to Julia, she be timely.
#
# Copyright (c) 2012 by the author. All Rights Reserved.

# >>> REQUIRES TimeIntegers.jl, SpanIntegers.jl, TimeIntSpanInt.jl to be include()d FIRST <<<


# preclude multiplying/dividing index spanning numbers

(*)(x::DaysNumber, y::DaysNumber) = error("Quantum Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecsNumber, y::SecsNumber) = error("Quantum Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::DaysNumber, y::SecsNumber) = error("Multiplying mixed TimeSpans is disallowed: $(x)::$(typeof(x)) * $(y)::$(typeof(y))\n")
(*)(x::SecsNumber, y::DaysNumber) = error("Multiplying mixed TimeSpans is disallowed: $(x)::$(typeof(x)) * $(y)::$(typeof(y))\n")


(/)(x::DaysNumber, y::DaysNumber) = error("Quantum Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecsNumber, y::SecsNumber) = error("Quantum Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::DaysNumber, y::SecsNumber) = error("Dividing mixed TimeSpans is disallowed: $(x)::$(typeof(x)) / $(y)::$(typeof(y))\n")
(/)(x::SecsNumber, y::DaysNumber) = error("Dividing mixed TimeSpans is disallowed: $(x)::$(typeof(x)) / $(y)::$(typeof(y))\n")

(div)(x::DaysNumber, y::DaysNumber) = error("Quantum Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::SecsNumber, y::SecsNumber) = error("Quantum Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::DaysNumber, y::SecsNumber) = error("Dividing mixed TimeSpans is disallowed: $(x)::$(typeof(x)) / $(y)::$(typeof(y))\n")
(div)(x::SecsNumber, y::DaysNumber) = error("Dividing mixed TimeSpans is disallowed: $(x)::$(typeof(x)) / $(y)::$(typeof(y))\n")

# permit validated arithmetic (+,-,*,/,div) with integers
# permit (+)(-) of like-typed sequence spanning index integers, validating

(+)(x::DaysNumber, y::SecsNumber) = error("Adding mixed TimeSpans is disallowed: $(x)::$(typeof(x)) + $(y)::$(typeof(y))\n")
(+)(x::SecsNumber, y::DaysNumber) = error("Adding mixed TimeSpans is disallowed: $(x)::$(typeof(x)) + $(y)::$(typeof(y))\n")
(-)(x::DaysNumber, y::SecsNumber) = error("Subtracting mixed TimeSpans is disallowed: $(x)::$(typeof(x)) - $(y)::$(typeof(y))\n")
(-)(x::SecsNumber, y::DaysNumber) = error("Subtracting mixed TimeSpans is disallowed: $(x)::$(typeof(x)) - $(y)::$(typeof(y))\n")


(+)(x::DaysNumber, y::DaysNumber)   = DaysNum( (+)(convert(Int64,x), convert(Int64,y)) )
(-)(x::DaysNumber, y::DaysNumber)   = DaysNum( (-)(convert(Int64,x), convert(Int64,y)) )

(+)(x::DaysNumber, y::Integer   ) = DaysNum( convert(Int64,x) + y )
(+)(x::Integer   , y::DaysNumber) = (+)(y,x)
(-)(x::DaysNumber, y::Integer   ) = DaysNum( convert(Int64,x) - y )
(-)(x::Int64     , y::DaysNumber) = DaysNum( x - convert(Int64,y) )
(-)(x::Uint64    , y::DaysNumber) = DaysNum( x - convert(Int64,y) )


(*)(x::DaysNumber  , y::Integer   ) = DaysNum( convert(Int64,x) * y )
(*)(x::Integer     , y::DaysNumber) = DaysNum( x * convert(Int64,y) ) # (*)(y,x)
(div)(x::DaysNumber, y::Integer   ) = DaysNum( div(convert(Int64,x), y) )
(div)(x::Integer   , y::DaysNumber) = DaysNum( div(x, convert(Int64,x)) )
(/)(x::DaysNumber  , y::Integer   ) = float64( convert(Int64,x) / y )
(/)(x::Integer     , y::DaysNumber) = float64( x / convert(Int64,x) )


(+)(x::SecsNumber, y::SecsNumber) = SecsNum( (+)(convert(Int64,x), convert(Int64,y)) )
(-)(x::SecsNumber, y::SecsNumber) = SecsNum( (-)(convert(Int64,x), convert(Int64,y)) )

(+)(x::SecsNumber, y::Integer   ) = SecsNum( convert(Int64,x) + y )
(+)(x::Integer   , y::SecsNumber) = (+)(y,x)
(-)(x::SecsNumber, y::Integer   ) = SecsNum( convert(Int64,x) - y )
(-)(x::Int64     , y::SecsNumber) = SecsNum( x - convert(Int64,y) )
(-)(x::Uint64    , y::SecsNumber) = SecsNum( x - convert(Int64,y) )

(*)(x::SecsNumber  , y::Integer   ) = SecsNum( convert(Int64,x) * y )
(*)(x::Integer     , y::SecsNumber) = (*)(y,x)
(div)(x::SecsNumber, y::Integer   ) = SecsNum( div(convert(Int64,x), y) )
(div)(x::Integer   , y::SecsNumber) = SecsNum( div(x, convert(Int64,x)) )
(/)(x::SecsNumber  , y::Integer   ) = float64( convert(Int64,x) / y )
(/)(x::Integer     , y::SecsNumber) = float64( x / convert(Int64,x) )
