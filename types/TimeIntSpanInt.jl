# source : TimeIntSpanInt.jl (./extras/tm4julia/types)
# purpose: Correct conflicts with TimeInteger and SpanInteger arithmetic
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-03 in New York, USA
#
# license: This work is donated to Julia, she be timely.
#
# Copyright (c) 2012 by the author. All Rights Reserved.

# >>> REQUIRES TimeIntegers.jl AND SpanIntegers.jl to be include()d FIRST <<<


# correct for conflicts

(+)(x::DayNumber, y::DaysNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(+)(x::SecNumber, y::SecsNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(+)(x::DayNumber, y::SecsNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(+)(x::SecNumber, y::DaysNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(+)(x::DaysNumber, y::DayNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(+)(x::SecsNumber, y::SecNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(+)(x::DaysNumber, y::SecNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(+)(x::SecsNumber, y::DayNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::DayNumber, y::DaysNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::SecNumber, y::SecsNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::DayNumber, y::SecsNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::SecNumber, y::DaysNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::DaysNumber, y::DayNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::SecsNumber, y::SecNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::DaysNumber, y::SecNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(-)(x::SecsNumber, y::DayNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")

(*)(x::DayNumber, y::DaysNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecNumber, y::SecsNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::DayNumber, y::SecsNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecNumber, y::DaysNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::DaysNumber, y::DayNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecsNumber, y::SecNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::DaysNumber, y::SecNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(*)(x::SecsNumber, y::DayNumber) = error("Temporal Grassmanian Meets?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::DayNumber, y::DaysNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecNumber, y::SecsNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::DayNumber, y::SecsNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecNumber, y::DaysNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::DaysNumber, y::DayNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecsNumber, y::SecNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::DaysNumber, y::SecNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(/)(x::SecsNumber, y::DayNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::DayNumber, y::DaysNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::SecNumber, y::SecsNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::DayNumber, y::SecsNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::SecNumber, y::DaysNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::DaysNumber, y::DayNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::SecsNumber, y::SecNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::DaysNumber, y::SecNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")
(div)(x::SecsNumber, y::DayNumber) = error("Temporal Grassmanian Joins?:\n\t $(x)::$(typeof(x)) * $(y)::$(typeof(y)).\n")

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
