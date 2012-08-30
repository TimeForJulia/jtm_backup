# cume_leapsecs.jl


# at or after 1961 TAI-UTC > 0, TAI > UTC

module cume_leapsecs

    export utc_to_tai, tai_to_utc, _max_known_leapsec_year
           # tai_minus_utc    , utc_minus_tai    ,
           # tai_minus_utc_flt, tai_minus_utc_flt,
           

    import Base.*
    import Main.search_gte
    import Main.jtm_srcfile

    require( jtm_srcfile("days/daynum.jl") )
    import daynum.*

const _max_known_leapsec_year = 2012

const _tai_minus_utc_1961_1972_daynum =
[
    daynumber( 1961,  1, 1 ), #  1
    daynumber( 1961,  8, 1 ),
    daynumber( 1962,  1, 1 ),
    daynumber( 1963, 10, 1 ),
    daynumber( 1964,  1, 1 ),
    daynumber( 1964,  4, 1 ),
    daynumber( 1964,  9, 1 ),
    daynumber( 1965,  1, 1 ),
    daynumber( 1965,  3, 1 ),
    daynumber( 1965,  7, 1 ),
    daynumber( 1965,  9, 1 ),
    daynumber( 1966,  1, 1 ),
    daynumber( 1968,  2, 1 ),
    daynumber( 1971, 12,31 ), # 14
]

const _tai_minus_utc_1972_2012_daynum = [
    daynumber( 1972, 1, 1 ), # 1
    daynumber( 1972, 7, 1 ),
    daynumber( 1973, 1, 1 ),
    daynumber( 1974, 1, 1 ),
    daynumber( 1975, 1, 1 ),
    daynumber( 1976, 1, 1 ),
    daynumber( 1977, 1, 1 ),
    daynumber( 1978, 1, 1 ),
    daynumber( 1979, 1, 1 ),
    daynumber( 1980, 1, 1 ),
    daynumber( 1981, 7, 1 ),
    daynumber( 1982, 7, 1 ),
    daynumber( 1983, 7, 1 ),
    daynumber( 1985, 7, 1 ),
    daynumber( 1988, 1, 1 ),
    daynumber( 1990, 1, 1 ),
    daynumber( 1991, 1, 1 ),
    daynumber( 1992, 7, 1 ),
    daynumber( 1993, 7, 1 ),
    daynumber( 1994, 7, 1 ),
    daynumber( 1996, 1, 1 ),
    daynumber( 1997, 7, 1 ),
    daynumber( 1999, 1, 1 ),
    daynumber( 2006, 1, 1 ),
    daynumber( 2009, 1, 1 ),
    daynumber( 2012, 7, 1 ), # 26
];


const _tai_minus_utc_1961_1972_secs =
[
  (daynum::Int64) -> (1.4228180 + (daynum - 2323308)*0.0012960) ,
  (daynum::Int64) -> (1.3728180 + (daynum - 2323308)*0.0012960) ,
  (daynum::Int64) -> (1.8458580 + (daynum - 2323673)*0.0011232) ,
  (daynum::Int64) -> (1.9458580 + (daynum - 2323673)*0.0011232) ,
  (daynum::Int64) -> (3.2401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.3401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.4401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.5401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.6401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.7401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (3.8401300 + (daynum - 2324769)*0.0012960) ,
  (daynum::Int64) -> (4.3131700 + (daynum - 2325134)*0.0025920) ,
  (daynum::Int64) -> (4.2131700 + (daynum - 2325134)*0.0025920) ,
  (daynum::Int64) -> (4.2131700 + (daynum - 2325134)*0.0025920) ,
]

const _tai_minus_utc_1972_2012_secs =
[
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
]


function __tai_minus_utc(daynum::Int64) # function tai_minus_utc_1961_2012(daynum::Int64)

  if      (daynum >= daynumber(2012, 7, 1))
      return 35
  elseif  (daynum <  daynumber(1961, 1, 1))
      return  0
  elseif  (daynum >= daynumber(1972, 1, 1))
      return _tai_minus_utc_1972_2012_secs[
                 search_gte( _tai_minus_utc_1972_2012_daynum, daynum )
                                          ]
  else
      return _tai_minus_utc_1961_1972_secs[
          search_gte( _tai_minus_utc_1961_1972_daynum, daynum )
                                          ](daynum)
  end
end

function __utc_minus_tai(daynum::Int64) # function tai_minus_utc_1961_2012(daynum::Int64)
  - __tai_minus_utc(daynum)
end

function _tai_minus_utc(daynum::Int64, as_int::Bool)
  if (as_int)
    return( convert(Int64, round(  __tai_minus_utc(daynum))) )
  else
    return( round(convert(Float64, __tai_minus_utc(daynum))) )
  end
end

function _utc_minus_tai(daynum::Int64, as_int::Bool)
    -_tai_minus_utc(daynum, as_int)
end

tai_minus_utc(daynum::Int64)     = _tai_minus_utc(daynum, true )
tai_minus_utc_flt(daynum::Int64) = _tai_minus_utc(daynum, false)

utc_minus_tai(daynum::Int64)     = _utc_minus_tai(daynum, true )
utc_minus_tai_flt(daynum::Int64) = _utc_minus_tai(daynum, false)

function resolve_secnumber(daynumber::Int64, secnumber::Int64)
    if ((secnumber > 86401) || ((secnumber == 86401) && !is_leapsec_day(daynumber)))
       secnumber -= 86401; daynumber += 1
    elseif (secnumber == 86400)
       secnumber = 0; daynumber += 1
    elseif (secnumber < -1) 
       secnumber += 86400; daynumber -= 1
    elseif (secnumber == -1) 
       if (is_leapsec_day(daynumber-1))
          secnumber = 86401; daynumber -=1
       else
          secnumber += 86400; daynumber -= 1
       end
    end
    (daynumber, secnumber)
end

function utc_to_tai(daynumber::Int64,secnumber::Int64)
    secnumber += tai_minus_utc(daynumber)
 
    resolve_secnumber(daynumber, secnumber)
end

function tai_to_utc(daynumber::Int64, secnumber::Int64)
    secnumber -= tai_minus_utc(daynumber)
    
    resolve_secnumber(daynumber, secnumber)
end


end # module

