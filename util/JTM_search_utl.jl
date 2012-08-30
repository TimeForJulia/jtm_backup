

module JTM_search_utl

export search_gte, checked_search_gte

import Base.*

# for all index-finding vector searches
#
# returns
#              0    iff   x <  a[1]
#       length(a)   iff   x >= a[end]
#   otherwise  i    a[i] >= x    and   a[i+a] < x
#
# invariants adapted from Go language binary search

function search_gte(a::Array{Int,1}, x::Int)
  # Define f(0) == false and f(length(a)+1)== true.
  # Invariant: f(i-1) == false, f(j) == true.
  i, j = 1, (length(a)+1)
  while(i < j)
    h = i + ((j-i) >> 1) # i <= h < j, avoids overflow
    if (a[h] <= x)
      i = h + 1        # preserves f(i-1) == false
    else
      j = h            # preserves f(j) == true
    end
  end
  # i == j, f(i-1) == false, and f(j) (= f(i)) == true  =>  answer is i.
  return i-1
end

function checked_search_gte(a::Array{Int,1}, x::Int)
    if (x < a[1])
       return 0
    elseif (x >= a[end])
       return length(a)
    end
    gte_search(a,x)
end

end # module

