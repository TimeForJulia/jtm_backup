# source  : multifield.jl (./extras/tm4julia/bitstype/)
# purpose : use multibit subspans of a bitstype
#             as fields of a concrete type
#
# offers  :
#
# load&use: all
# import  : none
#
# author  : Jeffrey A. Sarnoff
# contact : jeffrey(dot)sarnoff(at)gmail
#
# created : 2012-Sep-06 in New York, USA
#
#
# license : This material is available to Julia without encumbrance.
#
# Copyright (c) 2012 by Jeffrey A. Sarnoff.  All Rights Reserved.



# Bit spans required for each one of the multifields:

# 22 bis hold the largest DayTAI that is accepted
# 17 bits hold the number of seconds in a day.
# --
# 39 bits hold all DayTAI and SecondsOfDay information.
#
#
#  9 bits hold all IANA timezone identifiers
# 11 bits hold minutes_offset_from_utc_to_localtime
# --
# 20 bits hold all the co-resident timezone information
#
# __
# 59 bits
#
#
#  9 bits hold all IANA timezone identifiers
# 11 bits hold minutes_offset_from_utc_to_localtime
# --
# 20 bits hold all the co-resident timezone information
#
#
# 39 bits hold the largest SecTAI that is accepted
#
# __
# 59 bits    msb:_ _ _ |< 20 bits of timezone >|< 39 bits of SI seconds >| :lsb
#
#
#
#     msb                                                                            lsb
#    | _ _ _ |< 9 bits of tz_enum >|< 11 bits of mins_utc_to_lcl >|< 39 bits of secs   > |
#                                  |<                           50 bits                  |
#     b63      b60            b50      b49                    b39   b38              b0



# bitfield utilities

const BYTE_SIZE = div(WORD_SIZE,sizeof(Int))
bitsizeof(x)    = sizeof(x) * BYTE_SIZE

# bitspanofInteger)
# How many bits are needed to represent an integer value
# (as if there were Int1,Int2,.. Uint1,Uint2,..)
# To comport with [8,16,32,64,128]-bit twos-complement,
#   negative values yield 1+ans(abs(value))
#   unless they are one of the typemin(Signed) values.
# That adjustment is ignored for other [N]-bit Ns.
# !!use ispow2
bitspanof(x::Unsigned) = bitsizeof(x) - leading_zeros(x) + (x==0)
bitspanof(x::Signed)   = bitsizeof(x) - leading_zeros(x) + (x==0) -
                         ((x==typemin(Int8))  | (x==typemin(Int16)) |
                          (x==typemin(Int32)) | (x==typemin(Int64)) |
                          (x==typemin(Int128)))

bitspanof(maxpos::Signed,maxneg::Signed) = bitspanof(maxpos+abs(maxneg)+1)

# julia> (1 << (bitsizeof(x)-leading_zeros(x))) - 1
# bitmask_for_value(a::Integer) = ((((1 << (bitsizeof(a)-leading_zeros(a)-1))-1) << 1) | convert(typeof(a),1))

bitmask_for_value(j::Unsigned) = (((1 << (bitsizeof(x)-leading_zeros(x)-1)) << 1) | 1)- 1

function bitmask_for_value(j::Integer)
	j1 = convert(typeof(j),1)
	sj = convert(Signed,j); uj = convert(Unsigned,j)
	if ( uj > convert(Unsigned,typemin(sj)) )
		return convert(typeof(j), ~(convert(typeof(uj),0)))
	end
	(j1 << bitspanof(j)) - j1
end

bitfilter_for_value(j::Integer) = ~(bitmask_for_value(j))


# value v is to be incorporated into a bitfield b, specified with
#   bitfield_spec = BitfieldSpec(typed0, mask, shfited)
#
#   currentBitfield     = bitfield_spec.embedding # a zero of the same type as embeds the bitfield
#   currentBitfield    |= (v & (~bitfield_spec.lsbmask))
#   currentBitfield   <<= max(min(bitfield_spec.shifted,0),bitsizeof(embedding))
#
#   currentMultifield  |= currentBitfield

type BitfieldSpec{T <: Integer}

    bitwidth       :: T     # count of bits reserved for the bitfield
    fieldshift     :: T     # bitfield_value << shiftbits; 0 <= shiftbits < bitsizeof(typed0)

    unshifted_mask :: T     # 0b0.......0011..1 (trailing_ones(mask) == fieldwidth)
    shifted_filter :: T     # 0b1..110...011..1 ( ~(bitmask << shifted),

    embedded0      :: T     # convert(embedding,0)
    embedding      :: Type  # Integer type wherein to embed the bitfield

    is_signed      :: Bool  # if true, the msb of the bitfield will fill left on retreival
