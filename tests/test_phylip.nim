# TODO: Implement some checks expected to fail.
# Implement a file parsing and iterator checks.
# Should make the checks a little more straightforward once alignment and matrix 
# modules mature.

import ../src/bioseq
import std/unittest 
import std/strutils
import std/enumerate

suite "Single Phylip":
  let 
    ids =  @["Sample1", "Sample2", "Sample3", "Sample4"]
    data = @[
        "ATGCATGCATGC", 
        "TTGCTTGCATGC", 
        "GTGCGTGCATGC", 
        "CTGCCTGCATGC"].join().toNucleotideSeq(DNA)
    expected = newAlignment[DNA](4, 12, ids, data)

  test "Interleaved String":    
    let 
      str = """

        4 12 

        Sample1 ATGC
        Sample2 TTGC
        Sample3 GT GC
        Sample4  CTGC
         ATGC
        T TGC
        GTGC
        CTGC

        ATGC

        ATGC

        ATGC

        ATGC

        """
      a = parsePhylipString(str, DNA, Interleaved)
    check a == expected 

  test "Sequential String":
    let 
      str = """
        4 12 

        Sample1 ATGC

        ATGC

        ATGC

        Sample2  TTGC

        TT GC

          ATGC

        Sample3 GT GC

        GTGC

        ATGC

        Sample4 CTGC

        CTGC

        ATGC

        """.dedent()
      a = parsePhylipString(str, DNA, Sequential)
    check a == expected



suite "Multiple Phylip":    
  let 
    expected = @[
      newAlignment[DNA](2, 8, @["Sample1", "Sample2"], 
          @["ATGCATGC", "TTGCATGC"].join().toNucleotideSeq(DNA)),
      newAlignment[DNA](3, 7, @["Sample3", "Sample4", "Sample5"], 
          @["GTGCATG", "CTGCATG", "ATGCATG"].join().toNucleotideSeq(DNA)),
    ] 
    interleaved = """
      2 8
      Sample1 ATGC
      Sample2 TTGC
      ATGC
      ATGC
      3 7 
      Sample3 GTGC
      Sample4 CTGC
      Sample5 ATGC
      ATG
      ATG
      ATG
      """
    sequential = """
      2 8
      Sample1 ATGC
      ATGC
      Sample2 TTGC
      ATGC
      3 7 
      Sample3 GTGC
      ATG
      Sample4 CTGC
      ATG
      Sample5 ATGC
      ATG
      """

  suite "Read Single From Multiple":

    test "Interleaved":
      let a = parsePhylipString(interleaved, DNA, Interleaved)
      check a == expected[0]

    test "Sequential":
      let a = parsePhylipString(sequential, DNA, Sequential)
      check a == expected[0]

  suite "Phylip Iterators":
    
    test "Interleaved Iterator":
      for i, a in enumerate(iterPhylipString(interleaved, DNA, Interleaved)):
        check a == expected[i]

    test "Sequential Iterator":
      for i, a in enumerate(iterPhylipString(sequential, DNA, Sequential)):
        check a == expected[i]

