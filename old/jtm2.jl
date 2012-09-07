# source : jtm.jl (./extras/tm4julia/)
# purpose: initialize date and time facilities
#
# author : Jeffrey A. Sarnoff
# created: 2012-Aug-14 in New York, USA
# revised: 2012-Sep-02


# we place these entities in the Main user namespace
#    the full directory path to the root dir for tm4julia
#    the date, time, datetime and timezone input acceptance
#

# provide full directory paths for accessing facility files
#


TM4JULIA_HOME = strcat(JULIA_HOME[1:(end-7)],"extras/tm4julia")

if (stat( "$(TM4JULIA_HOME)/tm4julia.jl" ).mode==0)
    TM4JULIA_HOME = strcat(readchomp(`pwd`),"/lib/julia/extras/tm4julia")
    if (stat( "$(TM4JULIA_HOME)/tm4julia.jl" ).mode==0)
       error("Cannot find file \"tm4julia.jl\".")
    end
end

TM4JULIA_HOME="/home/jas/Desktop/jtm"

export TM4JULIA_HOME


module Tm4Julia

export TM4JULIA_HOME,
       jtm_srcfile, jtm_typfile, jtm_datfile,
       jtm_tmzfile, jtm_cfgfile, jtm_utlfile,
       jtm_datpath, jtm_tmzpath, jtm_cfgpath,
       _tzname_to_tznum, _tzs_inmem, _tz_basic, _tz_vects,
       _utc_tz_name, _utc_tz_num, _tai_tz_name, _tai_tz_num,
       _local_tz_name, _local_tz_num,
  

import Base.*
import Main.TM4JULIA_HOME


# access to facility files using paths relative to TM4JULIA_HOME
include("$(TM4JULIA_HOME)/config/JTM_dirpaths.jl");

include(jtm_cfgfile("JTM_config.jl"))
include(jtm_utlfile("JTM_util.jl"))

#import JTM_string_utl.*

# precache timezones that are likely to be used
# (user prespecified aor from user history)
#   _tzs_inmem tracks which timezones have
#   basic & transition info ready in memory
#   as entries in _tz_basic[] and _tz_vects[]
#
fio=open(my_tz_preloads_file,"r");
tzs=split(readchomp(fio),'\n');
if (tzs[end] == "")
  tzs = tzs[1:(end-1)]
end
close(fio)

# ensure _local_tz_name, _utc_tz_name, _tai_tz_name are included
if (!any(_local_tz_name .== tzs))  push(tzs, _local_tz_name)  end
if (!any(_utc_tz_name .== tzs))    push(tzs, _utc_tz_name)    end
if (!any(_tai_tz_name .== tzs))    push(tzs, _tai_tz_name)    end

# prepare timezones for use

_tzs_inmem = Dict{Union(ASCIIString,Int64),Union(ASCIIString,Int64)}(length(tzs))

for tzname in tzs
  if (strlen(tzname) > 0)
     try
       begin
         tznum = _tzname_to_tznum[ tzname ]
         fpath = _tznum_to_filepath[ tznum ]
         basic = strcat(fpath,tz_basic_fname)
         vects = strcat(fpath,tz_vects_fname)
         fio = open(basic); basic=deserialize(fio)(); close(fio);
         fio = open(vects); vects=deserialize(fio)(); close(fio);
         _tz_basic[tznum] = basic  # q.v. jtm_cfgfile("config_tz.jl")
         _tz_vects[tznum] = vects  # q.v. jtm_cfgfile("config_tz.jl")
         #
         _tzs_inmem[tzname] = tznum
         _tzs_inmem[tznum]  = tzname
         # for timezones named <region>/<city>, add as a synonym
         # that is the <city> name itself (without "<region>/")
         if (strchr(tzname,'/')>0)
           nm = split(tzname,'/')[end]
           _tzs_inmem[ nm  ] = tznum
           # for cities named <city_name> or <city-name>, add as a synonym
           # that is the city name camelcased ("AbcDef")
           if     (strchr(nm,'_')>0)
               _tzs_inmem[ camelcase(nm,'_') ] = tznum
           elseif (strchr(nm,'-')>0)
               _tzs_inmem[ camelcase(nm,'-') ] = tznum
           end
         end
       end # begin
     catch e
        error("Cannot prepare timezones for use.\n\t$(e)\n")
     end # try
  end
end




end # module Tm4Julia



module grain

export timezone_is_loaded, timezone_not_loaded, ensure_timezone_is_loaded  


import Base.*
import Tm4Julia.*


function tzname_to_valid_tznum(tmzone::ASCIIString)
  if has(_tzname_to_tznum, tmzone)
     return _tzname_to_tznum[tmzone]
  else
     error("Unrecognized timezone name: \"$(tmzone)\".")
  end
end


function _load_a_timezone(tmzone::Int)
  if (_minTimezoneNumber <= tmzone < _topTimezoneNumber)
     try
        fio = tznum_to_tz_basic_file(tmzone)
        _tz_basic[tmzone] = deserialize(fio)()
        close(fio)
        fio = tznum_to_tz_vects_file(tmzone)
        _tz_vects[tmzone] = deserialize(fio)()
        close(fio)
     catch e
        error("Cannot read data files for Timezone Number: $(tmzone).\n\t($e)\n")
     end
  else
     error("Invalid Timezone Number: $(tmzone).")
  end
end

function _load_a_timezone(tmzone::ASCIIString)
    _load_a_timezone_num(tzname_to_valid_tznum(tmzone))
end

timezone_is_loaded (tmzone::Int) = (_tz_basic[tmzone] == TimezoneBasicEmpty)
timezone_not_loaded(tmzone::Int) = (_tz_basic[tmzone] != TimezoneBasicEmpty)

function ensure_timezone_is_loaded(tmzone::Int)
  if (timezone_not_loaded(tmzone))
     _load_a_timezone(tmzone)
  end
end

function ensure_timezone_is_loaded(tmzone::ASCIIString)
    _load_a_timezone(tzname_to_valid_tznum(tmzone))
end




# Time Index Numbers and TimeSpan Duration Numbers
include(jtm_typfile("JTM_BitInts.jl"))
#
# Sequential Days at Day and Second resolution
# UTC and TAI time measures and interconversion
include(jtm_srcfile("days/JTM_days.jl"))
include(jtm_srcfile("times/UTCandTAI.jl"))

end # module



module jtm # JTM


import Base.*
import Tm4Julia.*
import grain.* 

include(jtm_srcfile("times/cume_leapsecs.jl"))
include(jtm_srcfile("io/JTM_date_in.jl"))

end # module JTM


import jtm # JTM


#  jtm.grain.UTCminusTAI(jtm.grain.DayNum(jtm.grain.daynum(1992,11,05)))

