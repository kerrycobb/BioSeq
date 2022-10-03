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
## Fundamental components of the BioSeq library are the `nucleotide`_ and 
## `aminoAcid`_ modules. These module have `enum` types 
## for representing nucleotides and amino acids in a way that provides convenience
## and type safety. They provide utilities for parsing characters and performing
## actions on and with single nucleotides or amino acids such as getting the 
## complement of a nucleotide, comparing nucleotides, and translating nucleotides
## to amino acids.
##
## Higher level components for dealing with sequences and matrices of nucleotides
## are under development and will be available in the future. 
## 
## The `twoBitSequence`_ module provides a way to 
## store nucleotide sequence data as a pair of bits within a bitSeq which reduces 
## memory and allows for certain sequence comparisons to be done more quickly. 
##
## Quick Tutorial
## ==============
## Show some examples of what can be done here.
## 
## 
## Consult the documentation for each module for a more complete documentation.
## 
## 
## 
## .._nucleotide: bioseq/nucleotide.html
## .._aminoacid: bioseq/aminoAcid.html
## .._twoBitSequence: bioseq/twoBitSequence.html


