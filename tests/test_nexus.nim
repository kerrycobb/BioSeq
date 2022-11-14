import std/unittest
import std/strutils
import bioseq

suite "Nexus Writer":
  test "DNA":
    let
      align = newAlignment[DNA](4, 12, 
        @["Sample1", "Sample2", "Sample3", "Sample4"], 
        @[
          "ATGCATGCATGC", 
          "TTGCTTGCATGC", 
          "GTGCGTGCATGC", 
          "CTGCCTGCATGC"].join.toSeq(DNA))
      expectedString = """ 
        #NEXUS
        BEGIN DATA;
            DIMENSIONS NTAX=4 NCHAR=12;
            FORMAT DATATYPE=DNA MISSING=? GAP=-;
            MATRIX
                Sample1    ATGCATGCATGC
                Sample2    TTGCTTGCATGC
                Sample3    GTGCGTGCATGC
                Sample4    CTGCCTGCATGC
            ;
        END;""".dedent
    let nexString = align.toNexusString
    check nexString == expectedString

  test "HaploidBiallelic":
    let
      align = newAlignment[HaploidBiallelic](4, 12, 
        @["Sample1", "Sample2", "Sample3", "Sample4"], 
        @[
          "011001010101", 
          "010101010101", 
          "010101010101", 
          "010101010101"].join.toSeq(HaploidBiallelic))
      expectedString = """ 
        #NEXUS
        BEGIN DATA;
            DIMENSIONS NTAX=4 NCHAR=12;
            FORMAT DATATYPE=STANDARD SYMBOLS="01" MISSING=? GAP=-;
            MATRIX
                Sample1    011001010101
                Sample2    010101010101
                Sample3    010101010101
                Sample4    010101010101
            ;
        END;""".dedent
    let nexString = align.toNexusString
    check nexString == expectedString


  test "DiploidBiallelic":
    let
      align = newAlignment[DiploidBiallelic](4, 12, 
        @["Sample1", "Sample2", "Sample3", "Sample4"], 
        @[
          "012000111222", 
          "012012012012", 
          "012012012012", 
          "012012012012"].join.toSeq(DiploidBiallelic))
      expectedString = """ 
        #NEXUS
        BEGIN DATA;
            DIMENSIONS NTAX=4 NCHAR=12;
            FORMAT DATATYPE=STANDARD SYMBOLS="012" MISSING=? GAP=-;
            MATRIX
                Sample1    012000111222
                Sample2    012012012012
                Sample3    012012012012
                Sample4    012012012012
            ;
        END;""".dedent
    let nexString = align.toNexusString
    check nexString == expectedString