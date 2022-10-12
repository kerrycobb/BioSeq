import ../src/bioseq
import unittest 

suite "Nucleotide":
  let 
    A =    parseChar('A', DNA)
    G =    parseChar('G', DNA)
    C =    parseChar('C', DNA)
    T =    parseChar('T', DNA)
    R =    parseChar('R', DNA)
    M =    parseChar('M', DNA)
    W =    parseChar('W', DNA)
    S =    parseChar('S', DNA)
    K =    parseChar('K', DNA)
    Y =    parseChar('Y', DNA)
    V =    parseChar('V', DNA)
    H =    parseChar('H', DNA)
    D =    parseChar('D', DNA)
    B =    parseChar('B', DNA)
    N =    parseChar('N', DNA)
    Gap =  parseChar('-', DNA)
    Unk =  parseChar('?', DNA)
  
  test "is A G C or T":
    check A.isAdenine()
    check G.isGuanine()
    check C.isCytosine()
    check T.isThymine()
    check parseChar('U', RNA).isUracil()

  test "knownBase":
    check A.knownBase()
    check G.knownBase()
    check C.knownBase()
    check T.knownBase()
    check not R.knownBase()
    check not M.knownBase()
    check not W.knownBase()
    check not S.knownBase()
    check not K.knownBase()
    check not Y.knownBase()
    check not V.knownBase()
    check not H.knownBase()
    check not D.knownBase()
    check not B.knownBase()
    check not N.knownBase()
    check not Gap.knownBase()
    check not Unk.knownBase()
  
  test "isPurine":
    check A.isPurine()
    check G.isPurine()
    check not C.isPurine()
    check not T.isPurine()
    check R.isPurine()
    check not M.isPurine()
    check not W.isPurine()
    check not S.isPurine()
    check not K.isPurine()
    check not Y.isPurine()
    check not V.isPurine()
    check not H.isPurine()
    check not D.isPurine()
    check not B.isPurine()
    check not N.isPurine()
    check not Gap.isPurine()
    check not Unk.isPurine()
  
  test "isPyrimidine":
    check not A.isPyrimidine()
    check not G.isPyrimidine()
    check C.isPyrimidine()
    check T.isPyrimidine()
    check not R.isPyrimidine()
    check not M.isPyrimidine()
    check not W.isPyrimidine()
    check not S.isPyrimidine()
    check not K.isPyrimidine()
    check Y.isPyrimidine()
    check not V.isPyrimidine()
    check not H.isPyrimidine()
    check not D.isPyrimidine()
    check not B.isPyrimidine()
    check not N.isPyrimidine()
    check not Gap.isPyrimidine()
    check not Unk.isPyrimidine()
  
  test "sameBase":
    check sameBase(A, A)
    check not sameBase(A, W)
  
  test "diffBase":
    check diffBase(A, T)
    check diffBase(A, Unk)
    check diffBase(A, Gap)
    check not diffBase(A, A)
    check not diffBase(A, W)
    check not diffBase(A, N)

  test "parseDNA":
    # Parse DNA
    check parseChar('A', DNA).char() == 'A'
    check parseChar('G', DNA).char() == 'G'
    check parseChar('C', DNA).char() == 'C'
    check parseChar('T', DNA).char() == 'T'
    check parseChar('R', DNA).char() == 'R'
    check parseChar('M', DNA).char() == 'M'
    check parseChar('W', DNA).char() == 'W'
    check parseChar('S', DNA).char() == 'S'
    check parseChar('K', DNA).char() == 'K'
    check parseChar('Y', DNA).char() == 'Y'
    check parseChar('V', DNA).char() == 'V'
    check parseChar('H', DNA).char() == 'H'
    check parseChar('D', DNA).char() == 'D'
    check parseChar('B', DNA).char() == 'B'
    check parseChar('N', DNA).char() == 'N'
    check parseChar('-', DNA).char() == '-'
    check parseChar('?', DNA).char() == '?'
  
  test "parseRNA":
    check parseChar('A', RNA).char() == 'A'
    check parseChar('G', RNA).char() == 'G'
    check parseChar('C', RNA).char() == 'C'
    check parseChar('U', RNA).char() == 'U'
    check parseChar('R', RNA).char() == 'R'
    check parseChar('M', RNA).char() == 'M'
    check parseChar('W', RNA).char() == 'W'
    check parseChar('S', RNA).char() == 'S'
    check parseChar('K', RNA).char() == 'K'
    check parseChar('Y', RNA).char() == 'Y'
    check parseChar('V', RNA).char() == 'V'
    check parseChar('H', RNA).char() == 'H'
    check parseChar('D', RNA).char() == 'D'
    check parseChar('B', RNA).char() == 'B'
    check parseChar('N', RNA).char() == 'N'
    check parseChar('-', RNA).char() == '-'
    check parseChar('?', RNA).char() == '?'

  test "dnaComplement": 
    check parseChar('A', DNA).complement.char == 'T'
    check parseChar('G', DNA).complement.char == 'C'
    check parseChar('C', DNA).complement.char == 'G'
    check parseChar('T', DNA).complement.char == 'A'
    check parseChar('R', DNA).complement.char == 'Y'
    check parseChar('M', DNA).complement.char == 'K'
    check parseChar('W', DNA).complement.char == 'W'
    check parseChar('S', DNA).complement.char == 'S'
    check parseChar('K', DNA).complement.char == 'M'
    check parseChar('Y', DNA).complement.char == 'R'
    check parseChar('V', DNA).complement.char == 'B'
    check parseChar('H', DNA).complement.char == 'D'
    check parseChar('D', DNA).complement.char == 'H'
    check parseChar('B', DNA).complement.char == 'V'
    check parseChar('N', DNA).complement.char == 'N'
    check parseChar('-', DNA).complement.char == '-'
    check parseChar('?', DNA).complement.char == '?'

  test "rnaComplement": 
    check parseChar('A', RNA).complement.char == 'U'
    check parseChar('G', RNA).complement.char == 'C'
    check parseChar('C', RNA).complement.char == 'G'
    check parseChar('U', RNA).complement.char == 'A'
    check parseChar('R', RNA).complement.char == 'Y'
    check parseChar('M', RNA).complement.char == 'K'
    check parseChar('W', RNA).complement.char == 'W'
    check parseChar('S', RNA).complement.char == 'S'
    check parseChar('K', RNA).complement.char == 'M'
    check parseChar('Y', RNA).complement.char == 'R'
    check parseChar('V', RNA).complement.char == 'B'
    check parseChar('H', RNA).complement.char == 'D'
    check parseChar('D', RNA).complement.char == 'H'
    check parseChar('B', RNA).complement.char == 'V'
    check parseChar('N', RNA).complement.char == 'N'
    check parseChar('-', RNA).complement.char == '-'
    check parseChar('?', RNA).complement.char == '?'

  test "toNucleotideSeq": 
    check toNucleotideSeq(@['A', 'T', 'G', 'C'], DNA) == @[dnaA, dnaT, dnaG, dnaC]
    check toNucleotideSeq("ATGC", DNA) == @[dnaA, dnaT, dnaG, dnaC]
 
