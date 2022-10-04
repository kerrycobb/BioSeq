# TODO: Check on bitSeq proc
# TODO: Make proc to reverse bitseq and proc to complement bitseq
# TODO: Write custom bitseq code to eliminate external dependancy.

## Bit array representation of nucleotide sequence. This module contains functions
## to store `StrictNucleotides` in a bit sequence. This module import the 
## bit sequence implementation in the `bitty<https://github.com/treeform/bitty>`_ package.
## 
## Nucleotide bit patterns:
## ========== ===========
## Nucleotide Bit Pattern
## ========== ===========
## A          00
## G          10 
## C          01 
## T          11 
## ========== ===========

import ./nucleotide
import bitty
export bitty

type
  TwoBitSequence*[T: StrictNucleotide] = ref object
    bitArray: BitArray 
    len: int

func newTwoBitSequence*[T](len: int): TwoBitSequence[T] = 
  ## Create new two bit sequence array
  result = TwoBitSequence[T](bitArray: newBitArray(2 * len))
  result.len = len

func bitSeq*[T](s: TwoBitSequence[T]): BitArray = s.bitArray 
  ## Gives read only access to bitArray. 
  # TODO: Confirm that this is read only

func len*[T](s: TwoBitSequence[T]): int = s.len 
  ## Returns len

func toDNA*[T](s: var TwoBitSequence[T]): TwoBitSequence[StrictDNA] = 
  ## Convert sequence to DNA
  cast[TwoBitSequence[StrictDNA]](s) 

func toRNA*[T](s: var TwoBitSequence[T]): TwoBitSequence[StrictRNA] =  
  ## Convert sequence to RNA
  cast[TwoBitSequence[StrictRNA]](s) 

func `[]`*[T](s: TwoBitSequence[T], loc: int): T = 
  let 
    arrayLoc = 2 * loc
  if s.bitArray[arrayLoc]:
    if s.bitArray[arrayLoc + 1]: result = T(3) 
    else: result = T(1)
  else:
    if s.bitArray[arrayLoc + 1]: result = T(2) 
    else: result = T(0)

func `[]=`*[T](s: var TwoBitSequence[T], loc: int, val: T) = 
  let arrayLoc = 2 * loc 
  case val
  of T(0):
    s.bitArray[arrayLoc] = false 
    s.bitArray[arrayLoc + 1] = false 
  of T(1):
    s.bitArray[arrayLoc] = true 
    s.bitArray[arrayLoc + 1] = false 
  of T(2):
    s.bitArray[arrayLoc] = false 
    s.bitArray[arrayLoc + 1] = true 
  of T(3):
    s.bitArray[arrayLoc] = true 
    s.bitArray[arrayLoc + 1] = true 

func `$`*[T](s: TwoBitSequence[T]): string = 
  result = newString(s.len)
  for i in 0 ..< s.len:
    result[i] = s[i].char

# ##############################################################################
# Code for making bit seqs 

# import std/bitops
# import std/strutils

# type
#   Bit = range[0..1]
#   BitSeq[T: SomeUnsignedInt] = object 
#     bits: seq[T] 
#     len: int

# func toBin*(x: SomeUnsignedInt): string = 
#   ## Return string representation of an integer. Bits are in reverse order
#   # for i in countdown(x.sizeof * 8 - 1, 0):
#   #   result = result & (if testBit(x, i): "1" else: "0")
#   for i in 0 .. x.sizeof * 8 - 1:
#     result = result & (if testBit(x, i): "1" else: "0")

# func newBitSeq*[T](len: int): BitSeq[T] =  
#   ## Construct a new bit sequence with.
#   result = BitSeq[T]()
#   result.bits = newSeq[T]((len + T.sizeof * 8 - 1) div (T.sizeof * 8))
#   result.len = len

# func `[]`*[T](s: BitSeq[T], loc: int): T = s.bits[loc] 
# func len*[T](s: BitSeq[T]): int = s.len

# func `[]=`*[T](s: var BitSeq[T], loc: int, value: Bit) = 
#   assert loc < s.len and loc >= 0, "Index out of range"
#   var w = addr s.bits[loc div (T.sizeof * 8)]
#   if value == 0:
#     w[] = w[] and not (1.T shl (loc and (T.sizeof * 8 - 1)))
#   else:
#     w[] = w[] or (1.T shl (loc and (T.sizeof * 8 - 1)))

# func `$`*[T](s: BitSeq[T]): string = 
#   ## Returns string representation of bits in seq.
#   result = newString(s.len)
#   var pos = 0
#   for i in 0 ..< s.bits.len:
#     # let str =  toBin(int(s[i]), 8)
#     let str =  toBin(s[i])
#     var strPos = 0 
#     while pos < s.len and strPos < str.len: 
#       result[pos] = str[strPos]
#       strPos += 1
#       pos += 1