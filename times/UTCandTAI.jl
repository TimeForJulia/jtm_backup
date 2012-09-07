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



#  "TAI-UTC was 8.000082 seconds at the point of the POSIX Epoch,
#   i.e. that the POSIX Epoch 1970-01-01 00:00:00.000000 UTC 
#   is equivalent to          1970-01-01 00:00:08.000082 TAI 
#   (exactly, by definition)"
#
#  - Paul Eggert eggert at twinsun.com, Mon Dec 4 18:00:51 UTC 2000
#    http://mm.icann.org/pipermail/tz/2000-December/011262.html
#
#    Proleptic TAI is a confusing way to specify an epoch, but is there a less confusing way?
#    "the number of seconds since 1970-01-01 00:00:08.000082 UT (1970-01-01 00:00:00 TAI,
#     if TAI had existed then)"?
#
#  - Paul Eggert eggert at twinsun.com
#
#  TECHNOTE:  IANA library uses 1970-Jan-01 00:00:10.000000 TAI 

# http://www.csgnetwork.com/timetaidispcalc.html
# UTC 2012-09-06 02:56:00
# TAI 2012-09-06 02:56:33

export UTC_to_TAI, TAI_to_UTC, TCU_to_UTC, UTC_to_TCU, TCU_to_TAI, TAI_to_TCU


# data from IERS series7 publication


const 
TAIminusUTC_pre1972_daynum = int64([
  2323308,        #   daynum(1961, 1,1)
  2323520,        #   daynum(1961, 8,1)
  2323673,        #   daynum(1962, 1,1)
  2324311,        #   daynum(1963,10,1)
  2324403,        #   daynum(1964, 1,1)
  2324494,        #   daynum(1964, 4,1)
  2324647,        #   daynum(1964, 9,1)
  2324769,        #   daynum(1965, 1,1)
  2324828,        #   daynum(1965, 3,1)
  2324950,        #   daynum(1965, 7,1)
  2325012,        #   daynum(1965, 9,1)
  2325134,        #   daynum(1966, 1,1)
  2325895         #   daynum(1968, 2,1)
  # 2327324       #   daynum(1971,12,31) # max for this-12-31 (max for this)
])



const
TAIminusUTC_pre1972_secnumTAI = int64([
 200733811200,    #   daynum(1961, 1,1) * 86400
 200752128000,    #   daynum(1961, 8,1) * 86400
 200765347200,    #   daynum(1962, 1,1) * 86400
 200820470400,    #   daynum(1963,10,1) * 86400
 200828419200,    #   daynum(1964, 1,1) * 86400
 200836281600,    #   daynum(1964, 4,1) * 86400
 200849500800,    #   daynum(1964, 9,1) * 86400
 200860041600,    #   daynum(1965, 1,1) * 86400
 200865139200,    #   daynum(1965, 3,1) * 86400
 200875680000,    #   daynum(1965, 7,1) * 86400
 200881036800,    #   daynum(1965, 9,1) * 86400
 200891577600,    #   daynum(1966, 1,1) * 86400
 200957328000     #   daynum(1968, 2,1) * 86400
])


