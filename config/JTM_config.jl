# source : JTM_config.jl (./extras/tm4julia/config/)
# purpose: provides internal configuration settings
#
# author : Jeffrey A. Sarnoff
# created: 2012-Jun-18 in New York, USA
# revised: 2012-Aug-14

#import Main.jtm_cfgfile

export my_tz_stdname_file, my_tz_preloads_file,
       _utc_tz_name, _utc_tz_num, _tai_tz_name, _tai_tz_num


#these are best undisturbed

const my_tz_stdname_file  = jtm_cfgfile("tz/MyTimezone.txt")
const my_tz_preloads_file = jtm_cfgfile("tz/StartupZones.txt")


include(jtm_cfgfile("JTM_config_tz.jl"))
include(jtm_cfgfile("JTM_local_tz.jl"))
include(jtm_cfgfile("JTM_config_etc.jl"))


# always provide the local timezone (above, with JTM_local_tz)
# and the reference "timezone" (UTC)
# and the internal  "timezone" (TAI)

_utc_tz_name = "UTC"
_utc_tz_num  =  _tzname_to_tznum[ _utc_tz_name ]
_tai_tz_name = "TAI"
_tai_tz_num  =  _tzname_to_tznum[ _tai_tz_name ]

