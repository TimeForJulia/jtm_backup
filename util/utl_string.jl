# source  : utl_string.jl (./extras/tm4julia/util/)
# purpose : augment stdlib capabilities for String
#
# offers  : 
#     capitalize(s)  capitalize("ticToc")          ==  "TicToc"
#     
#     camelcase("tic toc") == camelcase("tic_toc") ==  "TicToc"
#     camelcase(s)   camelcase("_tic toc_")        == "_TicToc_"
#     camelcase(s,c) camelcase("tic-toc","-")      ==  "TicToc"
#
# conveys :
#     from module utl_char in "utl_char.jl"
#
#     haschr(s,c)    occurs  (any cs in s)       haschr("abc",'b')    == true
#     delchr(s,c)    delete  (s without cs)      delchr("a_b",'_')    == "ab"
#     rplchr(s,c,r)  replace (s with cs as rs)   rplchr("ab",'b','z') == "az"
#
# load&use: camelcase, haschr
# import  : capitalize, delchr, rplchr
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

export capitalize, camelcase
# utl_char.jl autoexports haschr, delchr, rplchr

import _jtm.jtm_utlfile
include(jtm_utlfile("utl_char"))


capitalize(s::String) = (s!="") ? strcat(uppercase(s[1]),s[2:]) : s

camelcase(s::String,c::Char) = join(map(x->capitalize(x),split(s,c)))
camelcase(s::String) = haschr(s,' ') ? camelcase(s,' ') : camelcase(s,'_')

# eof #
