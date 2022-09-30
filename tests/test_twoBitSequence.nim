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
    doAssert d.bitArray[0] == false
    doAssert d.bitArray[1] == false
    doAssert d[0] == sdnaA
    doAssert d.bitArray[2] == true 
    doAssert d.bitArray[3] == false
    doAssert d[1] == sdnaG
    doAssert d.bitArray[4] == false
    doAssert d.bitArray[5] == true 
    doAssert d[2] == sdnaC
    doAssert d.bitArray[6] == true 
    doAssert d.bitArray[7] == true 
    doAssert d[3] == sdnaT
  
  block: # String operator
    doAssert $d == "AGCT"
  
  block: # Convert from DNA to RNA
    doAssert r.bitArray[0] == false
    doAssert r.bitArray[1] == false
    doAssert r[0] == srnaA
    doAssert r.bitArray[2] == true 
    doAssert r.bitArray[3] == false
    doAssert r[1] == srnaG
    doAssert r.bitArray[4] == false
    doAssert r.bitArray[5] == true 
    doAssert r[2] == srnaC
    doAssert r.bitArray[6] == true 
    doAssert r.bitArray[7] == true 
    doAssert r[3] == srnaU
  
  block: # Convert from RNA to DNA
    doAssert d2.bitArray[0] == false
    doAssert d2.bitArray[1] == false
    doAssert d2[0] == sdnaA
    doAssert d2.bitArray[2] == true 
    doAssert d2.bitArray[3] == false
    doAssert d2[1] == sdnaG
    doAssert d2.bitArray[4] == false
    doAssert d2.bitArray[5] == true 
    doAssert d2[2] == sdnaC
    doAssert d2.bitArray[6] == true 
    doAssert d2.bitArray[7] == true 
    doAssert d2[3] == sdnaT