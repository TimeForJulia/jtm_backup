# source  : utl_ariths.jl (./extras/tm4julia/util/)
# purpose : Time for Julia facility math essentials
#
# offers  :
#     search_gte(vector,target)
#     checked_search_gte(vector,target)
#
# load&use: search_gte, checked_search_gte
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


export search_gte, checked_search_gte

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

# eof #
