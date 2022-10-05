import bioseq 

block: # twoBitSequence
  var 
    d = newTwoBitSequence[StrictDNA](4)
    r = d.toRNA()
    d2 = r.toDNA()
  
  block: # Check Setters and Getters
    d[0] = sdnaA
    d[1] = sdnaG
    d[2] = sdnaC
    d[3] = sdnaT
    doAssert d.bitSeq[0] == false
    doAssert d.bitSeq[1] == false
    doAssert d[0] == sdnaA
    doAssert d.bitSeq[2] == true 
    doAssert d.bitSeq[3] == false
    doAssert d[1] == sdnaG
    doAssert d.bitSeq[4] == false
    doAssert d.bitSeq[5] == true 
    doAssert d[2] == sdnaC
    doAssert d.bitSeq[6] == true 
    doAssert d.bitSeq[7] == true 
    doAssert d[3] == sdnaT
  
  block: # String operator
    doAssert $d == "AGCT"
  
  block: # Convert from DNA to RNA
    doAssert r.bitSeq[0] == false
    doAssert r.bitSeq[1] == false
    doAssert r[0] == srnaA
    doAssert r.bitSeq[2] == true 
    doAssert r.bitSeq[3] == false
    doAssert r[1] == srnaG
    doAssert r.bitSeq[4] == false
    doAssert r.bitSeq[5] == true 
    doAssert r[2] == srnaC
    doAssert r.bitSeq[6] == true 
    doAssert r.bitSeq[7] == true 
    doAssert r[3] == srnaU
  
  block: # Convert from RNA to DNA
    doAssert d2.bitSeq[0] == false
    doAssert d2.bitSeq[1] == false
    doAssert d2[0] == sdnaA
    doAssert d2.bitSeq[2] == true 
    doAssert d2.bitSeq[3] == false
    doAssert d2[1] == sdnaG
    doAssert d2.bitSeq[4] == false
    doAssert d2.bitSeq[5] == true 
    doAssert d2[2] == sdnaC
    doAssert d2.bitSeq[6] == true 
    doAssert d2.bitSeq[7] == true 
    doAssert d2[3] == sdnaT