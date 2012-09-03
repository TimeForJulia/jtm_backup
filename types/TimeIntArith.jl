# source : TimeIntArith.jl (./extras/tm4julia/types)
# purpose: Time indexes given as sequential integers
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-03 in New York, USA
#
# license: This work is donated to Julia, she be timely.
#
# Copyright (c) 2012 by the author. All Rights Reserved.

# >>> REQUIRES TimeIntegers.jl, SpanIntegers.jl, TimeIntSpanInt.jl to be include()d FIRST <<<


# preclude multiplying/dividing index numbers

(*)(x::DayNumber, y::SecNumber) = error("Multiplying mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) * $(y)::$(typeof(y))\n")
(*)(x::SecNumber, y::DayNumber) = error("Multiplying mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) * $(y)::$(typeof(y))\n")
(/)(x::DayNumber, y::SecNumber) = error("Dividing mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) / $(y)::$(typeof(y))\n")
(/)(x::SecNumber, y::DayNumber) = error("Dividing mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) / $(y)::$(typeof(y))\n")


(*)(x::DayNumber, y::DayNumber) = error("Fractal Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecNumber, y::SecNumber) = error("Fractal Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::DayNumber, y::SecNumber) = error("Fractal Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecNumber, y::DayNumber) = error("Fractal Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::DayNumber, y::Integer  ) = error("Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecNumber, y::Integer  ) = error("Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::Integer  , y::DayNumber) = error("Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::Integer  , y::SecNumber) = error("Time Dilation?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")

(/)(x::DayNumber, y::DayNumber) = error("Fractal Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecNumber, y::SecNumber) = error("Fractal Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::DayNumber, y::SecNumber) = error("Fractal Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecNumber, y::DayNumber) = error("Fractal Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::DayNumber, y::Integer  ) = error("Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecNumber, y::Integer  ) = error("Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::Integer  , y::DayNumber) = error("Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::Integer  , y::SecNumber) = error("Time Erosion?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")


# permit addition and subtraction with integers, results are validated
# permit subtraction of like-typed sequence index integers, yields a SpanInteger

(+)(x::DayNumber, y::SecNumber) = error("Adding mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) + $(y)::$(typeof(y))\n")
(+)(x::SecNumber, y::DayNumber) = error("Adding mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) + $(y)::$(typeof(y))\n")
(-)(x::DayNumber, y::SecNumber) = error("Subtracting mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) - $(y)::$(typeof(y))\n")
(-)(x::SecNumber, y::DayNumber) = error("Subtracting mixed TimeIndexs is disallowed: $(x)::$(typeof(x)) - $(y)::$(typeof(y))\n")


(-)(x::DayNumber, y::DayNumber) = DaysNum( (-)(convert(Int64,x), convert(Int64,y)) )
(+)(x::DayNumber, y::DayNumber) = error("Adding DayNumbers is disallowed: $(x) + $(y)\n")

(+)(x::DayNumber, y::Integer  ) = DayNum( convert(Int64,x) + y )
(+)(x::Integer  , y::DayNumber) = (+)(y,x)
(-)(x::DayNumber, y::Integer  ) = DayNum( convert(Int64,x) - y )
(-)(x::Int64    , y::DayNumber) = DayNum( x - convert(Int64,y) )
(-)(x::Uint64   , y::DayNumber) = DayNum( x - convert(Int64,y) )


(-)(x::SecNumber, y::SecNumber) = SecsNum( (-)(convert(Int64,x), convert(Int64,y)) )
(+)(x::SecNumber, y::SecNumber) = error("Adding SecNumbers is disallowed: $(x) + $(y)\n")

(+)(x::SecNumber, y::Integer  ) = SecNum( convert(Int64,x) + y )
(+)(x::Integer  , y::SecNumber) = (+)(y,x)
(-)(x::SecNumber, y::Integer  ) = SecNum( convert(Int64,x) - y )
(-)(x::Int64    , y::SecNumber) = SecNum( x - convert(Int64,y) )
(-)(x::Uint64   , y::SecNumber) = SecNum( x - convert(Int64,y) )
