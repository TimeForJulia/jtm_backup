# source  : utl_values.jl (./extras/tm4julia/util/)
# purpose : augment stdlib capabilities
#
# offers  : notok( Union(Signed, FloatingPoint) )
#
# load&use: all
# import  : none
#
# author  : Jeffrey A. Sarnoff
# contact : jeffrey(dot)sarnoff(at)gmail
#
# created : 2012-Aug-14 in New York, USA
# revised : 2012-Sep-05 (modularized)
#
# license : This material is available to Julia without encumbrance.
#
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Reserved.


export notok

# pseudo Unused/Invalid value for Signed, FloatingPoint
#
# for Signed Ints, requires arithmetic
# to ignore the existence of typemin(Int),
# the only representable integer for which
# the absolute value is not representable.
#
# FloatN(typemin(IntN)) == -0.0
# for Floats, requires -0.0 otherwise ignored.
#
notok(::Type{Int8})          = typemin(Int8)
notok(::Type{Int16})         = typemin(Int16)
notok(::Type{Int32})         = typemin(Int32)
notok(::Type{Int64})         = typemin(Int64)
notok(::Type{Int128})        = typemin(Int128)
#
notok(::Type{Float32})       = convert(Float32 , typemin(Int32) )
notok(::Type{Float64})       = convert(Float64 , typemin(Int64) )
#notok(::Type{Float128})      = convert(Float128, typemin(Int128))


# eof #
