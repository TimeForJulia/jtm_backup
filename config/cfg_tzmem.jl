# source : cfg_tzmem.jl (./extras/tm4julia/config/)
# purpose: preloads specified timezones
#
# offers  : _tzs_inmem
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

export _tzs_inmem

# precache timezones that are likely to be used
# (user prespecified aor from user history)
#   _tzs_inmem tracks which timezones have
#   basic & transition info ready in memory
#   as entries in _tz_basic[] and _tz_vects[]
#
tzs=String[]
fio=open(filenameInitialTzones,"r");
_tzs=split(readchomp(fio),'\n');
close(fio)
if (_tzs[end] == "")
  _tzs = tzs[1:(end-1)]
end
for z in _tzs
  push(tzs,z)
end

fio=open(filenameMoreTzones,"r");
_tzs=split(readchomp(fio),'\n');
close(fio)
if (_tzs[end] == "")
  _tzs = _tzs[1:(end-1)]
end
for z in _tzs
  if (!any(z .== tzs))
    push(tzs,z)
  end
end

fio=open(filenameUserTzones,"r");
_tzs=split(readchomp(fio),'\n');
close(fio)
if (_tzs[end] == "")
  _tzs = tzs[1:(end-1)]
end
for z in _tzs
  if (!any(z .== tzs))
    push(tzs,z)
  end
end



# ensure _local_tz_name, _utc_tz_name, _tai_tz_name are included
#
if (!any(_local_tz_name .== tzs))  push(tzs, _local_tz_name)  end
if (!any(_utc_tz_name   .== tzs))  push(tzs, _utc_tz_name)    end
if (!any(_tai_tz_name   .== tzs))  push(tzs, _tai_tz_name)    end

# prepare timezones for use

_tzs_inmem = Dict{Union(ASCIIString,Int64),Union(ASCIIString,Int64)}(length(tzs))

for tzname in tzs
  if (strlen(tzname) > 0)
     try
       begin
         tznum = _tzname_to_tznum[ tzname ]
         fpath = _tznum_to_filepath[ tznum ]

         try
            basic = strcat(fpath,tz_basic_fname)
            fio = open(basic); basic=deserialize(fio)(); close(fio); 
            _tz_basic[tznum] = basic
     
            vects = strcat(fpath,tz_vects_fname)
            fio = open(vects); vects=deserialize(fio)(); close(fio);
            _tz_vects[tznum] = vects

         catch e
            error("Unable to preload $(tzname)\n\t$(e)\n")
         end
         
         _tzs_inmem[tzname] = tznum   # wait until the data is loaded
         _tzs_inmem[tznum]  = tzname  # before setting these entries

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

# eof #
