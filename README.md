# bio\_seq
A library for encoding nucletodes into IUPAC ambiguity codes and writing and reading FASTA files.

8 bit unsigned integer representation of nucleotides based on http://ape-package.ird.fr/misc/BitLevelCodingScheme.html


## Alignment parsing
For parsing alignments it is required that all FASTA entries have the same length, if not an error is thrown. 

### Parse an alignment string 
```Nim
import bio_seq
let s = ">header1\nACTG\n>header2\n>CTUG"
let r = parseFastaAlignmentString(s)
```

### Parse an alignment file
```Nim
import bio_seq
let f = parseFastaAlignmentFile("file.fasta")
```


### Write an alignment string 
```Nim
import bio_seq
let s = ">header1\nACTG\n>header2\n>CTUG"
let r: string = writeFastaAlignmentString(s)
```

### Write an alignment file
```Nim
import bio_seq
let s = ">header1\nACTG\n>header2\n>CTUG"
let r = parseFastaAlignmentString(s)
writeFastaAlignmentStringToFile("file.fasta", r)
```

## FASTA parsing

### Parse a FASTA string 
```Nim
import bio_seq
let s = ">header1\nACTG\n>header2\n>CTUTG"
let r = parseFastaString(s)
```

### Parse a FASTA file
```Nim
import bio_seq
let f = parseFastaFile("file.fasta")
```

## FASTQ parsing

### Parse a FASTQ file
```Nim
import bio_seq
let f = parseFastQFile("file.fastq")
```


## Nucleotide conversion

### Convert a character to a nucleotide
```Nim
import bio_seq
let nuc = 'A'.toNucleotide

```
It is also possible to create a nucleotide with the type contrstuctor, but this is discouraged because it is not checked whether the character represents a valid nucleotide or not.


### Convert a nucleotide to a character
```Nim
import bio_seq
let nuc = 'A'.toNucleotide
let c = nuc.toChar
```

### Convert nucleotide to string
```Nim
import bio_seq
let nuc = 'A'.toNucleotide
let nuc_str = $nuc
```

### Convert string to nucleotide
```Nim
import bio_seq
let nuc = "ACTG".toNucleotide
```

### Convert sequence of nucleotides to string
```Nim
import bio_seq
let nuc = "ACTG".toNucleotide
let nuc_str = $nuc
```

### Complemetary based
```Nim
import bio_seq
let nuc = 'A'.toNucleotide
let com = nuc.complement
```
