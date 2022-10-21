# TODO: Create some tests that are expected to fail

import bioseq
import unittest 
import std/strutils

let 
  expectedSamples = @["Sample1", "Sample2", "Sample3"]
  expectedData = @["TTGCTTGCATGC", "CTGCCTGCATGC", "GTGCGTGCATGC"]

suite "Iter Fasta":
  test "Fasta String":    
    var 
      str = """
        >Sample1

        TT GC
        TT GC
        AT GC
        >Sample2
        CT GC
        CT GC
        AT GC

        >Sample3

        GT GC
         GT GC
        AT GC

        """.dedent
      samples: seq[string]  
      seqs: seq[string]
    for i in iterFastaString(str, DNA):
      samples.add(i.id)
      seqs.add(i.data.toString)
    check samples == expectedSamples 
    check seqs == expectedData 