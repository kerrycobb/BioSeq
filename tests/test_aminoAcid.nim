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

  block: # Translate Standard Genetic Code
    assert translate([dnaR, dnaW, dnaN], gCode1) == aaX
    assert translate([dnaA, dnaA, dnaG], gCode1) == aaK
    assert translate([dnaA, dnaA, dnaC], gCode1) == aaN
    assert translate([dnaA, dnaA, dnaT], gCode1) == aaN
    assert translate([dnaA, dnaG, dnaA], gCode1) == aaR
    assert translate([dnaA, dnaG, dnaG], gCode1) == aaR
    assert translate([dnaA, dnaG, dnaC], gCode1) == aaS
    assert translate([dnaA, dnaG, dnaT], gCode1) == aaS
    assert translate([dnaA, dnaC, dnaA], gCode1) == aaT
    assert translate([dnaA, dnaC, dnaG], gCode1) == aaT
    assert translate([dnaA, dnaC, dnaC], gCode1) == aaT
    assert translate([dnaA, dnaC, dnaT], gCode1) == aaT
    assert translate([dnaA, dnaT, dnaA], gCode1) == aaI
    assert translate([dnaA, dnaT, dnaG], gCode1) == aaM
    assert translate([dnaA, dnaT, dnaC], gCode1) == aaI
    assert translate([dnaA, dnaT, dnaT], gCode1) == aaI
    assert translate([dnaG, dnaA, dnaA], gCode1) == aaE
    assert translate([dnaG, dnaA, dnaG], gCode1) == aaE
    assert translate([dnaG, dnaA, dnaC], gCode1) == aaD
    assert translate([dnaG, dnaA, dnaT], gCode1) == aaD
    assert translate([dnaG, dnaG, dnaA], gCode1) == aaG
    assert translate([dnaG, dnaG, dnaG], gCode1) == aaG
    assert translate([dnaG, dnaG, dnaC], gCode1) == aaG
    assert translate([dnaG, dnaG, dnaT], gCode1) == aaG
    assert translate([dnaG, dnaC, dnaA], gCode1) == aaA
    assert translate([dnaG, dnaC, dnaG], gCode1) == aaA
    assert translate([dnaG, dnaC, dnaC], gCode1) == aaA
    assert translate([dnaG, dnaC, dnaT], gCode1) == aaA
    assert translate([dnaG, dnaT, dnaA], gCode1) == aaV
    assert translate([dnaG, dnaT, dnaG], gCode1) == aaV
    assert translate([dnaG, dnaT, dnaC], gCode1) == aaV
    assert translate([dnaG, dnaT, dnaT], gCode1) == aaV
    assert translate([dnaC, dnaA, dnaA], gCode1) == aaQ
    assert translate([dnaC, dnaA, dnaG], gCode1) == aaQ
    assert translate([dnaC, dnaA, dnaC], gCode1) == aaH
    assert translate([dnaC, dnaA, dnaT], gCode1) == aaH
    assert translate([dnaC, dnaG, dnaA], gCode1) == aaR
    assert translate([dnaC, dnaG, dnaG], gCode1) == aaR
    assert translate([dnaC, dnaG, dnaC], gCode1) == aaR
    assert translate([dnaC, dnaG, dnaT], gCode1) == aaR
    assert translate([dnaC, dnaC, dnaA], gCode1) == aaP
    assert translate([dnaC, dnaC, dnaG], gCode1) == aaP
    assert translate([dnaC, dnaC, dnaC], gCode1) == aaP
    assert translate([dnaC, dnaC, dnaT], gCode1) == aaP
    assert translate([dnaC, dnaT, dnaA], gCode1) == aaL
    assert translate([dnaC, dnaT, dnaG], gCode1) == aaL
    assert translate([dnaC, dnaT, dnaC], gCode1) == aaL
    assert translate([dnaC, dnaT, dnaT], gCode1) == aaL
    assert translate([dnaT, dnaA, dnaA], gCode1) == aaStp
    assert translate([dnaT, dnaA, dnaG], gCode1) == aaStp
    assert translate([dnaT, dnaA, dnaC], gCode1) == aaY
    assert translate([dnaT, dnaA, dnaT], gCode1) == aaY
    assert translate([dnaT, dnaG, dnaA], gCode1) == aaStp
    assert translate([dnaT, dnaG, dnaG], gCode1) == aaW
    assert translate([dnaT, dnaG, dnaC], gCode1) == aaC
    assert translate([dnaT, dnaG, dnaT], gCode1) == aaC
    assert translate([dnaT, dnaC, dnaA], gCode1) == aaS
    assert translate([dnaT, dnaC, dnaG], gCode1) == aaS
    assert translate([dnaT, dnaC, dnaC], gCode1) == aaS
    assert translate([dnaT, dnaC, dnaT], gCode1) == aaS
    assert translate([dnaT, dnaT, dnaA], gCode1) == aaL
    assert translate([dnaT, dnaT, dnaG], gCode1) == aaL
    assert translate([dnaT, dnaT, dnaC], gCode1) == aaF
    assert translate([dnaT, dnaT, dnaT], gCode1) == aaF