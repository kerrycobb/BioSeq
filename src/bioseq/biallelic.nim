import ./parserMacro
import ./nucleotide
import ./alignment
import std/random
import std/strformat

type DiploidBiallelic* = enum db0, db1, db2, dbGap, dbUnk
const diploidBiallelicChar*: array[DiploidBiallelic, char] = ['0', '1', '2', '-', '?']
proc toChar*(n: DiploidBiallelic): char = diploidBiallelicChar[n]
func parseChar*(c: char, typ: typedesc[DiploidBiallelic]): DiploidBiallelic = 
  ## Parse character to DiploidBiallelic enum type.
  generateParser(c, diploidBiallelicChar, DiploidBiallelic)

type HaploidBiallelic* = enum hb0, hb1, hbGap, hbUnk
const haploidBiallelicChar*: array[HaploidBiallelic, char] = ['0', '1', '-', '?']
proc toChar*(n: HaploidBiallelic): char = haploidBiallelicChar[n]
func parseChar*(c: char, typ: typedesc[HaploidBiallelic]): HaploidBiallelic = 
  ## Parse character to DiploidBiallelic enum type.
  generateParser(c, haploidBiallelicChar, HaploidBiallelic)

type Biallelic* = DiploidBiallelic | HaploidBiallelic

proc toDiploidBiallelic*(a: Alignment[DNA], seed: int64 = 1): Alignment[DiploidBiallelic] = 
  ## Convert DNA alignment to biallelic alignment. Filters out sites with more
  ## than two character states. N treated as missing data.
  # TODO: Implement options for rataining multi allelic sites. 1) Randomly
  # assign ancestral state. 2) Use reference sequence for assigning ancestral state.
  randomize(seed)
  # Get character states in each alignment column
  var 
    keepCols = newSeqOfCap[int](a.nchars)
    charSets = newSeqOfCap[set[DNA]](a.nchars)
  for col in 0 ..< a.nchars:    
    var charSet: set[DNA]
    for row in 0 ..< a.nseqs:
      var c = a.data[row, col] 
      if not (c in {dnaN, dnaGap, dnaUnk}):
        charSet.incl(toUnambiguousSet(a.data[row, col]))
    if charset.len <= 2:
      keepCols.add(col)
      charSets.add(charSet)

  # Construct new alignment with biallelic columns
  result = newAlignment[DiploidBiallelic](a.nseqs, keepCols.len)
  result.ids = a.ids
  for col in 0 ..< keepCols.len:
    let charSet = charSets[col]
    case charSet.len:
    of 2: 
      var refAllele = sample(charSet) 
      for row in 0 ..< a.nseqs:
        let c = a.data[row, keepCols[col]]  
        case c  
        of dnaA, dnaT, dnaG, dnaC:
          if c == refAllele:
            result.data[row, col] = db0
          else:
            result.data[row, col] = db2
        of dnaR, dnaM, dnaW, dnaS, dnaK, dnaY:
          result.data[row, col] = db1
        of dnaN, dnaUnk:
          result.data[row, col] = dbUnk
        of dnaGap:
          result.data[row, col] = dbGap
        else:
          raise newException(ValueError, fmt"Internal Error: Unexpected character {c}.")
    of 0:
      for row in 0 ..< a.nseqs:
        let c = a.data[row, keepCols[col]]
        case c
        of dnaN, dnaUnk:
          result.data[row, col] = dbUnk
        of dnaGap:
          result.data[row, col] = dbGap
        else:
          raise newException(ValueError, fmt"Internal Error: Unexpected character {c}.")
    of 1:
      let r = sample([db0, db2])
      for row in 0 ..< a.nseqs:
        let c = a.data[row, keepCols[col]]
        case c
        of dnaA, dnaG, dnaC, dnaT:
          result.data[row, col] = r 
        of dnaN, dnaUnk:
          result.data[row, col] = dbUnk
        of dnaGap:
          result.data[row, col] = dbGap
        else:
          raise newException(ValueError, fmt"Internatl Error: Unexpected character {c}.")
    else:
      raise newException(ValueError, "Internal Error: Unexpected set length.")
