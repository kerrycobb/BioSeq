import bio_seq
import std/unittest
import std/sequtils


proc fastaParsing()=
  suite "GitHub Examples":
    test "Parse an alignment string":
      let s = ">header1\nACTG\n>header2\n>CTUG"
      let r = parseFastaAlignmentString(s)
      
      check r.seqs.len == 2
      
      let first = r.seqs[0]
      let second = r.seqs[1]
      check first.id == "header1"
      check first.data == "ACTG".map(tonucleotide)
      
      check first.id == "header2"
      check first.data == "CTUG".map(tonucleotide)
