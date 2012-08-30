module JTM_date_in

export date

import Base.*

import Main._local_tz_num
import Main.TimezoneBasic
import Main._tz_basic
import Main.TimezoneVects
import Main._tz_vects
import Main.jtm_cfgfile
import Main.jtm_srcfile
require( jtm_cfgfile("JTM_config_tz.jl") )
import JTM_config_tz._tzname_to_tznum
import JTM_config_tz.tznum_to_tz_basic_file
import JTM_config_tz.tznum_to_tz_vects_file
require( jtm_cfgfile("JTM_config_etc.jl") )
import JTM_config_etc.search_gte
require( jtm_srcfile("days/daynum.jl") )
import daynum.daynumber
require( jtm_srcfile("times/cume_leapsecs.jl") )
import cume_leapsecs.utc_to_tai
import cume_leapsecs.tai_to_utc
import cume_leapsecs.utc_minus_tai
import cume_leapsecs.tai_minus_utc

const TimezoneVectsEmpty = TimezoneVects()
const TimezoneBasicEmpty = TimezoneBasic()

function valid_tmzone_name(tmzone::ASCIIString)
  if has(_tzname_to_tznum, tmzone)
     return _tzname_to_tznum[tmzone]
  else
     error("Unrecognized timezone name: \"$(tmzone)\".")
  end
end

function tmzone_num_available(tmzone::Int)
  if (_tz_basic[tmzone] == TimezoneBasicEmpty)
     fio = tznum_to_tz_basic_file(tmzone)
     _tz_basic[tmzone] = deserialize(fio)()
     close(fio)
     fio = tznum_to_tz_vects_file(tmzone)
     _tz_vects[tmzone] = deserialize(fio)()
     close(fio)
  end
end

function date(yr::Int,mo::Int,dy::Int,tmzone::Int)
    tmzone_num_available(tmzone)

    daynum = daynumber(yr,mo,dy)
    daynumsecs = daynum * 86400
    if (tmzone > 7) 
        idx = search_gte(_tz_vects[tmzone].utcsecs, daynumsecs)
        if (idx == 0) idx = 1  end
        utc2lcl = _tz_vects[tmzone].utc2lcl[idx]
        if (utc2lcl == typemin(Int64)) utc2lcl = 0 end
        daynumsecs -= utc2lcl # utc daynumsecs maybe with leap secs to add
        daynumsecs += tai_minus_utc(daynum)
    elseif (tmzone == _tzname_to_tznum["UTC"])
        daynumsecs += tai_minus_utc(daynum)
    end 
    daynumsecs
end

function date(yr::Int,mo::Int,dy::Int,tmzone::ASCIIString)
    tmzone = valid_tmzone_name(tmzone)
    date(yr,mo,dy, tmzone)
end

function date(yr::Int,mo::Int,dy::Int)
    date(yr,mo,dy, _local_tz_num)
end

end # module
