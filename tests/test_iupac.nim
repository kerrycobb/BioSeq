import bio_seq
import std/unittest


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

      # Double codes
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
      
      let isNotKnown: uint8 = 0b1111_0000
      # Triple codes
      r = 'V'.toNucleotide
      check r == ( ('A'.toNucleotide xor 'G'.toNucleotide xor 'C'.toNucleotide) and isNotKnown)

      r = 'H'.toNucleotide
      check r == (( 'A'.toNucleotide xor 'C'.toNucleotide xor 'T'.toNucleotide) and isNotKnown)

      r = 'D'.toNucleotide
      check r == (( 'A'.toNucleotide xor 'G'.toNucleotide xor 'T'.toNucleotide ) and isNotKnown)

      r = 'B'.toNucleotide
      check r == (( 'G'.toNucleotide xor 'C'.toNucleotide xor 'T'.toNucleotide) and isNotKnown)
      
      # Quadruple nucletodes
      r = 'N'.toNucleotide
      check r == ( 'A'.toNucleotide xor 'G'.toNucleotide xor 'C'.toNucleotide xor 'T'.toNucleotide)

      #Gap
      r = '-'.toNucleotide
      check r == 0b0000_0100

      #Unknown
      r = '?'.toNucleotide
      check r == 0b0000_0010

      #----------------------------------------------
      #Iupac to char tests
      #----------------------------------------------
      var n: Nucleotide = Nucleotide(136)
      var c = n.toChar
      check c == 'A'

      n = Nucleotide(72)
      c = n.toChar
      check c == 'G'
      
      n = Nucleotide(40)
      c = n.toChar
      check c == 'C'
      
      n = Nucleotide(24)
      c = n.toChar
      check c == 'T'

      n = Nucleotide(192)
      c = n.toChar
      check c == 'R'
      
      n = Nucleotide(160)
      c = n.toChar
      check c == 'M'
      
      n = Nucleotide(144)
      c = n.toChar
      check c == 'W'
      
      n = Nucleotide(96)
      c = n.toChar
      check c == 'S'
      
      n = Nucleotide(80)
      c = n.toChar
      check c == 'K'
      
      n = Nucleotide(48)
      c = n.toChar
      check c == 'Y'

      n = Nucleotide(224)
      c = n.toChar
      check c == 'V'

      n = Nucleotide(176)
      c = n.toChar
      check c == 'H'

      n = Nucleotide(208)
      c = n.toChar
      check c == 'D'

      n = Nucleotide(112)
      c = n.toChar
      check c == 'B'


      n = Nucleotide(240)
      c = n.toChar
      check c == 'N'

      n = Nucleotide(4)
      c = n.toChar
      check c == '-'

      n = Nucleotide(2)
      c = n.toChar
      check c == '?'

      #----------------------------------------------
      # IUPAC Complement tests
      #----------------------------------------------
    test "Complement":
      var comp: Nucleotide
      var n: Nucleotide
      n = 'A'.toNucleotide
      comp = n.complement
      check comp == 'T'.toNucleotide

      n = 'T'.toNucleotide
      comp = n.complement
      check comp == 'A'.toNucleotide


      n = 'G'.toNucleotide
      comp = n.complement
      check comp == 'C'.toNucleotide

      n = 'C'.toNucleotide
      comp = n.complement
      check comp == 'G'.toNucleotide

      n = 'R'.toNucleotide # R = A G
      comp = n.complement  # Y = T C
      check comp == 'Y'.toNucleotide

      n = 'M'.toNucleotide # M = A C
      comp = n.complement  # K = T G
      check comp == 'K'.toNucleotide

      n = 'W'.toNucleotide # W = A T
      comp = n.complement  # W = T A
      check comp == 'W'.toNucleotide
      
      n = 'S'.toNucleotide # S = G C
      comp = n.complement  # S = C G
      check comp == 'S'.toNucleotide
      
      n = 'K'.toNucleotide # K = G T
      comp = n.complement  # M = C A
      check comp == 'M'.toNucleotide

      n = 'Y'.toNucleotide # Y = C T
      comp = n.complement  # R = G A
      check comp == 'R'.toNucleotide

      n = 'V'.toNucleotide # V = A G C = Not T
      comp = n.complement  # B = T C G = Not A
      check comp == 'B'.toNucleotide

      n = 'H'.toNucleotide # H = A C T = Not G
      comp = n.complement  # D = T G A = Not C
      check comp == 'D'.toNucleotide

      n = 'D'.toNucleotide # D = A G T = Not C
      comp = n.complement  # H = T C A = Not G
      check comp == 'H'.toNucleotide

      n = 'B'.toNucleotide # B = T G C = Not A
      comp = n.complement  # V = A C G = Not T
      check comp == 'V'.toNucleotide

      n = '-'.toNucleotide  
      comp = n.complement   
      check comp == '-'.toNucleotide

      n = '?'.toNucleotide  
      comp = n.complement   
      check comp == '?'.toNucleotide
testIupac()

