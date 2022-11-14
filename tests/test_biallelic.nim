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