end

    #BitfieldSpec(bitwidth::T, fieldshift::T, unshifted_mask::T, shifted_filter::T, embedding::BitsKind) =
    #   new(bitwidth,fieldshift,unshifted_mask,shifted_filter,embedding)


typedBitfieldSpec = {
    Int64   => BitfieldSpec{  Int64},
    Uint64  => BitfieldSpec{ Uint64},
    Int128  => BitfieldSpec{ Int128},
    Uint128 => BitfieldSpec{Uint128},
}

function genBitfieldSpec( maxValue::Integer, fieldshift::Integer, embedding::Type, is_signed::Bool )

    bitwidth       = convert(embedding, bitspanof(maxValue))
    unshifted_mask = convert(embedding, bitmask_for_value(maxValue))
    fieldshift     = convert(embedding, fieldshift)
    shifted_filter = convert(embedding, ~(unshifted_mask << fieldshift))
    embedded0      = convert(embedding, 0)

    typedBitfieldSpec[embedding]( bitwidth, fieldshift, unshifted_mask, shifted_filter, 
                                  embedded0, embedding, is_signed)
end

genBitfieldSpec( maxValue::Integer, fieldshift::Integer, embedding::Type ) =
    genBitfieldSpec(maxValue, fieldshift, embedding, false)

genBitfieldSpec( maxValue::Integer, embedding::Type, is_signed::Bool ) =
    genBitfieldSpec(maxValue, 0, embedding, is_signed)

genBitfieldSpec( maxValue::Integer, embedding::Type ) =
    genBitfieldSpec(maxValue, 0, embedding, false)

genBitfieldSpec( maxValue::Integer ) =
    genBitfieldSpec(maxValue, 0, typeof(maxValue), false)



# TECHUSER NOTE:
# When bitfields may be used in different embeddings, pregenerate your
# bitfield specs with fieldshift=0.  When a specific bitfield layout is
# known, reassign spec.fieldshift as appropriate and reassign
# spec.shifted_filter = (spec.shifted_filter) << spec.fieldshift.
#
# This manner of working is facilitated so:
#
#                        # genBitfieldSpec  ( maxValue        , embedding     )
#      maxValue          = int64(2^24 - 1)
#      readyBitfieldSpec = genBitfieldSpec  ( maxValue        , Uint64        )
#      readyBitfieldSpec = genBitfieldSpec  ( maxValue ) # typeof(maxValue) used
#
#                        # shiftBitfieldSpec( BitfieldSpec    , fieldshift    )
#      fieldshift        = 10
#      fieldshift        = bitfields_to_shift_over(otherBitfieldSpec)
#      fieldshift        = bitfields_to_shift_over([otherBitfieldSpec, anotherBitfieldSpec])
#      thisBitfieldSpec  = shiftBitfieldSpec( readyBitfieldSpec, fieldshift )
#
#
# One may call shiftBitfieldSpec multiple times with different fieldshifts.
# Each call reshifts from an unshifted state, not from any prior shifted postion.

function shiftBitfieldSpec( bitfield_spec::BitfieldSpec, fieldshift )

    fieldshift = convert(bitfield_spec.embedding, fieldshift)
    # reset fieldshift
    bitfield_spec.fieldshift = fieldshift
    # regen shifted_filter
    bitfield_spec.shifted_filter =
        ~(bitfield_spec.unshifted_mask << bitfield_spec.fieldshift)
    # done
    bitfield_spec
end



# sum the bitwidths of all bitfield placed nearer the LSBit
# to ascertain the correct fieldshift for the current bitfield
# an optional unsigned argument can be used to increase the
# the number of bits shifted, interposing unused bits between
# adjacent bitfields (which would be contiguous otherwise).

# function bitfields_to_shift_over( bitfield_specs::Vector{BitfieldSpec{Int64}} )
#   ans = 0
#   for b in bitfield_specs
#    ans += b.bitwidth
#   end
#   ans
# end


