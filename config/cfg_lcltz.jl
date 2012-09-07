# source : cfg_lcltz.jl (./extras/tm4julia/config/)
# purpose: provides internal timezone related configuration settings
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


export _local_tz_name, _local_tz_num

_local_tz_name = ""
# _local_tz_num  undefined to trap problems

# first check our file to see if the timezone has been stored


if (stat(filenameLocalTzone).mode > 0)
  fio = open(filenameLocalTzone)
  my_tz_stdname = readchomp(fio)
  close(fio)
  if (length(my_tz_stdname) > 0)
      ENV["TZ"] = my_tz_stdname
  end
else
    # (following golang.org/src/pkg/time/zoneinfo_unix.go)
    # environment variable "TZ" has priority, then "TIMEZONE"
    # either var, if set to "", is interpreted as "UTC"

    if     (has(ENV,"TZ"))
        if (strlen(ENV["TZ"])>0)
	      _local_tz_name = ENV["TZ"]
        else
    	      _local_tz_name = "UTC"
        end
    elseif (has(ENV,"TIMEZONE"))
        if (strlen(ENV["TIMEZONE"]>0))
	      _local_tz_name = ENV["TIMEZONE"]
        else
	      _local_tz_name = "UTC"
        end
    else
        # default timezone registry is examined
        try
            if (CURRENT_OS != symbol("Windows"))
        	if (stat("/etc/timezone").size > 0)
                    _local_tz_name = readchomp(`cat /etc/timezone`);
                end;
            else
                _local_tz_name = readchomp(`tzutil /g`);
            end;
        catch e
            begin ; end
        end
    end;

end

if     (_local_tz_name == "") && (!has(ENV,"TZ"))
    error("Cannot determine the local time zone.")
elseif (has(ENV, "TZ"))
    _local_tz_name = ENV["TZ"]
end

if (_local_tz_name[end]=='\n')
  _local_tz_name = _local_tz_name[1:(end-1)]
end


if (!has(_tzname_to_tznum,_local_tz_name))
	error("Unrecognized local timezone: \"$(_local_tz_name)\".")
else
   _local_tz_num = _tzname_to_tznum[ _local_tz_name ]
end

