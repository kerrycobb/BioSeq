# BioSeq
BioSeq is a library for working with biological sequence data such as DNA, RNA, and amino acids.

## Installation 
```bash
nimble install bioseq
```


<!-- ## Types
There are five fundamental types. `DNA`, `RNA`, `StrictDNA`, `StrictRNA`, and 
`AminoAcid`. These are `enum` types which simplifies a lot of things and 
provides type safety. These `enum` types are grouped into several aliases for 
convenience. These groups are briefly outlined below and discussed in greater 
detail later.

1. `Nucleotide` alias 
  - Includes the `DNA` type and the `RNA` `enum` types.
  - These types allows ambiguous bases and gaps.
  - Some sequence comparisons can be done very fast with these.

2. `StrictNucleotide` alias
  - Includes the `StrictDNA` and the `StrictRNA` `enum` types.
  - These types do not allow gaps or ambiguous bases. 
  - Can be stored in bit seqs to reduce memory and speed up certain sequence comparisons. 

3. `AnyNucleotide` alias
  - Alias for either `Nucleotide` or `StrictNucleotide`.

3. `AminoAcid`
  - `enum` type representing amino acids.



## Nucleotide
The `Nucleotide` type is an alias for the `DNA` and `RNA` enum types that
represent the IUPAC nucleic acid code. These enums map to characters, 8 bit  
unsigned integers, and complementary nucleotides as seen in the table below. 
The 8 bit unsigned integer representation of the IUPAC code follows:
http://ape-package.ird.fr/misc/BitLevelCodingScheme.html

This encoding allows for very fast sequence comparisons when nucleic acids 
are ambiguous.

| Char   |  Binary    | uint8 | Definition       | Complement|
|--------|------------|-------|------------------|-----------|
| A      |  10001000  | 136   | Adenine          | T/U       |
| G      |  01001000  | 72    | Guanine          | C         |
| C      |  00101000  | 40    | Cytosine         | G         |
| T/U    |  00011000  | 24    | Thymine/Uracil   | A         |
| R      |  11000000  | 192   | A or G           | Y         |
| M      |  10100000  | 160   | A or C           | K         |
| W      |  10010000  | 144   | A or T/U         | W         |
| S      |  01100000  | 96    | G or C           | S         |
| K      |  01010000  | 80    | G or T/U         | M         |
| Y      |  00110000  | 48    | C or T/U         | R         |
| V      |  11100000  | 224   | Not T/U          | B         |
| H      |  10110000  | 176   | Not G            | D         |
| D      |  11010000  | 208   | Not C            | H         |
| B      |  01110000  | 112   | Not A            | V         |
| N      |  11110000  | 240   | Any base         | N         |
| -      |  00000100  | 4     | Alignment gap    | -         |
| ?	     |  00000010  | 2     |Unknown character | ?         |

### Parsing
Characters such as those from a nucleotide string read from a file are 
parsed using `parseChar`. You must specify whether the character should be 
parsed as the `DNA` or `RNA` type. An exception will be raised if an invalid  
character is given.

```
var      
  dna = parseChar('T', DNA)
  rna = parseChar('U', RNA)
```

Nucleotides


###


## Nucleotide




## StrictNucleotide


## AminoAcid


## TwoBitSequence  -->



