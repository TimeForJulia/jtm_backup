# source  : utl_char.jl (./extras/tm4julia/util/)
# purpose : augment stdlib capabilities for Char
#
# offers  : 
#     haschr(s,c)    occurs  (any cs in s)       haschr("abc",'b')    == true
#     delchr(s,c)    delete  (s without cs)      delchr("a_b",'_')    == "ab"
#     rplchr(s,c,r)  replace (s with cs as rs)   rplchr("ab",'b','z') == "az"
#
# load&use: haschr, delchr, rplchr
# import  : none
#
# author  : Jeffrey A. Sarnoff
# contact : jeffrey(dot)sarnoff(at)gmail
#
# created : 2012-Aug-14 in New York, USA
# revised : 2012-Sep-05 (modularized)
#
# license : This material is available to Julia without encumbrance.
#
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Reserved.

# provide access on include for these functions
export haschr, delchr, rplchr

haschr(s::String,c::Char) = (strchr(s,c) > 0)

delchr(s::String,c::Char) = haschr(s,c) ? join(split(s,c)) : s

rplchr(s::String,c::Char,newc::Char) = haschr(s,c) ? join(split(s,c),newc) : s
rplchr(s::String,c::Char) = delchr(s,c)



# eof #
