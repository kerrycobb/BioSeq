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
    check translate([dnaR, dnaW, dnaN], gCode1) == aaX
    check translate([dnaA, dnaA, dnaG], gCode1) == aaK
    check translate([dnaA, dnaA, dnaC], gCode1) == aaN
    check translate([dnaA, dnaA, dnaT], gCode1) == aaN
    check translate([dnaA, dnaG, dnaA], gCode1) == aaR
    check translate([dnaA, dnaG, dnaG], gCode1) == aaR
    check translate([dnaA, dnaG, dnaC], gCode1) == aaS
    check translate([dnaA, dnaG, dnaT], gCode1) == aaS
    check translate([dnaA, dnaC, dnaA], gCode1) == aaT
    check translate([dnaA, dnaC, dnaG], gCode1) == aaT
    check translate([dnaA, dnaC, dnaC], gCode1) == aaT
    check translate([dnaA, dnaC, dnaT], gCode1) == aaT
    check translate([dnaA, dnaT, dnaA], gCode1) == aaI
    check translate([dnaA, dnaT, dnaG], gCode1) == aaM
    check translate([dnaA, dnaT, dnaC], gCode1) == aaI
    check translate([dnaA, dnaT, dnaT], gCode1) == aaI
    check translate([dnaG, dnaA, dnaA], gCode1) == aaE
    check translate([dnaG, dnaA, dnaG], gCode1) == aaE
    check translate([dnaG, dnaA, dnaC], gCode1) == aaD
    check translate([dnaG, dnaA, dnaT], gCode1) == aaD
    check translate([dnaG, dnaG, dnaA], gCode1) == aaG
    check translate([dnaG, dnaG, dnaG], gCode1) == aaG
    check translate([dnaG, dnaG, dnaC], gCode1) == aaG
    check translate([dnaG, dnaG, dnaT], gCode1) == aaG
    check translate([dnaG, dnaC, dnaA], gCode1) == aaA
    check translate([dnaG, dnaC, dnaG], gCode1) == aaA
    check translate([dnaG, dnaC, dnaC], gCode1) == aaA
    check translate([dnaG, dnaC, dnaT], gCode1) == aaA
    check translate([dnaG, dnaT, dnaA], gCode1) == aaV
    check translate([dnaG, dnaT, dnaG], gCode1) == aaV
    check translate([dnaG, dnaT, dnaC], gCode1) == aaV
    check translate([dnaG, dnaT, dnaT], gCode1) == aaV
    check translate([dnaC, dnaA, dnaA], gCode1) == aaQ
    check translate([dnaC, dnaA, dnaG], gCode1) == aaQ
    check translate([dnaC, dnaA, dnaC], gCode1) == aaH
    check translate([dnaC, dnaA, dnaT], gCode1) == aaH
    check translate([dnaC, dnaG, dnaA], gCode1) == aaR
    check translate([dnaC, dnaG, dnaG], gCode1) == aaR
    check translate([dnaC, dnaG, dnaC], gCode1) == aaR
    check translate([dnaC, dnaG, dnaT], gCode1) == aaR
    check translate([dnaC, dnaC, dnaA], gCode1) == aaP
    check translate([dnaC, dnaC, dnaG], gCode1) == aaP
    check translate([dnaC, dnaC, dnaC], gCode1) == aaP
    check translate([dnaC, dnaC, dnaT], gCode1) == aaP
    check translate([dnaC, dnaT, dnaA], gCode1) == aaL
    check translate([dnaC, dnaT, dnaG], gCode1) == aaL
    check translate([dnaC, dnaT, dnaC], gCode1) == aaL
    check translate([dnaC, dnaT, dnaT], gCode1) == aaL
    check translate([dnaT, dnaA, dnaA], gCode1) == aaStp
    check translate([dnaT, dnaA, dnaG], gCode1) == aaStp
    check translate([dnaT, dnaA, dnaC], gCode1) == aaY
    check translate([dnaT, dnaA, dnaT], gCode1) == aaY
    check translate([dnaT, dnaG, dnaA], gCode1) == aaStp
    check translate([dnaT, dnaG, dnaG], gCode1) == aaW
    check translate([dnaT, dnaG, dnaC], gCode1) == aaC
    check translate([dnaT, dnaG, dnaT], gCode1) == aaC
    check translate([dnaT, dnaC, dnaA], gCode1) == aaS
    check translate([dnaT, dnaC, dnaG], gCode1) == aaS
    check translate([dnaT, dnaC, dnaC], gCode1) == aaS
    check translate([dnaT, dnaC, dnaT], gCode1) == aaS
    check translate([dnaT, dnaT, dnaA], gCode1) == aaL
    check translate([dnaT, dnaT, dnaG], gCode1) == aaL
    check translate([dnaT, dnaT, dnaC], gCode1) == aaF
    check translate([dnaT, dnaT, dnaT], gCode1) == aaF