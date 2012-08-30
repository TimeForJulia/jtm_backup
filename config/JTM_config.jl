# source : JTM_config.jl (./extras/tm4julia/config/)
# purpose: provides internal configuration settings
#
# author : Jeffrey A. Sarnoff
# created: 2012-Jun-18 in New York, USA
# revised: 2012-Aug-14

import Main.jtm_cfgfile

require(jtm_cfgfile("JTM_config_tz.jl"))
import JTM_config_tz.*
require(jtm_cfgfile("JTM_local_tz.jl"))
import JTM_local_tz.*
require(jtm_cfgfile("JTM_config_etc.jl"))
import JTM_config_etc.*

