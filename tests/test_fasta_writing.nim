import std/unittest
import bio_seq
proc fastaWriting()=
  suite "Fasta writing":
    test "":
      let test = ">1\nACTG\n>2\nAAAA"
      let r: Alignment = parseFastaAlignmentString(test)
      let s: string = write_fasta_string(r, false)
      for t in r.seqs:
        echo t

      echo s


fastaWriting()
