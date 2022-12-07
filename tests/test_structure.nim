import bioseq
import std/unittest
import std/strutils

suite "Structure":
  test "toStructureString":
    let 
      phyString = """
        4 31 
        Sample1   ATGC ATGC AC RR MM WW SS KK YY RRR N-? AAA
        Sample2   ATGC N?-N TG AG AC AT GC GT CT N?- N-? TTA
        Sample3   ATGC N?-? NN AG AC AT GC GT CT N?- N-? GTA
        Sample4   ATGC N?-- ?? AG AC AT GC GT CT N?- N-? GRV
        """
      expected = """
        Sample1  2  0  0  0  2  0  2  2  2  2  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1 -9 -9 -9
        Sample2  2  0  0  0 -9 -9 -9 -9  0  0  2  2  0  0  2  0  2  0  0  0  2  0 -9 -9 -9 -9 -9 -9
        Sample3  2  0  0  0 -9 -9 -9 -9 -9 -9  2  2  0  0  2  0  2  0  0  0  2  0 -9 -9 -9 -9 -9 -9
        Sample4  2  0  0  0 -9 -9 -9 -9 -9 -9  2  2  0  0  2  0  2  0  0  0  2  0 -9 -9 -9 -9 -9 -9""".dedent
      inAlign = parsePhylipString(phyString, DNA, Sequential)
      biAlign = inAlign.toDiploidBiallelic
      structStr = biAlign.toStructureString
    check structStr == expected 