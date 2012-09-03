# source : strutils.jl (./extras/tm4julia/support/)
# purpose: augment stdlib char and string handling
#
# offers : haschr(s,c)    f("abcd",'b')       --> true
#          delchr(s,c)    f("zAzBzCz",'z')    --> "ABC"
#          rplchr(s,c,r)  f("azczzd",'z','b') --> "abcbbd"
#          capitalize(s)  f("abcd")           --> "Abcd"
#          camelcase(s,c) f("stuv_abcd",'_')  --> "StuvAbcd"
#
# author : Jeffrey A. Sarnoff
# created: 2012-Aug-14 in New York, USA
#

# module JTM_string_utl
#
# import Base.*
# export haschr, delchr, rplchr, capitalize, camelcase

haschr(s::String,c::Char) = (strchr(s,c) > 0)
delchr(s::String,c::Char) = haschr(s,c) ? join(split(s,c)) : s
rplchr(s::String,c::Char,newc::Char) = haschr(s,c) ? join(split(s,c),newc) : s
rplchr(s::String,c::Char) = delchr(s,c)

capitalize(s::String) = (s!="") ? strcat(uppercase(s[1]),s[2:]) : s
camelcase(s::String,c::Char) = join(map(x->capitalize(x),split(s,c)))
camelcase(s::String) = haschr(s,'_') ? camelcase(s,'_') : camelcase(s,' ')

# end # module

