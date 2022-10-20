import 
  ./bioseq/[nucleotide,
            aminoAcid,
            twoBitSequence,
            sequence,
            matrix,
            phylip]

export 
  nucleotide, 
  aminoAcid, 
  twoBitSequence,
  sequence,
  matrix,
  phylip

## #######
## BioSeq
## #######
## 
## BioSeq is a Nim library for working with biological sequence data such as DNA, 
## RNA, and amino acids. 
## 
## BioSeq Modules
## ==============
## `nucleotide<./bioseq/nucleotide.html>`_
##    For working with nucleotides such as: 
##      - Safe parsing
##      - Getting nucleotide complement
##      - Fast ambiguous nucleic acid comparison 
## 
## `aminoAcid<./bioseq/aminoAcid.html>`_
##    For working with amino acids such as: 
##      - Safe parsing 
##      - Translating from amino acid sequence 
## 
## `sequence<./bioseq/sequence.html>`_
##    For working with sequences of nucleotides:
##      - Complement nucleotide sequence
##      - Reverse complement nucleotide sequence
##      - Translate nucleotide sequence
## 
## `matrix<./bioseq/matrix.html>`_
##    For working with a sequence alignment matrix. Not much is implemented yet.
## 
## `phylip<./bioseq/phylip.html>`_
##    For parsing and writing sequence alignments in Phylip format.
##  
## `twoBitSequence <./bioseq/twoBitSequence>`_
##    Storage of nucleotides sequence as a pair of bits within a 
##    bit sequence which reduces memory and allows for faster performance with 
##    certain sequence comparisons. 

