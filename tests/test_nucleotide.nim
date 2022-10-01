import bioseq
import strutils

block: # nucleotide 
  block: # Nucleotide 
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
    assert A.isAdenine()
    assert G.isGuanine()
    assert C.isCytosine()
    assert T.isThymine()
    assert parseChar('U', RNA).isUracil()
  
    # Known base
    assert A.knownBase()
    assert G.knownBase()
    assert C.knownBase()
    assert T.knownBase()
    assert not R.knownBase()
    assert not M.knownBase()
    assert not W.knownBase()
    assert not S.knownBase()
    assert not K.knownBase()
    assert not Y.knownBase()
    assert not V.knownBase()
    assert not H.knownBase()
    assert not D.knownBase()
    assert not B.knownBase()
    assert not N.knownBase()
    assert not Gap.knownBase()
    assert not Unk.knownBase()
  
    # Is Purine
    assert A.isPurine()
    assert G.isPurine()
    assert not C.isPurine()
    assert not T.isPurine()
    assert R.isPurine()
    assert not M.isPurine()
    assert not W.isPurine()
    assert not S.isPurine()
    assert not K.isPurine()
    assert not Y.isPurine()
    assert not V.isPurine()
    assert not H.isPurine()
    assert not D.isPurine()
    assert not B.isPurine()
    assert not N.isPurine()
    assert not Gap.isPurine()
    assert not Unk.isPurine()
  
    # Is Pyrimidine
    assert not A.isPyrimidine()
    assert not G.isPyrimidine()
    assert C.isPyrimidine()
    assert T.isPyrimidine()
    assert not R.isPyrimidine()
    assert not M.isPyrimidine()
    assert not W.isPyrimidine()
    assert not S.isPyrimidine()
    assert not K.isPyrimidine()
    assert Y.isPyrimidine()
    assert not V.isPyrimidine()
    assert not H.isPyrimidine()
    assert not D.isPyrimidine()
    assert not B.isPyrimidine()
    assert not N.isPyrimidine()
    assert not Gap.isPyrimidine()
    assert not Unk.isPyrimidine()
  
    # Same base
    assert sameBase(A, A)
    assert not sameBase(A, W)
  
    # Diff base
    assert diffBase(A, T)
    assert diffBase(A, Unk)
    assert diffBase(A, Gap)
    assert not diffBase(A, A)
    assert not diffBase(A, W)
    assert not diffBase(A, N)
  
    # Parse DNA
    assert parseChar('A', DNA).char() == 'A'
    assert parseChar('G', DNA).char() == 'G'
    assert parseChar('C', DNA).char() == 'C'
    assert parseChar('T', DNA).char() == 'T'
    assert parseChar('R', DNA).char() == 'R'
    assert parseChar('M', DNA).char() == 'M'
    assert parseChar('W', DNA).char() == 'W'
    assert parseChar('S', DNA).char() == 'S'
    assert parseChar('K', DNA).char() == 'K'
    assert parseChar('Y', DNA).char() == 'Y'
    assert parseChar('V', DNA).char() == 'V'
    assert parseChar('H', DNA).char() == 'H'
    assert parseChar('D', DNA).char() == 'D'
    assert parseChar('B', DNA).char() == 'B'
    assert parseChar('N', DNA).char() == 'N'
    assert parseChar('-', DNA).char() == '-'
    assert parseChar('?', DNA).char() == '?'
  
    # Parse RNA 
    assert parseChar('A', RNA).char() == 'A'
    assert parseChar('G', RNA).char() == 'G'
    assert parseChar('C', RNA).char() == 'C'
    assert parseChar('U', RNA).char() == 'U'
    assert parseChar('R', RNA).char() == 'R'
    assert parseChar('M', RNA).char() == 'M'
    assert parseChar('W', RNA).char() == 'W'
    assert parseChar('S', RNA).char() == 'S'
    assert parseChar('K', RNA).char() == 'K'
    assert parseChar('Y', RNA).char() == 'Y'
    assert parseChar('V', RNA).char() == 'V'
    assert parseChar('H', RNA).char() == 'H'
    assert parseChar('D', RNA).char() == 'D'
    assert parseChar('B', RNA).char() == 'B'
    assert parseChar('N', RNA).char() == 'N'
    assert parseChar('-', RNA).char() == '-'
    assert parseChar('?', RNA).char() == '?'
  
    # DNA complement
    assert parseChar('A', DNA).complement.char == 'T'
    assert parseChar('G', DNA).complement.char == 'C'
    assert parseChar('C', DNA).complement.char == 'G'
    assert parseChar('T', DNA).complement.char == 'A'
    assert parseChar('R', DNA).complement.char == 'Y'
    assert parseChar('M', DNA).complement.char == 'K'
    assert parseChar('W', DNA).complement.char == 'W'
    assert parseChar('S', DNA).complement.char == 'S'
    assert parseChar('K', DNA).complement.char == 'M'
    assert parseChar('Y', DNA).complement.char == 'R'
    assert parseChar('V', DNA).complement.char == 'B'
    assert parseChar('H', DNA).complement.char == 'D'
    assert parseChar('D', DNA).complement.char == 'H'
    assert parseChar('B', DNA).complement.char == 'V'
    assert parseChar('N', DNA).complement.char == 'N'
    assert parseChar('-', DNA).complement.char == '-'
    assert parseChar('?', DNA).complement.char == '?'
  
    # RNA complement
    assert parseChar('A', RNA).complement.char == 'U'
    assert parseChar('G', RNA).complement.char == 'C'
    assert parseChar('C', RNA).complement.char == 'G'
    assert parseChar('U', RNA).complement.char == 'A'
    assert parseChar('R', RNA).complement.char == 'Y'
    assert parseChar('M', RNA).complement.char == 'K'
    assert parseChar('W', RNA).complement.char == 'W'
    assert parseChar('S', RNA).complement.char == 'S'
    assert parseChar('K', RNA).complement.char == 'M'
    assert parseChar('Y', RNA).complement.char == 'R'
    assert parseChar('V', RNA).complement.char == 'B'
    assert parseChar('H', RNA).complement.char == 'D'
    assert parseChar('D', RNA).complement.char == 'H'
    assert parseChar('B', RNA).complement.char == 'V'
    assert parseChar('N', RNA).complement.char == 'N'
    assert parseChar('-', RNA).complement.char == '-'
    assert parseChar('?', RNA).complement.char == '?'
    
    assert toNucleotideSeq[DNA](@['A', 'T', 'G', 'C']) == @[dnaA, dnaT, dnaG, dnaC]
    assert toNucleotideSeq[DNA]("ATGC") == @[dnaA, dnaT, dnaG, dnaC]
  
  
  block: # StrictNucleotide
    let 
      A =    parseChar('A', StrictDNA)
      G =    parseChar('G', StrictDNA)
      C =    parseChar('C', StrictDNA)
      T =    parseChar('T', StrictDNA)
 
    assert A.isAdenine()
    assert G.isGuanine()
    assert C.isCytosine()
    assert T.isThymine()
    assert parseChar('U', StrictRNA).isUracil()
  
    # Known base
    assert A.knownBase()
    assert G.knownBase()
    assert C.knownBase()
    assert T.knownBase()
  
    # # Is Purine
    assert A.isPurine()
    assert G.isPurine()
    assert not C.isPurine()
    assert not T.isPurine()
  
    # Is Pyrimidine
    assert not A.isPyrimidine()
    assert not G.isPyrimidine()
    assert C.isPyrimidine()
    assert T.isPyrimidine()
  
    # Same base
    assert sameBase(A, A)
    assert not sameBase(A, T)
  
    # Diff base
    assert diffBase(A, T)
    assert not diffBase(A, A)
  
    # Parse DNA
    assert parseChar('A', StrictDNA).char() == 'A'
    assert parseChar('G', StrictDNA).char() == 'G'
    assert parseChar('C', StrictDNA).char() == 'C'
    assert parseChar('T', StrictDNA).char() == 'T'
  
    # Parse RNA 
    assert parseChar('A', StrictRNA).char() == 'A'
    assert parseChar('G', StrictRNA).char() == 'G'
    assert parseChar('C', StrictRNA).char() == 'C'
    assert parseChar('U', StrictRNA).char() == 'U'
  
    # DNA complement
    assert parseChar('A', StrictDNA).complement.char == 'T'
    assert parseChar('G', StrictDNA).complement.char == 'C'
    assert parseChar('C', StrictDNA).complement.char == 'G'
    assert parseChar('T', StrictDNA).complement.char == 'A'
  
    # RNA complement
    assert parseChar('A', StrictRNA).complement.char == 'U'
    assert parseChar('G', StrictRNA).complement.char == 'C'
    assert parseChar('C', StrictRNA).complement.char == 'G'
    assert parseChar('U', StrictRNA).complement.char == 'A'
        
    assert toNucleotideSeq[StrictDNA](@['A', 'T', 'G', 'C']) == @[sdnaA, sdnaT, sdnaG, sdnaC]
    assert toNucleotideSeq[StrictDNA]("ATGC") == @[sdnaA, sdnaT, sdnaG, sdnaC]