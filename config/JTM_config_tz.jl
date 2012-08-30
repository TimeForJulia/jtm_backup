# source : JTM_config_tz.jl (./extras/tm4julia/config/)
# purpose: provides internal timezone related configuration settings
#
# author : Jeffrey A. Sarnoff
# created: 2012-Jun-18 in New York, USA
# revised: 2012-Aug-14

module JTM_config_tz

export _tzname_to_tznum, _tznum_to_filepath, 
       my_tz_stdname_file, my_tz_preloads_file,
       tz_basic_fname, tz_vects_fname,
       TimezoneBasic, TimezoneVects, _tz_basic, _tz_vects

import Base.*
import Main.jtm_cfgfile
import Main.jtm_tmzfile


# IANA timezone name and number (enum value + 8) [+ some win tz names]
# dictionaries: name -> num, num -> path (path holds tz's datafiles)
#
# read timezone names into numbers dictionary
fio = open(jtm_tmzfile("_tzname_to_tznum.jld"),"r")
_tzname_to_tznum = deserialize(fio);
close(fio)
# read timezone nums into filepaths dictionary
fio = open(jtm_tmzfile("_tznum_to_filepath.jld"),"r")
_tznum_to_filepath = deserialize(fio);
close(fio)


# these are best undisturbed

const my_tz_stdname_file  = jtm_cfgfile("tz/MyTimezone.txt")
const my_tz_preloads_file = jtm_cfgfile("tz/StartupZones.txt")


const tz_basic_fname  = "tzbasic.jld"
const tz_vects_fname  = "tzvects.jld"


type TimezoneBasic
  num::Int64
  utc2std::Int64
  utc2dst::Int64
  name::ASCIIString
  stdabbr::ASCIIString
  dstabbr::ASCIIString

  TimezoneBasic() = new(typemin(Int64),typemin(Int64),typemin(Int64),"","","");
  TimezoneBasic(num::Int64,utc2std::Int64,utc2dst::Int64, name::ASCIIString,stdabbr::ASCIIString,dstabbr::ASCIIString) =
     new(num,utc2std,utc2dst,name,stdabbr,dstabbr);
  TimezoneBasic(num::Int32,utc2std::Int32,utc2dst::Int32, name::ASCIIString,stdabbr::ASCIIString,dstabbr::ASCIIString) =
     new(int64(num),int64(utc2std),int64(utc2dst),name,stdabbr,dstabbr);

end


type TimezoneVects
  utcsecs::Vector{Int64}
  utc2lcl::Vector{Int64}
  isitdst::Vector{Int64}

  TimezoneVects() = new([typemin(Int64)],[typemin(Int64)],[typemin(Int64)])
  TimezoneVects(utcsecs::Vector{Int64},utc2lcl::Vector{Int64},isitdst::Vector{Int64}) = new(utcsecs,utc2lcl,isitdst)
  TimezoneVects(utcsecs::Vector{Int32},utc2lcl::Vector{Int32},isitdst::Vector{Int32}) = new(int64(utcsecs),int64(utc2lcl),int64(isitdst))
end


_tz_basic = fill(TimezoneBasic(),511)
_tz_vects = fill(TimezoneVects(),511)



end # module
