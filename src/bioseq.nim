import 
  ./bioseq/[
    alignment,
    aminoAcid,
    biallelic,
    fasta,
    matrix,
    nexus,
    nucleotide,
    phylip,
    seqRecord,
    sequence,
    structure,
    twoBitSequence]

export 
  alignment,
  aminoAcid, 
  biallelic,
  fasta,
  matrix,
  nexus,
  nucleotide, 
  twoBitSequence,
  seqRecord,
  sequence,
  structure,
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
## `seqRecord<./bioseq/seqRecord.html>`_
##    Container for sequence data and associated sample id.
## 
## `alignment<./bioseq/alignment.html>`_ 
##    Container for sequence alignment matrix and associated sample ids.  
## 
## `nucleotide<./bioseq/nucleotide.html>`_
##    Types and procs for working with nucleotides. 
## 
## `aminoAcid<./bioseq/aminoAcid.html>`_
##    Types and procs for working with amino acids.
##
## `fasta<./bioseq/fasta.html>`_
##    Fasta format parsing and writing.
## 
## `phylip<./bioseq/phylip.html>`_
##    Phylip alignment format parsing and writing.
## 
## `sequence<./bioseq/sequence.html>`_
##    For working with sequences of nucleotides.
## 
## `matrix<./bioseq/matrix.html>`_
##    For working with a sequence alignment matrix.
##  
## `twoBitSequence <./bioseq/twoBitSequence.html>`_
##    Storage of nucleotides sequence as a pair of bits within a 
##    bit sequence.
