import bioseq
import std/unittest
import std/sequtils

proc fastaParsing()=
  suite "Fasta alignment parsing":
    test "Parse single line fasta with empty header":
      let test = ">\nACTG"
      
      let r: Alignment = parseFastaAlignmentString(test)
      check r.seqs.len == 1
      
      let first = r.seqs[0]
      check r.seqs.len == 1
      check first.id == ""
      check first.data == "ACTG".map(toNucleotide)

    test "Parse two line fasta with empty header":
      let test = ">\nACTG\n>\nGTCA"
      
      let r: Alignment = parseFastaAlignmentString(test)
      check r.seqs.len == 2
      
      let first = r.seqs[0]
      check first.id == ""
      check first.data == "ACTG".map(toNucleotide)

      let second = r.seqs[1]
      check second.id == ""
      check second.data == "GTCA".map(toNucleotide)

    test "Parse single line fasta with non-empty header":
      let test = ">stuff\nACTG"
      
      let r: Alignment = parseFastaAlignmentString(test)
      let first = r.seqs[0]
      check first.id == "stuff"
      check first.data == "ACTG".map(toNucleotide)

    test "Parse single line fasta with empty sequence":
      let test = ">stuff\n"
      let r: Alignment = parseFastaAlignmentString(test)
      let first = r.seqs[0]
      check first.id == "stuff"
      check first.data == []

    test "parse invalid chars":
      let test = ">\nACTE"
      expect(NucleotideError):
        let r: Alignment = parseFastaAlignmentString(test)

    test "parse emty stream":
      let test = ""
      expect(FastaError):
        let r: Alignment = parseFastaAlignmentString(test)

    test "nil stream":
      expect(FastaError):
        let r: Alignment = parseFastaAlignmentStream(nil)

    #[test "parse different length sequences":
      let test = ">stuff\nACTG\n>\nACTGA"
      let r: Fasta = parseFastaString(test)
      let first = r.seqs[0]
      check first.id == "stuff"
      check first.data == "ACTG".map(toNucleotide)
    ]#
  suite "Fasta parsing":
    test "parse different length sequences":
      let test = ">stuff\nACTG\n>\nACTGA"
      let r: Fasta = parseFastaString(test)
      let first = r.seqs[0]
      check first.id == "stuff"
      check first.data == "ACTG".map(toNucleotide)


fastaParsing()
