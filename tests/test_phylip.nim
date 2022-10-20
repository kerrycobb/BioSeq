# TODO: Implement some checks expected to fail
# Implement a file parsing and iterator checks

import ../src/bioseq
import unittest 
import std/strutils

let 
  expectedIds = @["Taxon1", "Taxon2", "Taxon3"]
  expectedData = """
    ATGCATGCATGC
    ATGCATGCATGC
    ATGCATGCATGC
    """.dedent()

suite "Phylip Reading":
  test "Interleaved String":    
    let 
      str = """

        3 12 

        Taxon1 AT GC

        Taxon2 AT G C

        Taxon3 AT GC

        ATGC
        
        AT GC

        AT GC

        A T GC

        AT GC

        AT GC
        """
      a = parsePhylipString(str, DNA, Interleaved)
    check a.ids == expectedIds 
    check $a.data == expectedData 


  test "Sequential String":
    let 
      str = """

        3 12 

        Taxon1 AT GC

        AT GC 

        AT GC 

        Taxon2 ATGC

        AT GC 

        AT GC 

        Taxon3 ATG C 

        AT G C 

        AT GC 
        """
      a = parsePhylipString(str, DNA, Sequential)
    check a.ids == expectedIds 
    check $a.data == expectedData 




