import bioseq
import std/unittest
import std/strutils


suite "Biallelic":
  test "Haploid":
    check parseChar('0', HaploidBiallelic).toChar == '0'
    check parseChar('1', HaploidBiallelic).toChar == '1'
    check parseChar('-', HaploidBiallelic).toChar == '-'
    check parseChar('?', HaploidBiallelic).toChar == '?'

  test "Diploid":
    check parseChar('0', DiploidBiallelic).toChar == '0'
    check parseChar('1', DiploidBiallelic).toChar == '1'
    check parseChar('2', DiploidBiallelic).toChar == '2'
    check parseChar('-', DiploidBiallelic).toChar == '-'
    check parseChar('?', DiploidBiallelic).toChar == '?'

  test "toDiploidBiallelic":
    let 
      phyString = """
        4 31 
        Sample1   ATGC ATGC AC RR MM WW SS KK YY RRR N-? AAA
        Sample2   ATGC N?-N TG AG AC AT GC GT CT N?- N-? TTA
        Sample3   ATGC N?-? NN AG AC AT GC GT CT N?- N-? GTA
        Sample4   ATGC N?-- ?? AG AC AT GC GT CT N?- N-? GRV
        """
      expected = """
        4 28
        Sample1 2000202222111111111111111?-?
        Sample2 2000??-?00220020200020??-?-?
        Sample3 2000??-???220020200020??-?-?
        Sample4 2000??--??220020200020??-?-?""".dedent
      inAlign = parsePhylipString(phyString, DNA, Sequential)
      biAlign = inAlign.toDiploidBiallelic
      biPhyString = toPhylipString(biAlign, Interleaved)
    check biPhyString == expected