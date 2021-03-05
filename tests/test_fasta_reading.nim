import nim_seq
import std/unittest
import std/sequtils

proc fastaParsing()=
  suite "Fasta parsing":
    test "Parse single line fasta wit header":
      let test = ">\nACTG"
      let r: Alignment = parseFastaAlignmentString(test)
      let first = r.seqs[0]
      check first.id == ""
      check first.data == "ACTG".map(toNucleotide)

    test "Parse single line fasta wit header":
      let test = ">\nACTG\n>\nGTCA"
      let r: Alignment = parseFastaAlignmentString(test)
      let first = r.seqs[0]
      check first.id == ""
      check first.data == "ACTG".map(toNucleotide)

      let second = r.seqs[1]
      check second.id == ""
      check second.data == "GTCA".map(toNucleotide)





fastaParsing()