for T in (:Int32, :Int64, :Int128, :Uint, :Uint32, :Uint64, :Uint128)
    @eval begin
        bitfields_to_shift_over( bitfield_spec ::BitfieldSpec{($T)}  ) =
            bitfield_spec.bitwidth
        bitfields_to_shift_over( bitfield_specs::Vector{BitfieldSpec{($T)}} ) =
            sum( [(x.bitwidth) for x in bitfield_specs] )
    end
end

#bitfields_to_shift_over( bitfield_spec ::BitfieldSpec{Int64}  ) = bitfield_spec.bitwidth
#function bitfields_to_shift_over( bitfield_specs::Vector{BitfieldSpec{Uint64}} )
#   sum( [(x.bitwidth) for x in bitfield_specs] )
# end
#
# bits_to_shift_over( skipMore::Int, bitfield_specs::BitfieldSpec ) = bits_to_shift_over( int(0), bitfield_specs )
# bits_to_shift_over( bitfield_specs::Vector{BitfieldSpec} )        = bits_to_shift_over( int(0), bitfield_specs )


type MultiBitfieldSpec{T}
	fieldspecs :: Vector{BitfieldSpec{T}}
end

typedMultiBitfieldSpec = {
    Int64   => MultiBitfieldSpec{  Int64},
    Uint64  => MultiBitfieldSpec{ Uint64},
    Int128  => MultiBitfieldSpec{ Int128},
    Uint128 => MultiBitfieldSpec{Uint128}
}



# to associate specific values with fields of a MultiBitfieldSpec

function genMultiBitfieldSpec( bitfield_specs::Vector{BitfieldSpec{Int64}} )
    if (length(bitfield_specs) == 0)
       error("No BitfieldSpecs were submitted")
    end

    embedding = bitfield_specs[1].embedding
    if (length(bitfield_specs) > 1)
        # ensure the embedding type is shared
        for T in bitfield_specs[2:]
            if (T.embedding != embedding)
                error(strcat("All bitfields in a MultiBitfieldSpec must share the same embedding type.\n\t\t",
                             "$(embedding) != $(T.embedding)\n"))
            end
        end
    end

    typedMultiBitfieldSpec[embedding]( bitfield_specs )
end

function setMultiBitfields(values::Vector{Int}, multispec::MultiBitfieldSpec )
    # ensure they are paired
    if ((length(values) != length(multispec.fieldspecs)) || (length(values) == 0))
        error(strcat( "values and specifications must be paired (and not be  empty).\n\t\t",
              "length(values) = $(length(values)), length(multispec.fieldspecs) = $(length(multispec.fieldspecs))\n\t",
              "\tvalues: $(values) \n\t\t fieldspecs: $(multispec.fieldspecs)\n\t\t$(e)\n") )
    end

    ans = multispec.fieldspecs[1].embedded0

    for (val,spec) in zip(values, multispec.fieldspecs)
        val &=  spec.unshifted_mask
        val <<= spec.fieldshift
        ans |=  val
    end

    ans
end

# to retrieve specific values associated with fields of a MultiBitfieldSpec

function getMultiBitfields(multispec::MultiBitfieldSpec, multivalue::Integer )
    if (length(multispec.fieldspecs) == 0)
        error("No individual bitfields are specified.")
    end

    # ensure they are of the same type
    if (typeof(multivalue) != multispec.fieldspecs[1].embedding)
        error("Bitfield type specification must match the type of the value.")
    end

    ans = (multispec.fieldspecs[1].embedding)[]

    for spec in multispec.fieldspecs
        fieldvalue = multivalue
        fieldvalue >>= spec.fieldshift
        fieldvalue &=  spec.unshifted_mask
        push(ans,fieldvalue)
    end

    ans
end



# to retrieve one bitfield from a MultBitfield value

function getBitfield(multispec::MultiBitfieldSpec, multivalue::Integer, multifield_index::Int)

    # ensure they are of the same type
    if (typeof(multivalue) != multispec.fieldspecs[1].embedding)
        error("Bitfield type specification must match the type of the value.")
    end
    # ensure field request is reasonable
    if !(0 < multifield_index <= length(multispec.fieldspecs))
        error("Bitfield index requested ($(multifield_index)) does not exist.")
    end

    spec = multispec.fieldspecs[multifield_index]

    # isolate the field value
    multivalue >>= spec.fieldshift     # retrieve bitfield into least significant bits
    multivalue &=  spec.unshifted_mask # clear all bits not in field bitspan

    # if bitfield is a signed field and the field value is negative
    if (spec.is_signed && (0 != ( multivalue & ((spec.unshifted_mask >> 1) $ spec.unshifted_mask)) ))
       multivalue |= (~spec.unshifted_mask)  # left fill with 1s
    end

    multivalue
