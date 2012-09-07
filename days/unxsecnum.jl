# source : unixnum.jl  (./extras/tm4julia/days/)
# partof : Time for Julia
#
# purpose: provide interconvertable integer mapped dates and seconds
#
# author : Jeffrey A. Sarnoff
#
# created: 2012-Jun-15
# refined: 2012-Aug-07
# settled: 2012-Sep-02

export  daynum_to_unix_daynum, unix_daynum_to_daynum, secnum_to_unix_secnum, unix_secnum_to_secnum,
        daysec_to_unix_daynum, unix_daynum_to_daysec, daysec_to_unix_secnum, unix_secnum_to_daysec,
        ymd_to_unix_daynum, unix_daynum_to_ymd, ymd_to_unix_secnum, unix_secnum_to_ymd,
        ymdsec_to_unix_daynum, unix_daynum_to_ymdsec, ymdsec_to_unix_secnum, unix_secnum_to_ymdsec



# daynum, secnum <--> time_t seconds since Unix Epoch
# Unix Epoch: 01-Jan-1970 00:00:00 UTC  ~ 01-Jan-1970 00:00:10 TAI (IANA library uses this)

const Unix_Epoch_day0 = ymd_to_daynum(1970,  1,  1)
const Unix_Epoch_sec0 = daynum_to_secnum(Unix_Epoch_day0)


daynum_to_unix_daynum(daynum::Int64)       =  daynum  - Unix_Epoch_day0
unix_daynum_to_daynum(unixnum::Int64)      =  unixnum + Unix_Epoch_day0
unix_daynum_to_ymd(unixnum::Int64)         =
    daynum_to_ymd(unix_daynum_to_daynum(unixnum))
ymd_to_unix_daynum(y::Int, m::Int, d::Int) =
    daynum_to_unix_daynum(ymd_to_daynum(y,m,d))

secnum_to_unix_secnum(secnum::Int64)       =  secnum  - Unix_Epoch_sec0
unix_secnum_to_secnum(unixnum::Int64)      =  unixnum + Unix_Epoch_sec0
daynum_to_unix_secnum(daynum::Int64)       =
    secnum_to_unix_secnum( daynum_to_secnum(daynum) )
unix_secnum_to_daynum(unixnum::Int64)      =
    secnum_to_daynum( unix_secnum_to_secnum(unixnum) )
unix_secnum_to_daysec(unixnum::Int64)      =
    secnum_to_daysec( unix_secnum_to_secnum(unixnum) )
daysec_to_unix_secnum(daynum::Int64, secs::Int) =
    daynum_to_unix_secnum(daynum) + secs

ymd_to_unix_secnum(y::Int, m::Int, d::Int) =
    secnum_to_unix_secnum(ymd_to_secnum(y,m,d))
ymdsec_to_unix_secnum(y::Int, m::Int, d::Int, s::Int) =
    secnum_to_unix_secnum(ymd_to_secnum(y,m,d) + s)
unix_secnum_to_ymd(unixnum::Int64) =
    daynum_to_ymd(secnum_to_daynum(unix_secnum_to_secnum(unixnum)))
function unix_secnum_to_ymdsec(unixnum::Int64)
    dnum,s = unix_secnum_daysec(unixnum)
    y,m,d  = daynum_to_ymd(dnum)
    y,m,d,s
end


# eof #
