# source : UTCandTAI.jl  (./extras/tm4julia/times/)
# partof : Time for Julia
#
# purpose: offer TAU-centric clock
#                seconds-from-0h of daynumber, (timezoneIdnum, UTCoffset2local_in_minutes)?
#
# author : Jeffrey A. Sarnoff
# created: 2012-Aug-25
#
# license: The software art herein is freely donated to Julia for her use.
#
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Retained Are Reserved.


#	from
#	http://www.bipm.org/en/committees/cc/cctf/ccds-1970.html
#
#	In 1980 the definition of TAI was completed as follows
#	(declaration of the CCDS, BIPM Com. Cons. Déf. Seconde,
#	   1980, 9, S15 and Metrologia, 1981, 17, 70)
#
#	This definition was further amplified by the International
#	Astronomical Union in 1991, Resolution A4 (Proc. 21st General
#	   Assembly of the IAU, IAU Trans., 1991, vol. XXIB, Kluwer.)
#
#	"TAI is a coordinate time scale defined in a geocentric
#    reference frame with the SI second as realized on the
#    rotating geoid as the scale unit."
#
#	"TAI is a realized time scale whose ideal form, neglecting
#    a constant offset of 32.184 s, is Terrestrial Time (TT),
#    itself related to the time coordinate of the geocentric
#    reference frame, Geocentric Coordinate Time (TCG),
#    by a constant rate."


# Proleptic TAI is a confusing way to specify an epoch, but is there a less confusing way?
# Maybe "the number of seconds since
#   1970-01-01 00:00:08.000082 UT (i.e. 1970-01-01 00:00:00 TAI, if TAI had existed then)"?


# module UTCandTAI

export TAIminusUTC, UTCminusTAI

import Base.*
import Tm4Julia.*

#include( JTM_dirpaths.jtm_typfile("TimeIndex.jl") )
# import JTM.DayNumber
# import JTM.SecNumber

#EPOCH_TAI = daynum(1970,1,1)
#EPOCH_TAI_DELTASECS2UT = 08.000082


# tai_minus_utc_pre1972 = {
#   daynum(1961, 1,1) function(daynum) 1.4228180 + (daynum - 2323308)*0.0012960 end
#   daynum(1961, 8,1) function(daynum) 1.3728180 + (daynum - 2323308)*0.0012960 end
#   daynum(1962, 1,1) function(daynum) 1.8458580 + (daynum - 2323673)*0.0011232 end
#   daynum(1963,10,1) function(daynum) 1.9458580 + (daynum - 2323673)*0.0011232 end
#   daynum(1964, 1,1) function(daynum) 3.2401300 + (daynum - 2324769)*0.0012960 end
#   daynum(1964, 4,1) function(daynum) 3.3401300 + (daynum - 2324769)*0.0012960 end
#   daynum(1964, 9,1) function(daynum) 3.4401300 + (daynum - 2324769)*0.0012960 end
#   daynum(1965, 1,1) function(daynum) 3.5401300 + (daynum - 2324769)*0.0012960 end
#   daynum(1965, 3,1) function(daynum) 3.6401300 + (daynum - 2324769)*0.0012960 end
#   daynum(1965, 7,1) function(daynum) 3.7401300 + (daynum - 2324769)*0.0012960 end
#   daynum(1965, 9,1) function(daynum) 3.8401300 + (daynum - 2324769)*0.0012960 end
#   daynum(1966, 1,1) function(daynum) 4.3131700 + (daynum - 2325134)*0.0025920 end
#   daynum(1968, 2,1) function(daynum) 4.2131700 + (daynum - 2325134)*0.0025920 end
#   #daynum(1971,12,31) function(daynum) 4.2131700 + (daynum - 2323308)*0.0025920 end
# };

# tai_minus_utc_1961_1972_daynum = int64(tai_minus_utc_pre1972[:,1])
# tai_minus_utc_1961_1972_function  = convert(Vector{Function},(tai_minus_utc_pre1972[:,2]))


# TAIminusUTC_pre1972_daynum = [
#   daynum(1961, 1,1)
#   daynum(1961, 8,1)
#   daynum(1962, 1,1)
#   daynum(1963,10,1)
#   daynum(1964, 1,1)
#   daynum(1964, 4,1)
#   daynum(1964, 9,1)
#   daynum(1965, 1,1)
#   daynum(1965, 3,1)
#   daynum(1965, 7,1)
#   daynum(1965, 9,1)
#   daynum(1966, 1,1)
#   daynum(1968, 2,1)
#   daynum(1971,12,31) # max for this
# ]

const TAIminusUTC_pre1972_daynum = int64([
  2323308,
  2323520,
  2323673,
  2324311,
  2324403,
  2324494,
  2324647,
  2324769,
  2324828,
  2324950,
  2325012,
  2325134,
  2325895
  # 2327324 # 1971-12-31 (max for this)
])

const TAIminusUTC_pre1972_secnumTAI = int64([
 200733811200,
 200752128000,
 200765347200,
 200820470400,
 200828419200,
 200836281600,
 200849500800,
 200860041600,
 200865139200,
 200875680000,
 200881036800,
 200891577600,
 200957328000
])