end


# to alter the contents one bitfield from a MultBitfield value

function setBitfield(multispec::MultiBitfieldSpec, multivalue::Integer,
                     multifield_index::Int, new_bitfield_value::Integer )

    # ensure they are of the same type
    if (typeof(multivalue) != multispec.fieldspecs[1].embedding)
        error("Bitfield type specification must match the type of the value.")
    end
    # ensure field request is reasonable
    if !(0 < multifield_index <= length(multispec.fieldspecs))
        error("Bitfield index requested ($(multifield_index)) does not exist.")
    end

    fieldspec = multispec.fieldspecs[multifield_index]

    # clear all bits of this bitfield, keep all other bits of multivalue
    multivalue &= fieldspec.shifted_filter 

    # prep the new field value
    new_bitfield_value &=  fieldspec.unshifted_mask # clear bits not in the field span
    new_bitfield_value <<= fieldspec.fieldshift     # position bitfield for multispec

    # fold in the new field value
    multivalue | new_bitfield_value
end


# generate some BitfieldSpecs
#                                         maxValue           embedding
SecNumber_bitfield    = genBitfieldSpec( (3_214_134 * 86_400), Int64 )  # (ymd_to_secnum(3999,12,31)*seconds_per_day_TAI)
DayNumber_bitfield    = genBitfieldSpec(            3_214_134, Int64 )
SecOfDay_bitfield     = genBitfieldSpec(               86_401, Int64 )
TZindex_bitfield      = genBitfieldSpec(                  480, Int64 )

# >>> IMPORTANT:  (mulby60-->secs) addto UTC get Local
#
TZaddUTCmins_bitfield = genBitfieldSpec(       ((14+12+1)*60), Int64 )  # -14h .. +12h in minutes

# position some BitfieldSpecs for use in a MultiBitfieldSpec

TZindex_bitfield      = shiftBitfieldSpec(TZindex_bitfield,
                                          bitfields_to_shift_over( SecNumber_bitfield  ) )
TZaddUTCmins_bitfield = shiftBitfieldSpec(TZaddUTCmins_bitfield,
                                          bitfields_to_shift_over( [TZindex_bitfield, SecNumber_bitfield] ) )



# recommended field orderings
#
# msb:_ _ _ _ _ TZaddUTCmins TZindex SecNumber                    :at_lsb
# msb:_ _ _ _ _ TZaddUTCmins TZindex DayNumber SecOfDay           :at_lsb
# or with separators (for immediate (masked) additon/subtraction)
# msb:_ _ _ _   TZaddUTCmins TZindex _ SecNumber                  :at_lsb
# msb:_ _ _     TZaddUTCmins TZindex _ DayNumber _ SecOfDay       :at_lsb


# generate a multiBitfield
SecNumberTZ_bitfields = [TZaddUTCmins_bitfield, TZindex_bitfield, SecNumber_bitfield]
SecNumberTZ_multifield = genMultiBitfieldSpec( SecNumberTZ_bitfields )

# test setting multiBitfield values
values=[63 , 15, 3]
secnumtz_test = setMultiBitfields(values, SecNumberTZ_multifield );

# test getting multiBitfield values
test_secnumtz = getMultiBitfields(SecNumberTZ_multifield, secnumtz_test)
println(values == test_secnumtz) 

# test getting bitfield values
println(  (getBitfield(SecNumberTZ_multifield, secnumtz_test,1) == values[1]),
          (getBitfield(SecNumberTZ_multifield, secnumtz_test,2) == values[2]),
          (getBitfield(SecNumberTZ_multifield, secnumtz_test,3) == values[3])  )

# test setting bitfield Values
secnumtz2 = setBitfield(SecNumberTZ_multifield, secnumtz_test,1, values[1]+1)
print(getMultiBitfields(SecNumberTZ_multifield, secnumtz2))
secnumtz2 = setBitfield(SecNumberTZ_multifield, secnumtz2,3, values[3]+1)
print(getMultiBitfields(SecNumberTZ_multifield, secnumtz2))
secnumtz2 = setBitfield(SecNumberTZ_multifield, secnumtz2,2, values[2]+1)
print(getMultiBitfields(SecNumberTZ_multifield, secnumtz2))
