# source : jtm  (./jtm/)
#
# purpose: Julia's temporal gate
#
# offers:
#
# author : Jeffrey A. Sarnoff
# contact: jeffrey(dot)sarnoff(at)gmail
#
# created: 2012-Sep-04 in New York, USA
#
#
# license: This material is available to Julia without encumbrance.
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Reserved.


module _jtm

# autoexports all from jtm_filepath.jl

import Base.*

# where is Julia's top level (git clone dir): ./julia
# where is Julia's facilitative subdirectory: ./julia/<subdir>
# where is the local root of Time for Julia : ./julia/<subdir>/jtm

const JULIA_TOP_DIR = strcat(split(JULIA_HOME,"julia")[1],"julia")
const JULIA_SUB_DIR = "$(JULIA_TOP_DIR)/extras"
#const JULIA_JTM_DIR = "$(JULIA_SUB_DIR)/jtm"
const JULIA_JTM_DIR = "/home/jas/Desktop/tm4julia"

include("$(JULIA_JTM_DIR)/jtm_filepath.jl")     # simplified access to facility elements


end # module



module jtm

import Base.*
import _jtm.*


include(jtm_utlfile("utl_string"))              # more Char and ASCIIString ops
include(jtm_utlfile("utl_numstr"))              # assist with integer subformats
include(jtm_utlfile("utl_search"))              # search tuned for internal tables & logic
include(jtm_utlfile("utl_values"))              # sentinal-like values
include(jtm_utlfile("utl_ariths"))              # arithmetic & algebraic basics

                                                # .. var = "<file>"; cfg info in <file>
include(jtm_cfgfile("cfg_system"))              # region timezone, timezones to preload
include(jtm_cfgfile("cfg_user"))                # remote timezone, timezones to preload

include(jtm_cfgfile("cfg_tzsys"))               # timezone management data dicts
include(jtm_cfgfile("cfg_lcltz"))               # ascertain local timezone
include(jtm_cfgfile("cfg_tzmem"))               # preload specified timezones

include(jtm_cfgfile("cfg_etc"))                 # conversion constants, other parameters

include(jtm_typfile("TimeIntegers"))            # bitstypes
include(jtm_typfile("TimeIntArith"))

typealias Year Int64
typealias Month Int64
typealias Day Int64
typealias Hour Int64
typealias Minute Int64
typealias Second Int64
typealias Seconds Int64
                                                # daynumber (proleptic Gregorian + year 0)
include(jtm_dayfile("daysecnum"))               # ymd <-> daynumber <-> unix time_t secs
include(jtm_dayfile("leapyears"))               # Julian, Gregorian and Common
include(jtm_dayfile("monthdays"))               #  (Common uses 1582 if no switchover year is given)
include(jtm_dayfile("yeardays"))                #  !!TODO!! accept switchover date and days gapped

include(jtm_timfile("UTCandTAI"))               # leap seconds and interconversion
include(jtm_dayfile("unxsecnum"))               # Unix Epoch interconversion


# timespan calcs
#include(jtm_dayfile("spanvals"))


# Time Index Numbers and TimeSpan Duration Numbers
#include(jtm_typfile("JTM_BitInts.jl"))
#
# Sequential Days at Day and Second resolution
# UTC and TAI time measures and interconversion
#include(jtm_srcfile("days/JTM_days.jl"))
#include(jtm_srcfile("times/UTCandTAI.jl"))

end # module jtm

#
# # import an accessible perspective on Time for Julia
#

import jtm.daynum_to_secnum
import jtm.secnum_to_daynum

import jtm.ymd_to_daynum
import jtm.ymd_to_secnum
#import jtm.ymd_to_daysec
import jtm.daynum_to_ymd
import jtm.secnum_to_ymd
#import jtm.daysec_to_ymd

import jtm.UTC_to_TAI
import jtm.TAI_to_UTC

                              # here, parens group fields, the are not tuples

