# source : tm4julia.jl (./extras/tm4julia/)
# purpose: initialize date and time facilities
#
# author : Jeffrey A. Sarnoff
# created: 2012-Aug-14 in New York, USA

# julia> TM4JULIA_HOME="/home/jas/Desktop/julia/extras/tm4julia"
# "/home/jas/Desktop/julia/extras/tm4julia"
# julia> export TM4JULIA_HOME
#
# julia> load("tm4julia/config/JTM_dirpaths.jl")
# julia> import JTM_dirpaths.*
#
# julia> load("tm4julia/config/JTM_config.jl")
#        does
# 
#        load("tm4julia/config/JTM_config_tz.jl")
#        import JTM_config_tz.*
#        load("tm4julia/config/JTM_local_tz.jl")
#        import JTM_local_tz.*
#        load("tm4julia/config/JTM_config_etc.jl")
#        import JTM_config_etc.*
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
export TM4JULIA_HOME
# access to facility files using paths relative to TM4JULIA_HOME
load("$(TM4JULIA_HOME)/config/JTM_dirpaths.jl");
import JTM_dirpaths.*

require(jtm_cfgfile("JTM_config.jl"))

require(jtm_utlfile("JTM_util.jl"))




fio=open(my_tz_preloads_file,"r");
tzs=split(readchomp(fio),'\n');
if (tzs[end] == "")
  tzs = tzs[1:(end-1)]
end
close(fio)
# ensure _local_tz_name is included
if (!any(_local_tz_name .== tzs))
   push(tzs, _local_tz_name)
end

_tzs_inmem = Dict{Union(ASCIIString,Int64),Union(ASCIIString,Int64)}(length(tzs))


for tzname in tzs
  if (strlen(tzname) > 0)
    try begin
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
    # add city reference
    if (strchr(tzname,'/')>0)
      nm = split(tzname,'/')[end]
      _tzs_inmem[ nm  ] = tznum
      if (strchr(nm,'_')>0)
        _tzs_inmem[ camelcase(nm,'_') ] = tznum
      end
    end
   end end # try begin ... end end
  end
end


# load other parts

require(jtm_srcfile("days/daynum.jl"))
import daynum.*
require(jtm_srcfile("days/leapyear.jl"))
import leapyear.*
require(jtm_srcfile("days/daysInMonth.jl")) # uses leapyear
import daysInMonth.*
require(jtm_srcfile("times/cume_leapsecs.jl"))
import cume_leapsecs.*

require(jtm_srcfile("io/JTM_date_in.jl"))
import JTM_date_in.*

