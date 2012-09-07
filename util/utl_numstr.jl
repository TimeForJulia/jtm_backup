# source  : utl_numstr.jl (./extras/tm4julia/util/)
# purpose : Time for Julia facility sorted vector search
#
# offers  : 
#     ensure_signed,
#     zeroFillAtBgn, zeroFillAtEnd, spaceFillAtBgn, spaceFillAtEnd
#
# load&use: all
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


export ensure_signed, 
       zeroFillAtBgn, zeroFillAtEnd, spaceFillAtBgn, spaceFillAtEnd



# display: micropreformat, print and show

const zeroChars  = "00000000000000"
const spaceChars = "                                                                              "

function nChars(s::ASCIIString, n::Int, chrs::ASCIIString)
  n = max(0, n - strlen(s))
  if (n > 0) 
     chrs[1:n]
  else
     "" 
  end
end

nCharPrefix (s::ASCIIString, n::Int, chrs::ASCIIString) = "$(nChars(s,n,chrs))$(s)"
nCharPostfix(s::ASCIIString, n::Int, chrs::ASCIIString) = "$(s)$(nChars(s,n,chrs))"

zeroFillAtBgn (s::ASCIIString, n::Int) = nCharPrefix( s, n, zeroChars) 
zeroFillAtEnd (s::ASCIIString, n::Int) = nCharPostfix(s, n, zeroChars)
spaceFillAtBgn (s::ASCIIString, n::Int) = nCharPrefix (s, n, spaceChars)
spaceFillAtEnd (s::ASCIIString, n::Int) = nCharPostfix(s, n, spaceChars)

ensureSigned(j::Number) = "$((j > 0) ? ('+') : (((j < 0)|(j==-0.0)) ? '-' : ' '))$(abs(j))"

# eof #
