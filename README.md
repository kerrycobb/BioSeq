# BioSeq
A library for encoding IUPAC nucleic acid notation as 8 bit unsigned integers 
for efficient memory utilization and fast operations. Allows parsing and writing 
of FASTA, FASTQ, SAM, and Phylip formats.  

8 bit unsigned integer representation of nucleotides based on http://ape-package.ird.fr/misc/BitLevelCodingScheme.html


## Installation
```bash
nimble install bioseq
```
## Nucleotide conversion
### Convert a character to a nucleotide
```Nim
import bioseq
let nuc = 'A'.toNucleotide

```
It is also possible to create a nucleotide with the type constructor, but this 
is discouraged because it is not checked whether the character represents a valid nucleotide or not.


### Convert a nucleotide to a character
```Nim
import bioseq
let nuc = 'A'.toNucleotide
let c = nuc.toChar
```

### Complemetary based
```Nim
let nuc = 'A'.toNucleotide
let com = nuc.complement
```


## Alignment parsing

### Parse FASTA alignment string 
```Nim
import bioseq
let s = """
>header1
ACTG
>header2
>TCTG"
"""
let r = parseFastaAlignmentString(s)
```

### Parse FASTA alignment file
```Nim
import bioseq
let f = parseFastaAlignmentFile("file.fasta")
```

<!-- TODO: These don't really seem useful -->
<!-- ### Write alignment string to file 
```Nim
import bioseq
let s = ">header1\nACTG\n>header2\n>CTUG"
let r = writeFastaAlignmentString(s)
```

### Write an alignment file
```Nim
import bioseq
let f = writeFastaAlignmentStringToFile("file.fasta")
```
 -->
## FASTA parsing

### Parse a FASTA sequence list 
```Nim
import bioseq
let s = ">header1\nACTG\n>header2\n>CTUTG"
let r = parseFastaString(s)
```

### Parse a FASTA file
```Nim
import bioseq
let f = parseFastaFile("file.fasta")
```

## FASTQ parsing

### Parse a FASTQ file
```Nim
import bioseq
let f = parseFastQFile("file.fastq")
```

