# source : cfg_system.jl (./extras/tm4julia/config/)
# purpose: system related internal configuration settings
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-04 in New York, USA


# facility files with system specific information
#
#    Use of these files is required.


# The IANA standard timezone name for the location 
# of the computer system is given on the first line
# of this file. No other information appears in it.
#
#    |                                                            |
#    ||  Please edit this file to give the correct information,  ||
#    ||  the IANA standard timezone name for your location.      ||
#    |                                                            |
#
const 
filenameLocalTzone = jtm_tzifile("LocalTzone")


# The facility always starts with a small number
#   of timezones preloaded into working memory.
# These IANA standard timezone names are given
#   in "InitialTzones.txt". The local timezone 
#    is not listed here; it is also preloaded.
#
#   Please do not edit that file, (see next); 
#   do recommend changes to the author.
#   
const
filenameInitialTzones  = jtm_tzifile("InitialTzones")

# To expand the list of timezones to be preloaded
#   beyond those listed in "InitialTzones.txt",
#   add IANA standard timezone names, one per line,
#   to the "MoreTzones.txt" file.
#
#   Please do edit this file, and recommend changes.
#   
const 
filenameMoreTzones  = jtm_tzifile("MoreTzones")


# eof #
