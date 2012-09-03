
#module JTM_days

export ymd_to_daynum, daynum_to_ymd, _ymd_to_daynum,
       isLeapYearJulian, isLeapYearGregorian, isLeapYearCommon,
       daysInMonthJulian, daysInPriorMonthJulian, daysInNextMonthJulian,
       daysInMonthGregorian, daysInPriorMonthGregorian, daysInNextMonthGregorian,
       daysInMonthCommon, daysInPriorMonthCommon, daysInNextMonthCommon

#import Base.*
#import Tm4Julia.*


include(jtm_srcfile("days/JAS_daynum.jl"))
include(jtm_srcfile("days/leapyear.jl"))
include(jtm_srcfile("days/daysInMonth.jl"))

#end # moudule
