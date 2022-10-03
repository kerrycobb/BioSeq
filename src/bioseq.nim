import 
  ./bioseq/[nucleotide,
            aminoAcid,
            twoBitSequence]

export 
  nucleotide, 
  aminoAcid, 
  twoBitSequence

## #######
## BioSeq
## #######
## 
## BioSeq is a Nim library for working with biological sequence data such as DNA, 
## RNA, and amino acids. 
## 
## BioSeq modules:
## `nucleotide <bioseq/nucleotide.html>`_
##    Provides functions for working with nucleotides such as: 
##      - Safe parsing
##      - Getting nucleotide complement
##      - Fast ambiguous nucleic acid comparison 
## 
## `aminoAcid <bioseq/aminoAcid.html>`_
##    Provides functions for working with amino acids such as: 
##      - Safe parsing 
##      - Translating from amino acid sequence 
## 
## `twoBitSequence <bioseq/twoBitSequence>`_
##    Provides storage of nucleotides sequence as a pair of bits within a 
##    bit sequence which reduces memory and allows for faster performance with 
##    certain sequence comparisons. 

