# TODO: Implement some checks expected to fail.
# Implement a file parsing and iterator checks.
# Should make the checks a little more straightforward once alignment and matrix 
# modules mature.

import ../src/bioseq
import std/unittest 
import std/strutils

suite "Phylip Reading":
  let 
    expectedIds =  @["Sample1", "Sample2", "Sample3", "Sample4"]
    expectedData = @[
        "ATGCATGCATGC", 
        "TTGCTTGCATGC", 
        "GTGCGTGCATGC", 
        "CTGCCTGCATGC"].join()

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
    check a.ids == expectedIds
    check a.data.toString.replace("\n", "") == expectedData 
    check a.nseqs == 4
    check a.nchars == 12

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
    check a.ids == expectedIds
    check a.data.toString.replace("\n", "") == expectedData 
    check a.nseqs == 4
    check a.nchars == 12