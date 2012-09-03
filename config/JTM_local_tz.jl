# source : JTM_local_tz.jl (./extras/tm4julia/config/)
# purpose: establish the site IANA timezone
#
# author : Jeffrey A. Sarnoff
# created: 2012-Aug-14 in New York, USA


# module JTM_local_tz

export _local_tz_name, _local_tz_num

# import Base.*
# import Main._tzname_to_tznum

_local_tz_name = ""

# first check our file to see if the timezone has been stored
# import Main.my_tz_stdname_file

if (stat(my_tz_stdname_file).mode > 0)
  fio = open(my_tz_stdname_file)
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



#end # module
