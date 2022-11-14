# TODO: 
# - Implement some checks expected to fail. Particularly when sequence length doesn't match nchars
# - Implement a file parsing and iterator checks.
# - Phylip writing checks

import bioseq
import std/unittest 
import std/strutils
import std/enumerate

suite "Single Phylip":
  let 
    expected = newAlignment[DNA](4, 12, 
      @["Sample1", "Sample2", "Sample3", "Sample4"], 
      @[
        "ATGCATGCATGC", 
        "TTGCTTGCATGC", 
        "GTGCGTGCATGC", 
        "CTGCCTGCATGC"].join.toSeq(DNA))

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

        """.dedent
      a = parsePhylipString(str, DNA, Sequential)
    check a == expected



suite "Multiple Phylip":    
  let 
    expected = @[
      newAlignment[DNA](2, 8, @["Sample1", "Sample2"], 
          @["ATGCATGC", "TTGCATGC"].join.toSeq(DNA)),
      newAlignment[DNA](3, 7, @["Sample3", "Sample4", "Sample5"], 
          @["GTGCATG", "CTGCATG", "ATGCATG"].join.toSeq(DNA)),
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



# import ./nucleotide
# import ./sequence

# var a = newAlignment[DNA](4, 12, 
#       @["S1", "Smp2", "S3", "S4"], 
#       @[
#         "ATGCATGCATGC", 
#         "TTGCATGCATGC", 
#         "GTGCATGCATGC", 
#         "CTGCATGCATGC"].join.toSeq(DNA))

# let n = 30 
# echo a.toPhylipString(Interleaved, lineLength = n)
# echo "---------"
# echo a.toPhylipString(Sequential,  lineLength = n)
# echo "---------"

# a.toPhylipFile("test.phy", Interleaved, lineLength = 20)

# for i in a.toPhylip(Interleaved, lineLength = 20):
  # echo i