# source : cfg_etc.jl (./extras/tm4julia/config/)
# purpose: conversion constants, other parameters
#
# offers  : 
#
# load&use: all
# import  : none
#
# author  : Jeffrey A. Sarnoff
# contact : jeffrey(dot)sarnoff(at)gmail
#
# created: 2012-Jun-18 in New York, USA
# revised: 2012-Aug-14
#
# license : This material is available to Julia without encumbrance.
#
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Reserved.


export _daysecs, _leapsecs,
       _minHour, _maxHour, _topHour,  # [ _min .. _max ], inclusive if needed
       _minSec,  _maxSec , _topSec


# import Base.*

const _daysecs  = 86400 # unless leapsecond added
const _leapsecs = 35    # as of 2012-12-31

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


# end # module
