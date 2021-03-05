# Nim-Seq
A library for encoding nucletodes into IUPAC ambiguity codes and writing and reading FASTA files.

8 bit unsigned integer representation of nucleotides based on http://ape-package.ird.fr/misc/BitLevelCodingScheme.html


## Alignment parsing
For parsing alignments it is required that all FASTA entries have the same length, if not an error is thrown. 

### Parse an alignment string 
```Nim
import nim_seq
let s = ">header1\nACTG\n>header2\n>CTUG"
let r = parseFastaAlignmentString(s)
```

### Parse an alignment file
```Nim
import nim_seq
let f = parseFastaAlignmentFile("file.fasta")
```
Writing FASTA files is not supported for the moment, but will be added in the next few weeks

## Nucleotide conversion

### Convert a character to a nucleotide
```Nim
import nim_seq
let nuc = 'A'.toNucleotide

```
It is also possible to create a nucleotide with the type contrstuctor, but this is discouraged because it is not checked whether the character represents a valid nucleotide or not.


### Convert a nucleotide to a character
```Nim
import nim_seq
let nuc = 'A'.toNucleotide
let c = nuc.toChar
```

### Complemetary based
```Nim
let nuc = 'A'.toNucleotide
let com = nuc.complement
```
