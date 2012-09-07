# source : cfg_tzsys.jl (./extras/tm4julia/config/)
# purpose: provides internal timezone related configuration settings
#
# author : Jeffrey A. Sarnoff
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



export TimezoneBasic         , TimezoneVects         , 
       TimezoneBasicEmpty    , TimezoneVectsEmpty    ,
       tznum_to_open_tz_basic, tznum_to_open_tz_vects,
       _tz_basic             , _tz_vects             ,

       _tzname_to_tznum, _tznum_to_filepath,

       _minTimezoneNum , _maxTimezoneNum   , _topTimezoneNum,
       _utc_tz_name, _tai_tz_name, _utc_tz_num, _tai_tz_num


# IANA timezone name and number (enum value + 8) [+ some win tz names]
# dictionaries: name -> num, num -> path (path holds tz's datafiles)
#
# read timezone names into numbers dictionary
fio = open(jtm_tzdfile("_tzname_to_tznum"),"r")
_tzname_to_tznum = deserialize(fio);
close(fio)
# read timezone numbers into names dictionary [NOTUSED]
# fio = open(jtm_tzdfile("_tznum_to_tzname"),"r")
# _tznum_to_tzname = deserialize(fio);
# close(fio)
# read timezone nums into filepaths dictionary
fio = open(jtm_tzdfile("_tznum_to_filepath"),"r")
_tznum_to_filepath = deserialize(fio);
close(fio)


# these are best undisturbed

const _maxTimezoneNum = max(keys(_tznum_to_filepath))
const _topTimezoneNum = _maxTimezoneNum + 1
const _minTimezoneNum = 0


const tz_basic_fname  = "tzbasic.jld"
const tz_vects_fname  = "tzvects.jld"


type TimezoneBasic

  num     ::Int64
  utc2std ::Int64
  utc2dst ::Int64
  name    ::ASCIIString
  stdabbr ::ASCIIString
  dstabbr ::ASCIIString

  TimezoneBasic() = new(notok(Int64), notok(Int64), notok(Int64), "", "", "");

  TimezoneBasic(num::Int64, utc2std::Int64, utc2dst::Int64,
                name::ASCIIString, stdabbr::ASCIIString, dstabbr::ASCIIString) =
      new(num, utc2std, utc2dst, name, stdabbr, dstabbr);

  TimezoneBasic(num::Int32, utc2std::Int32, utc2dst::Int32,
                name::ASCIIString, stdabbr::ASCIIString, dstabbr::ASCIIString) =
      new(int64(num), int64(utc2std), int64(utc2dst), name, stdabbr, dstabbr);

end

const TimezoneBasicEmpty = TimezoneBasic()


type TimezoneVects

  utcsecs ::Vector{Int64}
  utc2lcl ::Vector{Int64}
  isitdst ::Vector{Int64}

  TimezoneVects() = new([notok(Int64)], [notok(Int64)], [notok(Int64)])

  TimezoneVects(utcsecs::Vector{Int64}, utc2lcl::Vector{Int64}, isitdst::Vector{Int64}) =
      new(utcsecs, utc2lcl, isitdst)

  TimezoneVects(utcsecs::Vector{Int32}, utc2lcl::Vector{Int32}, isitdst::Vector{Int32}) =
      new(int64(utcsecs), int64(utc2lcl), int64(isitdst))
end

const TimezoneVectsEmpty = TimezoneVects()


_tz_basic = fill(TimezoneBasicEmpty, _topTimezoneNum) # _top as arrays are 1-based
_tz_vects = fill(TimezoneVectsEmpty, _topTimezoneNum) #   while the _min is  0

function tznum_to_open_tz_basic(tznum::Integer)
  filename = strcat(_tznum_to_filepath[tznum], tz_basic_fname)
  try
     open( filename, "r" )
  catch e
     error("Cannot open $(filename):  $(e)")
  end
end

function tznum_to_open_tz_vects(tznum::Integer)
  filename = strcat(_tznum_to_filepath[tznum], tz_vects_fname)
  try
     open( filename, "r" )
  catch e
     error("Cannot open $(filename):  $(e)")
  end
end


const _utc_tz_name = "UTC"
const _utc_tz_num  = _tzname_to_tznum[_utc_tz_name]
const _tai_tz_name = "TAI"
const _tai_tz_num  = _tzname_to_tznum[_tai_tz_name]

# eof #
