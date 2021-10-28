import std/unittest
import bioseq
proc fastaWriting()=
  suite "Fasta writing":
    test "non-multiline, <80 charactes":
      let test = ">1\nACTG\n>2\nAAAA"
      let r: Alignment = parseFastaAlignmentString(test)
      let s: string = writeFastaAlignmentString(r, false)
      check test == s

    test "multiline, <80 charactes":
      let test = ">1\nACTG\n>2\nAAAA"
      let r: Alignment = parseFastaAlignmentString(test)
      let s: string = writeFastaAlignmentString(r, true)
      check test == s

fastaWriting()
