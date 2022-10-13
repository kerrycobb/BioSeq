import ../src/bioseq
import unittest 

suite "Amino Acid":
  test "parseChar":
    check parseChar('A', AminoAcid).char == 'A'
    check parseChar('C', AminoAcid).char == 'C'
    check parseChar('D', AminoAcid).char == 'D'
    check parseChar('E', AminoAcid).char == 'E'
    check parseChar('F', AminoAcid).char == 'F'
    check parseChar('G', AminoAcid).char == 'G'
    check parseChar('H', AminoAcid).char == 'H'
    check parseChar('I', AminoAcid).char == 'I'
    check parseChar('K', AminoAcid).char == 'K'
    check parseChar('L', AminoAcid).char == 'L'
    check parseChar('M', AminoAcid).char == 'M'
    check parseChar('N', AminoAcid).char == 'N'
    check parseChar('O', AminoAcid).char == 'O'
    check parseChar('P', AminoAcid).char == 'P'
    check parseChar('Q', AminoAcid).char == 'Q'
    check parseChar('R', AminoAcid).char == 'R'
    check parseChar('S', AminoAcid).char == 'S'
    check parseChar('T', AminoAcid).char == 'T'
    check parseChar('U', AminoAcid).char == 'U'
    check parseChar('V', AminoAcid).char == 'V'
    check parseChar('W', AminoAcid).char == 'W'
    check parseChar('Y', AminoAcid).char == 'Y'
    check parseChar('*', AminoAcid).char == '*'
    check parseChar('X', AminoAcid).char == 'X'
    check parseChar('B', AminoAcid).char == 'B'
    check parseChar('Z', AminoAcid).char == 'Z'

  test "translate":
    check translateCodon([dnaR, dnaW, dnaN], gCode1) == aaX
    check translateCodon([dnaA, dnaA, dnaG], gCode1) == aaK
    check translateCodon([dnaA, dnaA, dnaC], gCode1) == aaN
    check translateCodon([dnaA, dnaA, dnaT], gCode1) == aaN
    check translateCodon([dnaA, dnaG, dnaA], gCode1) == aaR
    check translateCodon([dnaA, dnaG, dnaG], gCode1) == aaR
    check translateCodon([dnaA, dnaG, dnaC], gCode1) == aaS
    check translateCodon([dnaA, dnaG, dnaT], gCode1) == aaS
    check translateCodon([dnaA, dnaC, dnaA], gCode1) == aaT
    check translateCodon([dnaA, dnaC, dnaG], gCode1) == aaT
    check translateCodon([dnaA, dnaC, dnaC], gCode1) == aaT
    check translateCodon([dnaA, dnaC, dnaT], gCode1) == aaT
    check translateCodon([dnaA, dnaT, dnaA], gCode1) == aaI
    check translateCodon([dnaA, dnaT, dnaG], gCode1) == aaM
    check translateCodon([dnaA, dnaT, dnaC], gCode1) == aaI
    check translateCodon([dnaA, dnaT, dnaT], gCode1) == aaI
    check translateCodon([dnaG, dnaA, dnaA], gCode1) == aaE
    check translateCodon([dnaG, dnaA, dnaG], gCode1) == aaE
    check translateCodon([dnaG, dnaA, dnaC], gCode1) == aaD
    check translateCodon([dnaG, dnaA, dnaT], gCode1) == aaD
    check translateCodon([dnaG, dnaG, dnaA], gCode1) == aaG
    check translateCodon([dnaG, dnaG, dnaG], gCode1) == aaG
    check translateCodon([dnaG, dnaG, dnaC], gCode1) == aaG
    check translateCodon([dnaG, dnaG, dnaT], gCode1) == aaG
    check translateCodon([dnaG, dnaC, dnaA], gCode1) == aaA
    check translateCodon([dnaG, dnaC, dnaG], gCode1) == aaA
    check translateCodon([dnaG, dnaC, dnaC], gCode1) == aaA
    check translateCodon([dnaG, dnaC, dnaT], gCode1) == aaA
    check translateCodon([dnaG, dnaT, dnaA], gCode1) == aaV
    check translateCodon([dnaG, dnaT, dnaG], gCode1) == aaV
    check translateCodon([dnaG, dnaT, dnaC], gCode1) == aaV
    check translateCodon([dnaG, dnaT, dnaT], gCode1) == aaV
    check translateCodon([dnaC, dnaA, dnaA], gCode1) == aaQ
    check translateCodon([dnaC, dnaA, dnaG], gCode1) == aaQ
    check translateCodon([dnaC, dnaA, dnaC], gCode1) == aaH
    check translateCodon([dnaC, dnaA, dnaT], gCode1) == aaH
    check translateCodon([dnaC, dnaG, dnaA], gCode1) == aaR
    check translateCodon([dnaC, dnaG, dnaG], gCode1) == aaR
    check translateCodon([dnaC, dnaG, dnaC], gCode1) == aaR
    check translateCodon([dnaC, dnaG, dnaT], gCode1) == aaR
    check translateCodon([dnaC, dnaC, dnaA], gCode1) == aaP
    check translateCodon([dnaC, dnaC, dnaG], gCode1) == aaP
    check translateCodon([dnaC, dnaC, dnaC], gCode1) == aaP
    check translateCodon([dnaC, dnaC, dnaT], gCode1) == aaP
    check translateCodon([dnaC, dnaT, dnaA], gCode1) == aaL
    check translateCodon([dnaC, dnaT, dnaG], gCode1) == aaL
    check translateCodon([dnaC, dnaT, dnaC], gCode1) == aaL
    check translateCodon([dnaC, dnaT, dnaT], gCode1) == aaL
    check translateCodon([dnaT, dnaA, dnaA], gCode1) == aaStp
    check translateCodon([dnaT, dnaA, dnaG], gCode1) == aaStp
    check translateCodon([dnaT, dnaA, dnaC], gCode1) == aaY
    check translateCodon([dnaT, dnaA, dnaT], gCode1) == aaY
    check translateCodon([dnaT, dnaG, dnaA], gCode1) == aaStp
    check translateCodon([dnaT, dnaG, dnaG], gCode1) == aaW
    check translateCodon([dnaT, dnaG, dnaC], gCode1) == aaC
    check translateCodon([dnaT, dnaG, dnaT], gCode1) == aaC
    check translateCodon([dnaT, dnaC, dnaA], gCode1) == aaS
    check translateCodon([dnaT, dnaC, dnaG], gCode1) == aaS
    check translateCodon([dnaT, dnaC, dnaC], gCode1) == aaS
    check translateCodon([dnaT, dnaC, dnaT], gCode1) == aaS
    check translateCodon([dnaT, dnaT, dnaA], gCode1) == aaL
    check translateCodon([dnaT, dnaT, dnaG], gCode1) == aaL
    check translateCodon([dnaT, dnaT, dnaC], gCode1) == aaF
    check translateCodon([dnaT, dnaT, dnaT], gCode1) == aaF