const TAIminusUTC_pre1972_daynumfn = [
  daynum -> 1.4228180 + (daynum - 2323308)*0.0012960,
  daynum -> 1.3728180 + (daynum - 2323308)*0.0012960,
  daynum -> 1.8458580 + (daynum - 2323673)*0.0011232,
  daynum -> 1.9458580 + (daynum - 2323673)*0.0011232,
  daynum -> 3.2401300 + (daynum - 2324769)*0.0012960,
  daynum -> 3.3401300 + (daynum - 2324769)*0.0012960,
  daynum -> 3.4401300 + (daynum - 2324769)*0.0012960,
  daynum -> 3.5401300 + (daynum - 2324769)*0.0012960,
  daynum -> 3.6401300 + (daynum - 2324769)*0.0012960,
  daynum -> 3.7401300 + (daynum - 2324769)*0.0012960,
  daynum -> 3.8401300 + (daynum - 2324769)*0.0012960,
  daynum -> 4.3131700 + (daynum - 2325134)*0.0025920,
  daynum -> 4.2131700 + (daynum - 2325134)*0.0025920,
  # daynum -> 4.2131700 + (daynum - 2323308)*0.0025920,   #daynum(1971,12,31)
]


const TAIminusUTC_pre1972_secnumfn = [
  secnum -> 1.4228180 + (secnum - 2323308*86400)*0.0012960,
  secnum -> 1.3728180 + (secnum - 2323308*86400)*0.0012960,
  secnum -> 1.8458580 + (secnum - 2323673*86400)*0.0011232,
  secnum -> 1.9458580 + (secnum - 2323673*86400)*0.0011232,
  secnum -> 3.2401300 + (secnum - 2324769*86400)*0.0012960,
  secnum -> 3.3401300 + (secnum - 2324769*86400)*0.0012960,
  secnum -> 3.4401300 + (secnum - 2324769*86400)*0.0012960,
  secnum -> 3.5401300 + (secnum - 2324769*86400)*0.0012960,
  secnum -> 3.6401300 + (secnum - 2324769*86400)*0.0012960,
  secnum -> 3.7401300 + (secnum - 2324769*86400)*0.0012960,
  secnum -> 3.8401300 + (secnum - 2324769*86400)*0.0012960,
  secnum -> 4.3131700 + (secnum - 2325134*86400)*0.0025920,
  secnum -> 4.2131700 + (secnum - 2325134*86400)*0.0025920,
  # secnum -> 4.2131700 + (secnum - 2323308*86400)*0.0025920,   #secnum(1971,12,31)
]


# daynum at 0h when cumulative leap seconds has just changed
# this daynum is the same for TAI and UTC
const TAIminusUTC_1972fwd_daynum = int64([
  2327325,
  2327507,
  2327691,
  2328056,
  2328421,
  2328786,
  2329152,
  2329517,
  2329882,
  2330247,
  2330794,
  2331159,
  2331524,
  2332255,
  2333169,
  2333900,
  2334265,
  2334812,
  2335177,
  2335542,
  2336091,
  2336638,
  2337187,
  2339744,
  2340840,
  2342117,
])

# TAI secnum at 0h when cumulative leap seconds has just changed
const TAIminusUTC_1972fwd_secnumTAI = int64([
  201080880000,
  201096604800,
  201112502400,
  201144038400,
  201175574400,
  201207110400,
  201238732800,
  201270268800,
  201301804800,
  201333340800,
  201380601600,
  201412137600,
  201443673600,
  201506832000,
  201585801600,
  201648960000,
  201680496000,
  201727756800,
  201759292800,
  201790828800,
  201838262400,
  201885523200,
  201932956800,
  202153881600,
  202248576000,
  202358908800,
])


# cumulative leap seconds at 0h of TAIminusUTC_1972fwd_daynum
const TAIminusUTC_1972fwd_sec = int64([
  10 ,
  11 ,
  12 ,
  13 ,
  14 ,
  15 ,
  16 ,
  17 ,
  18 ,
  19 ,
  20 ,
  21 ,
  22 ,
  23 ,
  24 ,
  25 ,
  26 ,
  27 ,
  28 ,
  29 ,
  30 ,
  31 ,
  32 ,
  33 ,
  34 ,
  35 ,
])



# returns SI seconds
function TAIminusUTC(daynum::DayNumber)

   daynum = convert(Int64,daynum)

   if (daynum < 2323308) # daynum(1961,1,1)
      return 0
   elseif (daynum > 2342117) # = daynum(2012,7,1)
      return 35
   elseif (daynum >= 2327325) # daynum(1972,1,1)
      TAIminusUTC_1972fwd_sec[ search_gte(TAIminusUTC_1972fwd_daynum, daynum) ]  # 1972-1-1 .. present+
   else                                                 # 1962-1-1 .. 1971-12-31
      TAIminusUTC_pre1972_daynumfn[search_gte(TAIminusUTC_pre1972_daynum, daynum)](daynum)
   end

end

UTCminusTAI(daynum::DayNumber) = -(TAIminusUTC(daynum))


# returns SI seconds
function TAIminusUTC(secnum::SecNumber)

   secnum = convert(Int64, secnum)

   if (secnum < 2323308*86400) # secnum(1961,1,1)
      return 0
   elseif (secnum > 2342117*86400) # = secnum(2012,7,1)
      return 35
   elseif (secnum >= 2327325*86400) # secnum(1972,1,1)
      TAIminusUTC_1972fwd_sec[ search_gte(TAIminusUTC_1972fwd_secnumTAI, secnum) ]  # 1972-1-1 .. present+
   else # 1962-1-1 .. 1971-12-31
      TAIminusUTC_pre1972_secnumfn[search_gte(TAIminusUTC_pre1972_secnum, secnum)](secnum)
   end

end

UTCminusTAI(secnum::SecNumber) = -(TAIminusUTC(secnum))




# end # module
