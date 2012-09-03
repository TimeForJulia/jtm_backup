# source : jtm_dirpaths  (tm4julia/config/)
#
# purpose: transparently use full directory paths
#
# author : Jeffrey A. Sarnoff
# created: 2012-Aug-26 in New York, USA


module JTM_dirpaths

export jtm_srcpath, jtm_typpath, jtm_datpath, jtm_tmzpath, jtm_cfgpath, jtm_utlpath,
       jtm_srcfile, jtm_typpath, jtm_datfile, jtm_tmzfile, jtm_cfgfile, jtm_utlfile

import Base.*
import Main.TM4JULIA_HOME

const JTM_HOME_DIR    = TM4JULIA_HOME
const JTM_TYPE_DIR    = "$(JTM_HOME_DIR)/types"
const JTM_TZDATA_DIR  = "$(JTM_HOME_DIR)/tzdata"
const JTM_TMDATA_DIR  = "$(JTM_HOME_DIR)/tmdata"
const JTM_CONFIG_DIR  = "$(JTM_HOME_DIR)/config"
const JTM_UTILITY_DIR = "$(JTM_HOME_DIR)/util"

jtm_srcpath(relpath::ASCIIString) = "$(JTM_HOME_DIR)/$(relpath)"
jtm_typpath(relpath::ASCIIString) = "$(JTM_TYPE_DIR)/$(relpath)"
jtm_datpath(relpath::ASCIIString) = "$(JTM_TMDATA_DIR)/$(relpath)"
jtm_tmzpath(relpath::ASCIIString) = "$(JTM_TZDATA_DIR)/$(relpath)"
jtm_cfgpath(relpath::ASCIIString) = "$(JTM_CONFIG_DIR)/$(relpath)"
jtm_utlpath(relpath::ASCIIString) = "$(JTM_UTILITY_DIR)/$(relpath)"

jtm_srcfile(relfile::ASCIIString) = "$(JTM_HOME_DIR)/$(relfile)"
jtm_typfile(relfile::ASCIIString) = "$(JTM_TYPE_DIR)/$(relfile)"
jtm_datfile(relfile::ASCIIString) = "$(JTM_TMDATA_DIR)/$(relfile)"
jtm_tmzfile(relfile::ASCIIString) = "$(JTM_TZDATA_DIR)/$(relfile)"
jtm_cfgfile(relfile::ASCIIString) = "$(JTM_CONFIG_DIR)/$(relfile)"
jtm_utlfile(relfile::ASCIIString) = "$(JTM_UTILITY_DIR)/$(relfile)"


end # module

