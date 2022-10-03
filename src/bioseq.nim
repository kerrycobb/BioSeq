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
## BioSeq is a library for working with biological sequence data such as DNA, 
## RNA, and amino acids. 
## 
## The BioSeq library has several modules:
## `nucleotide <bioseq/nucleotide.html>`_
##    Provides functions for working with nucleotides such as: 
##      - Safe parsing
##      - Getting nucleotide complement
##      - Optimized nucleic acid comparison 
#    Nucleotides are represented by enum types which provides convenience and type safety.
## 
## `aminoAcid <bioseq/aminoAcid.html>`_
##    Provides functions for working with amino acids such as: 
##      - Safe parsing 
##      - Translating from amino acid sequence 
#    Amino acids are represented by enum types which provides convenience and type safety.
## 
## `twoBitSequence <bioseq/twoBitSequence>`_
##    Provides storage of nucleotides sequence as a pair of bits within a 
##    bit sequence which reduces memory and allows for faster performance of
##    certain sequence comparisons. 

