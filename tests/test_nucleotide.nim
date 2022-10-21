import ../src/bioseq
import std/unittest 

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
    check parseChar('A', DNA).toChar() == 'A'
    check parseChar('G', DNA).toChar() == 'G'
    check parseChar('C', DNA).toChar() == 'C'
    check parseChar('T', DNA).toChar() == 'T'
    check parseChar('R', DNA).toChar() == 'R'
    check parseChar('M', DNA).toChar() == 'M'
    check parseChar('W', DNA).toChar() == 'W'
    check parseChar('S', DNA).toChar() == 'S'
    check parseChar('K', DNA).toChar() == 'K'
    check parseChar('Y', DNA).toChar() == 'Y'
    check parseChar('V', DNA).toChar() == 'V'
    check parseChar('H', DNA).toChar() == 'H'
    check parseChar('D', DNA).toChar() == 'D'
    check parseChar('B', DNA).toChar() == 'B'
    check parseChar('N', DNA).toChar() == 'N'
    check parseChar('-', DNA).toChar() == '-'
    check parseChar('?', DNA).toChar() == '?'
  
  test "parseRNA":
    check parseChar('A', RNA).toChar() == 'A'
    check parseChar('G', RNA).toChar() == 'G'
    check parseChar('C', RNA).toChar() == 'C'
    check parseChar('U', RNA).toChar() == 'U'
    check parseChar('R', RNA).toChar() == 'R'
    check parseChar('M', RNA).toChar() == 'M'
    check parseChar('W', RNA).toChar() == 'W'
    check parseChar('S', RNA).toChar() == 'S'
    check parseChar('K', RNA).toChar() == 'K'
    check parseChar('Y', RNA).toChar() == 'Y'
    check parseChar('V', RNA).toChar() == 'V'
    check parseChar('H', RNA).toChar() == 'H'
    check parseChar('D', RNA).toChar() == 'D'
    check parseChar('B', RNA).toChar() == 'B'
    check parseChar('N', RNA).toChar() == 'N'
    check parseChar('-', RNA).toChar() == '-'
    check parseChar('?', RNA).toChar() == '?'

  test "dnaComplement": 
    check parseChar('A', DNA).complement.toChar == 'T'
    check parseChar('G', DNA).complement.toChar == 'C'
    check parseChar('C', DNA).complement.toChar == 'G'
    check parseChar('T', DNA).complement.toChar == 'A'
    check parseChar('R', DNA).complement.toChar == 'Y'
    check parseChar('M', DNA).complement.toChar == 'K'
    check parseChar('W', DNA).complement.toChar == 'W'
    check parseChar('S', DNA).complement.toChar == 'S'
    check parseChar('K', DNA).complement.toChar == 'M'
    check parseChar('Y', DNA).complement.toChar == 'R'
    check parseChar('V', DNA).complement.toChar == 'B'
    check parseChar('H', DNA).complement.toChar == 'D'
    check parseChar('D', DNA).complement.toChar == 'H'
    check parseChar('B', DNA).complement.toChar == 'V'
    check parseChar('N', DNA).complement.toChar == 'N'
    check parseChar('-', DNA).complement.toChar == '-'
    check parseChar('?', DNA).complement.toChar == '?'

  test "rnaComplement": 
    check parseChar('A', RNA).complement.toChar == 'U'
    check parseChar('G', RNA).complement.toChar == 'C'
    check parseChar('C', RNA).complement.toChar == 'G'
    check parseChar('U', RNA).complement.toChar == 'A'
    check parseChar('R', RNA).complement.toChar == 'Y'
    check parseChar('M', RNA).complement.toChar == 'K'
    check parseChar('W', RNA).complement.toChar == 'W'
    check parseChar('S', RNA).complement.toChar == 'S'
    check parseChar('K', RNA).complement.toChar == 'M'
    check parseChar('Y', RNA).complement.toChar == 'R'
    check parseChar('V', RNA).complement.toChar == 'B'
    check parseChar('H', RNA).complement.toChar == 'D'
    check parseChar('D', RNA).complement.toChar == 'H'
    check parseChar('B', RNA).complement.toChar == 'V'
    check parseChar('N', RNA).complement.toChar == 'N'
    check parseChar('-', RNA).complement.toChar == '-'
    check parseChar('?', RNA).complement.toChar == '?'

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
    check parseChar('A', StrictDNA).toChar() == 'A'
    check parseChar('G', StrictDNA).toChar() == 'G'
    check parseChar('C', StrictDNA).toChar() == 'C'
    check parseChar('T', StrictDNA).toChar() == 'T'
  
  test "parseRNA":
    check parseChar('A', StrictRNA).toChar() == 'A'
    check parseChar('G', StrictRNA).toChar() == 'G'
    check parseChar('C', StrictRNA).toChar() == 'C'
    check parseChar('U', StrictRNA).toChar() == 'U'
  
  test "DNA complement":
    check parseChar('A', StrictDNA).complement.toChar == 'T'
    check parseChar('G', StrictDNA).complement.toChar == 'C'
    check parseChar('C', StrictDNA).complement.toChar == 'G'
    check parseChar('T', StrictDNA).complement.toChar == 'A'
  
  test "RNA complement":
    check parseChar('A', StrictRNA).complement.toChar == 'U'
    check parseChar('G', StrictRNA).complement.toChar == 'C'
    check parseChar('C', StrictRNA).complement.toChar == 'G'
    check parseChar('U', StrictRNA).complement.toChar == 'A'