suite "StrictNucleotide":
  let 
    A =    parseChar('A', StrictDNA)
    G =    parseChar('G', StrictDNA)
    C =    parseChar('C', StrictDNA)
    T =    parseChar('T', StrictDNA)
  
  test "is A G C or T":
    check A.isAdenine()
    check G.isGuanine()
    check C.isCytosine()
    check T.isThymine()
    check parseChar('U', StrictRNA).isUracil()
  
  test "knownBase":
    check A.knownBase()
    check G.knownBase()
    check C.knownBase()
    check T.knownBase()
  
  test "isPurine":
    check A.isPurine()
    check G.isPurine()
    check not C.isPurine()
    check not T.isPurine()
  
  test "isPyramidine":
    check not A.isPyrimidine()
    check not G.isPyrimidine()
    check C.isPyrimidine()
    check T.isPyrimidine()
  
  test "sameBase":
    check sameBase(A, A)
    check not sameBase(A, T)
  
  test "diffBase":
    check diffBase(A, T)
    check not diffBase(A, A)
  
  test "parseDNA":
    check parseChar('A', StrictDNA).char() == 'A'
    check parseChar('G', StrictDNA).char() == 'G'
    check parseChar('C', StrictDNA).char() == 'C'
    check parseChar('T', StrictDNA).char() == 'T'
  
  test "parseRNA":
    check parseChar('A', StrictRNA).char() == 'A'
    check parseChar('G', StrictRNA).char() == 'G'
    check parseChar('C', StrictRNA).char() == 'C'
    check parseChar('U', StrictRNA).char() == 'U'
  
  test "DNA complement":
    check parseChar('A', StrictDNA).complement.char == 'T'
    check parseChar('G', StrictDNA).complement.char == 'C'
    check parseChar('C', StrictDNA).complement.char == 'G'
    check parseChar('T', StrictDNA).complement.char == 'A'
  
  test "RNA complement":
    check parseChar('A', StrictRNA).complement.char == 'U'
    check parseChar('G', StrictRNA).complement.char == 'C'
    check parseChar('C', StrictRNA).complement.char == 'G'
    check parseChar('U', StrictRNA).complement.char == 'A'

  test "toNucleotideSeq":    
    check toNucleotideSeq(@['A', 'T', 'G', 'C'], StrictDNA) == @[sdnaA, sdnaT, sdnaG, sdnaC]
    check toNucleotideSeq("ATGC", StrictDNA) == @[sdnaA, sdnaT, sdnaG, sdnaC]