import ../src/bioseq 
import std/unittest

suite "twoBitSequence":
  var 
    d = newTwoBitSequence[StrictDNA](4)
  
  test "Setters & Getters":
    d[0] = sdnaA
    d[1] = sdnaG
    d[2] = sdnaC
    d[3] = sdnaT
    check d.bitSeq[0] == false
    check d.bitSeq[1] == false
    check d[0] == sdnaA
    check d.bitSeq[2] == true 
    check d.bitSeq[3] == false
    check d[1] == sdnaG
    check d.bitSeq[4] == false
    check d.bitSeq[5] == true 
    check d[2] == sdnaC
    check d.bitSeq[6] == true 
    check d.bitSeq[7] == true 
    check d[3] == sdnaT
  
  test "$ operator":
    check $d == "AGCT"
  
  var r = d.toRNA()
  test "toRNA":
    check r.bitSeq[0] == false
    check r.bitSeq[1] == false
    check r[0] == srnaA
    check r.bitSeq[2] == true 
    check r.bitSeq[3] == false
    check r[1] == srnaG
    check r.bitSeq[4] == false
    check r.bitSeq[5] == true 
    check r[2] == srnaC
    check r.bitSeq[6] == true 
    check r.bitSeq[7] == true 
    check r[3] == srnaU
  
  var d2 = r.toDNA()
  test "toDNA":
    check d2.bitSeq[0] == false
    check d2.bitSeq[1] == false
    check d2[0] == sdnaA
    check d2.bitSeq[2] == true 
    check d2.bitSeq[3] == false
    check d2[1] == sdnaG
    check d2.bitSeq[4] == false
    check d2.bitSeq[5] == true 
    check d2[2] == sdnaC
    check d2.bitSeq[6] == true 
    check d2.bitSeq[7] == true 
    check d2[3] == sdnaT