const 
TAIminusUTC_pre1972_daynumfn = [
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


const
TAIminusUTC_pre1972_secnumfn = [
  secnum -> 1.4228180 + ((secnum - 2323308*86400)/86400)*0.0012960,
  secnum -> 1.3728180 + ((secnum - 2323308*86400)/86400)*0.0012960,
  secnum -> 1.8458580 + ((secnum - 2323673*86400)/86400)*0.0011232,
  secnum -> 1.9458580 + ((secnum - 2323673*86400)/86400)*0.0011232,
  secnum -> 3.2401300 + ((secnum - 2324769*86400)/86400)*0.0012960,
  secnum -> 3.3401300 + ((secnum - 2324769*86400)/86400)*0.0012960,
  secnum -> 3.4401300 + ((secnum - 2324769*86400)/86400)*0.0012960,
  secnum -> 3.5401300 + ((secnum - 2324769*86400)/86400)*0.0012960,
  secnum -> 3.6401300 + ((secnum - 2324769*86400)/86400)*0.0012960,
  secnum -> 3.7401300 + ((secnum - 2324769*86400)/86400)*0.0012960,
  secnum -> 3.8401300 + ((secnum - 2324769*86400)/86400)*0.0012960,
  secnum -> 4.3131700 + ((secnum - 2325134*86400)/86400)*0.0025920,
  secnum -> 4.2131700 + ((secnum - 2325134*86400)/86400)*0.0025920,
  # secnum -> 4.2131700 + ((secnum - 2323308*86400)/86400)*0.0025920,   #secnum(1971,12,31)
]


# daynum at 0h when cumulative leap seconds has just changed
# this daynum is the same for TAI and UTC
const 
TAIminusUTC_1972fwd_daynum = int64([
  2327325,     #  daynum(1972,01,01)
  2327507,     #  daynum(1972,07,01)
  2327691,     #  daynum(1973,01,01)
  2328056,     #  daynum(1974,01,01)
  2328421,     #  daynum(1975,01,01)
  2328786,     #  daynum(1976,01,01)
  2329152,     #  daynum(1977,01,01)
  2329517,     #  daynum(1978,01,01)
  2329882,     #  daynum(1979,01,01)
  2330247,     #  daynum(1980,01,01)
  2330794,     #  daynum(1981,07,01)
  2331159,     #  daynum(1982,07,01)
  2331524,     #  daynum(1983,07,01)
  2332255,     #  daynum(1985,07,01)
  2333169,     #  daynum(1988,01,01)
  2333900,     #  daynum(1990,01,01)
  2334265,     #  daynum(1991,01,01)
  2334812,     #  daynum(1992,07,01)
  2335177,     #  daynum(1993,07,01)
  2335542,     #  daynum(1994,07,01)
  2336091,     #  daynum(1996,01,01)
  2336638,     #  daynum(1997,07,01)
  2337187,     #  daynum(1999,01,01)
  2339744,     #  daynum(2006,01,01)
  2340840,     #  daynum(2009,01,01)
  2342117,     #  daynum(2012,07,01)
])

# TAI secnum at 0h when cumulative leap seconds has just changed
const 
TAIminusUTC_1972fwd_secnumTAI = int64([
  201080880000,     #  daynum(1972,01,01) * 86400
  201096604800,     #  daynum(1972,07,01) * 86400
  201112502400,     #  daynum(1973,01,01) * 86400
  201144038400,     #  daynum(1974,01,01) * 86400
  201175574400,     #  daynum(1975,01,01) * 86400
  201207110400,     #  daynum(1976,01,01) * 86400
  201238732800,     #  daynum(1977,01,01) * 86400
  201270268800,     #  daynum(1978,01,01) * 86400
  201301804800,     #  daynum(1979,01,01) * 86400
  201333340800,     #  daynum(1980,01,01) * 86400
  201380601600,     #  daynum(1981,07,01) * 86400
  201412137600,     #  daynum(1982,07,01) * 86400
  201443673600,     #  daynum(1983,07,01) * 86400
  201506832000,     #  daynum(1985,07,01) * 86400
  201585801600,     #  daynum(1988,01,01) * 86400
  201648960000,     #  daynum(1990,01,01) * 86400
  201680496000,     #  daynum(1991,01,01) * 86400
  201727756800,     #  daynum(1992,07,01) * 86400
  201759292800,     #  daynum(1993,07,01) * 86400
  201790828800,     #  daynum(1994,07,01) * 86400
  201838262400,     #  daynum(1996,01,01) * 86400
  201885523200,     #  daynum(1997,07,01) * 86400
  201932956800,     #  daynum(1999,01,01) * 86400
  202153881600,     #  daynum(2006,01,01) * 86400
  202248576000,     #  daynum(2009,01,01) * 86400
  202358908800,     #  daynum(2012,07,01) * 86400
])


# cumulative leap seconds at 0h of TAIminusUTC_1972fwd_daynum
const 
TAIminusUTC_1972fwd_sec = int64([
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

# declared leapseconds, not the pre-1972 computed values
# incorporates initial 10second offset
#
function CumeLeapseconds(daynum::DayNumber)
    daynum = convert(Int64,daynum)
    if (daynum > 2342117)           #  daynum(2012,7,1)
       _leapsecs
    elseif (daynum >= 2327325)      # daynum(1972,1,1)
       TAIminusUTC_1972fwd_sec[ search_gte(TAIminusUTC_1972fwd_daynum, daynum) ]  # 1972-1-1 .. present+
    else
       0
    end
end

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
      TAIminusUTC_pre1972_secnumfn[search_gte(TAIminusUTC_pre1972_secnumTAI, secnum)](secnum)
   end

end

UTCminusTAI(secnum::SecNumber) = -(TAIminusUTC(secnum))
 

#   UTC --> TAI:  UTC + (TAI-UTC) == TAI == UTC - (UTC-TAI)
#   TAI --> UTC:  TAI + (UTC-TAI) == UTC == TAI - (TAI-UTC)

UTC_to_TAI(daynum::DayNumber) = daynum + TAIminusUTC(daynum)
UTC_to_TAI(secnum::SecNumber) = secnum + TAIminusUTC(secnum)

TAI_to_UTC(daynum::DayNumber) = daynum - TAIminusUTC(daynum)
TAI_to_UTC(secnum::SecNumber) = secnum - TAIminusUTC(secnum)

# UTC without the leapseconds .. returns SecNumber

UTC_to_CTU(daynum::DayNumber) = daynum_to_secnum(daynum) - CumeLeapseconds(daynum)
UTC_to_CTU(secnum::SecNumber) = secnum - CumeLeapseconds(secnum_to_daynum(secnum))
CTU_to_UTC(daynum::DayNumber) = daynum_to_secnum(daynum) + CumeLeapseconds(daynum)
CTU_to_UTC(secnum::SecNumber) = secnum + CumeLeapseconds(secnum_to_daynum(secnum))

CTU_to_TAI(daynum::DayNumber) = UTC_to_TAI(CTU_to_UTC(daynum))
CTU_to_TAI(secnum::SecNumber) = UTC_to_TAI(CTU_to_UTC(secnum))
TAI_to_CTU(daynum::DayNumber) = UTC_to_CTU(TAI_to_UTC(daynum))
TAI_to_CTU(secnum::SecNumber) = UTC_to_CTU(TAI_to_UTC(secnum))


# end # module
