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
# created : 2012-Sep-05 in New York, USA
#
#
# license : This material is available to Julia without encumbrance.
#
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Reserved.


export BYTE_SIZE, bitsizeof,
       negabs,
       quorem, squomod, nonnegMod, wrappedMod

const BYTE_SIZE = div(WORD_SIZE, sizeof(Int))

if     (BYTE_SIZE ==  8)
   bitsizeof(x::Integer) = sizeof(x) << 3
elseif (BYTE_SIZE == 16)
   bitsizeof(x::Integer) = sizeof(x) << 4
else
   bitsizeof(x::Integer) = sizeof(x) * BYTE_SIZE
end


bitcount_without_extremal_zeros(x::Integer) = # bitwidth of single contiguous 1s mask
    min( 0, (bitsizeof(x) - leading_zeros(x) - trailing_zeros(x) )

bitcount_without_extremal_ones(x::Integer)  = # bitwidth of single contiguous 0s filter
    min( 0, (bitsizeof(x) - leading_ones(x)  - trailing_ones(x)  )



SintGroundTypes  = (:Int, :Int8, :Int16, :Int32, :Int64, :Int128)
UintGroundTypes  = (:Uint, :Uint8, :Uint16, :Uint32, :Uint64, :Uint128)
AintGroundTypes  = (:Int, :Int8, :Int16, :Int32, :Int64, :Int128,
                    :Uint, :Uint8, :Uint16, :Uint32, :Uint64, :Uint128)
FloatGroundTypes = (:Float32, :Float64, :FloatingPoint)

SintTypes        = (:Int, :Int8, :Int16, :Int32, :Int64, :Int128, :Signed)
UintTypes        = (:Uint, :Uint8, :Uint16, :Uint32, :Uint64, :Uint128, :Unsigned)
AintTypes        = (:Int, :Int8, :Int16, :Int32, :Int64, :Int128,
                    :Uint, :Uint8, :Uint16, :Uint32, :Uint64, :Uint128,
                    :Signed, :Unsigned, :Integer)
FloatTypes       = (:Float32, :Float64, :FloatingPoint)

(+)(a::Tuple,b::Tuple) = [a..., b...]
(+)(a::Tuple,b::Tuple,c::Tuple) = [a..., b..., c...]

for T in (:Int,:Int32,:Int64,:Float64,:Float32)
    @eval (negabs)(x::($T)) = -(abs(x))
end

for T1 in (:Int,:Int32,:Int64,:Int128,:Uint,:Uint32,:Uint64,:Uint128)
  for T2 in (:Int,:Int32,:Int64,:Int128,:Uint,:Uint32,:Uint64,:Uint128)
    @eval begin
       function quorem(j::($T1), k::($T2))
            q = div(j,k)
          (q, (j - (k*q)))
        end
    end
  end
end


for T in AintTypes
    @eval mulby4(j::($T)) = (j << 2)
end

for T in AintTypes
    @eval mulby7(j::($T)) = (j << 3) - (j)
end

for T in AintTypes
    @eval mulby15(j::($T)) = (j << 4) - (j)
end

for T in AintTypes
    @eval mulby24(j::($T)) = (j << 5) - (j << 3)
end

for T in AintTypes
    @eval mulby60(j::($T)) = (j << 6) - (j << 2)
end


# from note in the errata to Calendrical Calculations 3rd ed
#   x  mod [a..b) = x mod (b..a]
#   x  mod y === x mod [0..y)
#   m amod n === m mod (0,n] == m mod [n,0)

# x mod [a..b)
function mod3(x::Integer, a::Integer, b::Integer)
    a + mod((x-a), (b-a))
end

# similar version of div
function div3(x::Integer, a::Integer, b::Integer)
    div((x-a), (b-a)) - ((x < 0) ? 1 : 0)
end

# a sign smart quotient to go with mod(x,0,b)
function squo(n::Integer, d::Integer)
    div(n,d) - ((n < 0) ? 1 : 0)
end
function squo(n::Integer, a::Integer, b::Integer)
    div((n-a),(b-a)) - (((n-a) < 0) ? 1 : 0)
end

function squomod(n::Integer, a::Integer, b::Integer)
    (squo(n,a,b),mod(n,a,b))
end
function squomod(n::Integer, d::Integer)
    (squo(n,d),mod(n,d))
end


# Purpose:
#
#    I4_MODP returns the nonnegative remainder of I4 division.
#
#  Discussion:
#
#    If
#      NREM = I4_MODP ( I, J )
#      NMULT = ( I - NREM ) / J
#    then
#      I = J * NMULT + NREM
#    where NREM is always nonnegative.
#
#    The MOD function computes a result with the same sign as the
#    quantity being divided.  Thus, suppose you had an angle A,
#    and you wanted to ensure that it was between 0 and 360.
#    Then mod(A,360) would do, if A was positive, but if A
#    was negative, your result would be between -360 and 0.
#
#    On the other hand, I4_MODP(A,360) is between 0 and 360, always.
#
#  Example:
#
#        I         J     MOD  I4_MODP   I4_MODP Factorization
#
#      107        50       7       7    107 =  2 *  50 + 7
#      107       -50       7       7    107 = -2 * -50 + 7
#     -107        50      -7      43   -107 = -3 *  50 + 43
#     -107       -50      -7      43   -107 =  3 * -50 + 43
#
#  Licensing:
#
#    This code is distributed under the GNU LGPL license.
#
#  Modified:
#
#    12 January 2007
#
#  Author:
#
#    John Burkardt
#
#  Source:
#
#    < http://people.sc.fsu.edu/~jburkardt/c_src/weekday/weekday.c >
#
#
#  Parameters:
#
#    Input, int I, the number to be divided.
#
#    Input, int J, the number that divides I.
#
#    Output, int I4_MODP,
#      the nonnegative remainder when I is divided by J.

function nonnegMod(i::Int, j::Int)
    ans = i % j

    if (ans < 0)
       ans + abs(j)
    else
       ans
    end
end

function nonnegMod(i::Integer, j::Integer)
    ans = i % j

    if (ans < 0)
       ans + abs(j)
    else
       ans
    end
end

#  Purpose:
#
#    I4_WRAP forces an I4 to lie between given limits by wrapping.
#
#  Example:
#
#    ILO = 4, IHI = 8
#
#    I   Value
#
#    -2     8
#    -1     4
#     0     5
#     1     6
#     2     7
#     3     8
#     4     4
#     5     5
#     6     6
#     7     7
#     8     8
#     9     4
#    10     5
#    11     6
#    12     7
#    13     8
#    14     4
#
#  Licensing:
#
#    This code is distributed under the GNU LGPL license.
#
#  Modified:
#
#    17 July 2008
#
#  Author:
#
#    John Burkardt
#
#  Parameters:
#
#    Input, int IVAL, an integer value.
#
#    Input, int ILO, IHI, the desired bounds for the integer value.
#
#    Output, int I4_WRAP, a "wrapped" version of IVAL.

function wrappedMod(i::Int, ilo::Int, ihi::Int)
  @assert ilo < ihi
  wide = ihi + 1 - ilo

   if (wide == 1)
      ilo
   else
      nonnegMod( i-ilo, wide )
   end
end

function wrappedMod(i::Integer, ilo::Integer, ihi::Integer)
  @assert ilo < ihi
  wide = ihi + 1 - ilo

   if (wide == 1)
      ilo
   else
      nonnegMod( i-ilo, wide )
   end
end

# eof #
