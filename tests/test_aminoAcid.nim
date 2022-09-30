import bioseq

block: # aminoAcid
  block: # Parsing
    assert parseChar('A', AminoAcid).char == 'A'
    assert parseChar('C', AminoAcid).char == 'C'
    assert parseChar('D', AminoAcid).char == 'D'
    assert parseChar('E', AminoAcid).char == 'E'
    assert parseChar('F', AminoAcid).char == 'F'
    assert parseChar('G', AminoAcid).char == 'G'
    assert parseChar('H', AminoAcid).char == 'H'
    assert parseChar('I', AminoAcid).char == 'I'
    assert parseChar('K', AminoAcid).char == 'K'
    assert parseChar('L', AminoAcid).char == 'L'
    assert parseChar('M', AminoAcid).char == 'M'
    assert parseChar('N', AminoAcid).char == 'N'
    assert parseChar('O', AminoAcid).char == 'O'
    assert parseChar('P', AminoAcid).char == 'P'
    assert parseChar('Q', AminoAcid).char == 'Q'
    assert parseChar('R', AminoAcid).char == 'R'
    assert parseChar('S', AminoAcid).char == 'S'
    assert parseChar('T', AminoAcid).char == 'T'
    assert parseChar('U', AminoAcid).char == 'U'
    assert parseChar('V', AminoAcid).char == 'V'
    assert parseChar('W', AminoAcid).char == 'W'
    assert parseChar('Y', AminoAcid).char == 'Y'
    assert parseChar('*', AminoAcid).char == '*'
    assert parseChar('X', AminoAcid).char == 'X'
    assert parseChar('B', AminoAcid).char == 'B'
    assert parseChar('Z', AminoAcid).char == 'Z'

  block: # Translate
    assert translate([dnaA, dnaA, dnaA], acStandard) == aaK
    assert translate([dnaT, dnaT, dnaT], acStandard) == aaF
    assert translate([dnaN, dnaT, dnaT], acStandard) == aaX
    assert translate([rnaA, rnaA, rnaA], acStandard) == aaK