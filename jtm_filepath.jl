# source : jtm_filepath  (./jtm/)
#
# purpose: access facility files and directories simply
#
# offers: jtm_topfile, jtm_cfgfile, jtm_utlfile, jtm_typfile,
#         jtm_dayfile, jtm_timfile, jtm_tmdfile, jtm_tzdfile,
#         dir_exists, file_exists, file_empty
#
# require: ./jtm/jtm.jl
#
# author : Jeffrey A. Sarnoff
# contact: jeffrey(dot)sarnoff(at)gmail
#
# created: 2012-Aug-26 in New York, USA
# revised: 2012-Sep-04
#
# license: This material is available to Julia without encumbrance.
#
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Reserved.


# provide full directory paths for accessing facility files

export jtm_topfile, jtm_cfgfile, jtm_tzifile, jtm_utlfile, 
       jtm_typfile, jtm_dayfile, jtm_timfile, jtm_tmdfile, 
       jtm_tzdfile, dir_exists , file_exists, file_empty

# intrafacility file access through subdirectory organization

const JTM_TYPES_DIR   = "$(JULIA_JTM_DIR)/types"
const JTM_CONFIG_DIR  = "$(JULIA_JTM_DIR)/config"
const JTM_INPUT_DIR   = "$(JULIA_JTM_DIR)/io"
const JTM_DAYS_DIR    = "$(JULIA_JTM_DIR)/days"
const JTM_TIMES_DIR   = "$(JULIA_JTM_DIR)/times"
const JTM_UTILITY_DIR = "$(JULIA_JTM_DIR)/util"
const JTM_TZDATA_DIR  = "$(JULIA_JTM_DIR)/tzdata"
const JTM_TMDATA_DIR  = "$(JULIA_JTM_DIR)/tmdata"
const JTM_TZINIT_DIR  = "$(JTM_CONFIG_DIR)/tz_setup"

# intrafacility file access given file | subdir+file | subdir+file+ext
# the subdir can traverse intermediate directory(s): "config/timezones"

jtm_jl_file (subdir::ASCIIString, filename::ASCIIString) = "$(subdir)/$(filename).jl"
jtm_jld_file(subdir::ASCIIString, filename::ASCIIString) = "$(subdir)/$(filename).jld"
jtm_txt_file(subdir::ASCIIString, filename::ASCIIString) = "$(subdir)/$(filename).txt"

jtm_topfile (filename::ASCIIString) = "$(JULIA_JTM_DIR)/$(filename)"
#
jtm_cfgfile (filename::ASCIIString) = jtm_jl_file(JTM_CONFIG_DIR , filename)
jtm_utlfile (filename::ASCIIString) = jtm_jl_file(JTM_UTILITY_DIR, filename)
#
jtm_typfile (filename::ASCIIString) = jtm_jl_file(JTM_TYPES_DIR  , filename)
jtm_dayfile (filename::ASCIIString) = jtm_jl_file(JTM_DAYS_DIR   , filename)
jtm_timfile (filename::ASCIIString) = jtm_jl_file(JTM_TIMES_DIR  , filename)
#
jtm_tmdfile (filename::ASCIIString) = jtm_jld_file(JTM_TMDATA_DIR, filename)
jtm_tzdfile (filename::ASCIIString) = jtm_jld_file(JTM_TZDATA_DIR, filename)
#
jtm_tzifile (filename::ASCIIString) = jtm_txt_file(JTM_TZINIT_DIR, filename)

# directory and file status checks  

dir_exists   (f::ASCIIString) = ((stat(f).mode & 0x4000) != 0x0000)
file_exists  (f::ASCIIString) = ((stat(f).mode & 0x8000) != 0x0000)
file_empty   (f::ASCIIString) = (stat(f).size == 0)

# eof #
