

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

