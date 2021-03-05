import nim_seq
import std/unittest
import std/sequtils
import bitops


proc testIupac()=
  suite "test conversion":
    test "bases to iupac":
      var r = 'A'.toNucleotide
      check r == 0b1000_1000 
      check r == 136

      r = 'G'.toNucleotide
      check r == 0b0100_1000
      check r == 72

      r = 'C'.toNucleotide
      check r == 0b0010_1000
      check r == 40

      r = 'T'.toNucleotide
      check r == 0b0001_1000
      check r == 24

      r = 'R'.toNucleotide
      check r == ( 'A'.toNucleotide xor 'G'.toNucleotide )

      r = 'M'.toNucleotide
      check r == ( 'A'.toNucleotide xor 'C'.toNucleotide )

      r = 'W'.toNucleotide
      check r == ( 'A'.toNucleotide xor 'T'.toNucleotide )

      r = 'S'.toNucleotide
      check r == ( 'G'.toNucleotide xor 'C'.toNucleotide )
      
      r = 'K'.toNucleotide
      check r == ( 'G'.toNucleotide xor 'T'.toNucleotide )
      
      r = 'Y'.toNucleotide
      check r == ( 'C'.toNucleotide xor 'T'.toNucleotide )


testIupac()