# import jtm.Year               # type
# import jtm.year               # realizer
# import jtm._yr                # grain
# import jtm.Month              # type
# import jtm.month              # realizer
# import jtm._mo                # grain
# import jtm.Day                # type
# import jtm.day                # realizer
# import jtm._d                 # grain
# import jtm.Hour               # type
# import jtm.hour               # realizer
# import jtm._hr                # grain
# import jtm.Minute             # type
# import jtm.minute             # realizer
# import jtm._mi                # grain
# import jtm.Second             # type
# import jtm.second             # realizer
# import jtm._s                 # grain


# import jtm.YMDHMS             # type
# import jtm.ymdhms             # realizer
# import jtm.YMD                # type
# import jtm.ymd                # realizer
# import jtm.HMS                # type
# import jtm.hms                # realizer

# import jtm.DayNumber          # bitstype
# import jtm.Daynum             # realizer
# import jtm.SecNumber          # bitstype
# import jtm.Secnum             # realizer

# import jtm.daynum_to_secnum   # DayNumber --> SecNumber
# import jtm.secnum_to_daynum   # SecNumber --> DayNumber
# import jtm.secnum_to_secrem   # SecNumber --> Seconds   (SecNumber = DayNumber+Seconds)

# import jtm.ymd_to_daynum      # (Year,Month,Day) --> DayNumber
# import jtm.daynum_to_ymd      # DayNumber --> (Year,Month,Day)
# import jtm.ymdhms_to_secnum   # ((Year,Month,Day), (Hour,Min,Sec)) --> SecNumber
# import jtm.secnum_to_ymdhms   # SecNumber --> ((Year,Month,Day), (Hour,Min,Sec))
# import jtm.ymdsec_to_secnum   # ((Year,Month,Day), Seconds) --> SecNumber
# import jtm.secnum_to_ymdsec   # SecNumber --> ((Year,Month,Day), Seconds)
# import jtm.dnmsec_to_secnum   # (DayNumber, Seconds) --> SecNumber
# import jtm.secnum_to_dnmsec   # SecNumber --> (DayNumber, Seconds)

# import jtm.ymdz_to_daynumz    # (Year,Month,Day,Tz) --> (DayNumber,Tz)
# import jtm.daynumz_to_ymdz    # (DayNumber,Tz) --> (Year,Month,Day,Tz)
# import jtm.ymdhmsz_to_secnumz # ((Year,Month,Day), (Hour,Min,Sec), Tz) --> (SecNumber,Tz)
# import jtm.secnumz_to_ymdhmsz # (SecNumber,Tz) --> ((Year,Month,Day),(Hour,Min,Sec),Tz)
# import jtm.ymdsecz_to_secnumz # ((Year,Month,Day), Seconds, Tz) --> (SecNumber,Tz)
# import jtm.secnumz_to_ymdsecz # (SecNumber,Tz) --> ((Year,Month,Day), Seconds, Tz)
# import jtm.dnmsecz_to_secnumz # (DayNumber, Seconds, Tz) --> (SecNumber, Tz)
# import jtm.secnumz_to_dnmsecz # (SecNumber,Tz) --> (DayNumber, Seconds, Tz)



# import jtm.LocalTimezone
# import jtm.UsingTimezone
# import jtm.UsingLeapsecs

                    # date and time-of-day
                    # with timezone (explicit or implicitly local)

# import jtm.date     # calendar date + timezone
# import jtm.datm     # calender date + clock time + timezone

# import jtm.ymdhmsz  # requires explicit timezone
# import jtm.ymdz
# import jtm.hmsz

# import jtm.ymdhms   # allows explicit timezone, local is default
# import jtm.ymd
# import jtm.hms

                    # duration in date and time-of-day elements
# import jtm.datespan #
# import jtm.datmspan

# import jtm.ts_ymdhms
# import jtm.ts_ymd
# import jtm.ts_hms

                     # datetime subselectors
# import jtm.year
# import jtm.month
# import jtm.day
# import jtm.hour
# import jtm.minute
# import jtm.second
                     # timespan subselectors
# import jtm.years
# import jtm.months
# import jtm.days
# import jtm.hours
# import jtm.minutes
# import jtm.seconds





# eof #
