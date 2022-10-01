## IUPAC 8 bit unsigned integer representation following:
## http://ape-package.ird.fr/misc/BitLevelCodingScheme.html
## 
## ======  ========  =====  =================  ==========
## Symbol  Binary    uint8  Definition         Complement
## ======  ========  =====  =================  ==========
## A       10001000  136    Adenine            T/U
## G       01001000  72     Guanine            C
## C       00101000  40     Cytosine           G
## T/U     00011000  24     Thymine/Uracil     A
## R       11000000  192    A or G             Y
## M       10100000  160    A or C             K
## W       10010000  144    A or T/U           W
## S       01100000  96     G or C             S
## K       01010000  80     G or T/U           M
## Y       00110000  48     C or T/U           R
## V       11100000  224    Not T/U            B
## H       10110000  176    Not G              D
## D       11010000  208    Not C              H
## B       01110000  112    Not A              V
## N       11110000  240    Any base           N
## \-      00000100  4      Alignment gap      \-
## \?	     00000010  2      Unknown character  \?
## ======  ========  =====  =================  ==========

import ./parserMacro

type
  DNA* = enum dnaA, dnaG, dnaC, dnaT, dnaR, dnaM, dnaW, dnaS, dnaK, dnaY, dnaV, dnaH, dnaD, dnaB, dnaN, dnaGap, dnaUnk
  RNA* = enum rnaA, rnaG, rnaC, rnaU, rnaR, rnaM, rnaW, rnaS, rnaK, rnaY, rnaV, rnaH, rnaD, rnaB, rnaN, rnaGap, rnaUnk
  Nucleotide* = DNA | RNA

const
  byteArray = [0b1000_1000'u8, 0b0100_1000, 0b0010_1000, 0b0001_1000, 0b1100_0000, 0b1010_0000, 0b1001_0000, 0b0110_0000, 0b0101_0000, 0b0011_0000, 0b1110_0000, 0b1011_0000, 0b1101_0000, 0b0111_0000, 0b1111_0000, 0b0000_0100, 0b0000_0010]
  dnaByte*: array[DNA, byte] = byteArray 
  rnaByte*: array[RNA, byte] = byteArray 
  dnaChar*: array[DNA, char] = ['A','G','C','T','R','M','W','S','K','Y','V','H', 'D','B','N','-','?']
  rnaChar*: array[RNA, char] = ['A','G','C','U','R','M','W','S','K','Y','V','H', 'D','B','N','-','?']
  dnaComplement*: array[DNA, DNA] = [dnaT, dnaC, dnaG, dnaA, dnaY, dnaK, dnaW, dnaS, dnaM, dnaR, dnaB, dnaD, dnaH, dnaV, dnaN, dnaGap, dnaUnk]
  rnaComplement*: array[RNA, RNA] = [rnaU, rnaC, rnaG, rnaA, rnaY, rnaK, rnaW, rnaS, rnaM, rnaR, rnaB, rnaD, rnaH, rnaV, rnaN, rnaGap, rnaUnk]

func parseChar*(c: char, T: typedesc[DNA]): DNA = 
  ## Parse character to DNA enum type.
  generateParser(c, dnaChar, DNA)

func parseChar*(c: char, T: typedesc[RNA]): RNA = 
  ## Parse character to RNA enum type.
  generateParser(c, rnaChar, RNA)

func byte*(n: DNA): byte = dnaByte[n]
  ## Byte representation of base, alias of uint8.

func byte*(n: RNA): byte = rnaByte[n]
  ## Byte representation of base, alias of uint8.

func char*(n: DNA): char = dnaChar[n]
  ## Character representation of base.

func char*(n: RNA): char = rnaChar[n]
  ## Character representation of base.

func complement*(n: DNA): DNA = dnaComplement[n]
  ## Complimentary base.

func complement*(n: RNA): RNA = rnaComplement[n]
  ## Complimentary base.

# func toDNA*(n: RNA): DNA = DNA(n.ord)
func toDNA*(n: RNA): DNA = cast[DNA](n)
  ## Transcribe from RNA to DNA.

# func toRNA*(n: DNA): RNA = RNA(n.ord)
func toRNA*(n: DNA): RNA = cast[RNA](n)
  ## Transcribe from DNA to RNA.

type
  StrictDNA* = enum sdnaA, sdnaG, sdnaC, sdnaT
  StrictRNA* = enum srnaA, srnaG, srnaC, srnaU
  StrictNucleotide* = StrictDNA | StrictRNA

const
  strictByteArray = [0b1000_1000'u8, 0b0100_1000, 0b0010_1000, 0b0001_1000]
  strictDnaByte*: array[StrictDNA, byte] = strictByteArray 
  strictRnaByte*: array[StrictRNA, byte] = strictByteArray 
  strictDnaChar*: array[StrictDNA, char] = ['A','G','C','T']
  strictRnaChar*: array[StrictRNA, char] = ['A','G','C','U']
  strictDnaComplement*: array[StrictDNA, StrictDNA] = [sdnaT, sdnaC, sdnaG, sdnaA]
  strictRnaComplement*: array[StrictRNA, StrictRNA] = [srnaU, srnaC, srnaG, srnaA]

func parseChar*(c: char, T: typedesc[StrictDNA]): StrictDNA = 
  ## Parse character to DNA enum type.
  generateParser(c, strictDnaChar, StrictDNA)

func parseChar*(c: char, T: typedesc[StrictRNA]): StrictRNA = 
  ## Parse character to RNA enum type.
  generateParser(c, strictRnaChar, StrictRNA)

func byte*(n: StrictDNA): byte = strictDnaByte[n]
  ## Byte representation of base, alias of uint8.

func byte*(n: StrictRNA): byte = strictRnaByte[n]
  ## Byte representation of base, alias of uint8.

func char*(n: StrictDNA): char = strictDnaChar[n]
  ## Character representation of base.

func char*(n: StrictRNA): char = strictRnaChar[n]
  ## Character representation of base.

func complement*(n: StrictDNA): StrictDNA = strictDnaComplement[n]
  ## Complimentary base.

func complement*(n: StrictRNA): StrictRNA = strictRnaComplement[n]
  ## Complimentary base.

# func toDNA*(n: RNA): DNA = DNA(n.ord)
func toDNA*(n: StrictRNA): StrictDNA = cast[StrictDNA](n)
  ## Transcribe from RNA to DNA.

# func toRNA*(n: DNA): RNA = RNA(n.ord)
func toRNA*(n: StrictDNA): StrictRNA = cast[StrictRNA](n)
  ## Transcribe from DNA to RNA.

type
  AnyNucleotide* = StrictNucleotide | Nucleotide 

func `$`*(n: AnyNucleotide): string = $n.char
  ## Convert RNA enum type to string representation.

func knownBase*(n: AnyNucleotide): bool = (n.byte and 0b0000_1000'u8) == 0b0000_1000'u8 
  ## Returns true if base is not ambiguous.
   
func isAdenine*(n: AnyNucleotide): bool = n.byte == 0b1000_1000'u8 
  ## Returns true if base is unambiguously adenine.

func isGuanine*(n: AnyNucleotide): bool = n.byte == 0b0100_1000'u8
  ## Returns true if base is unambiguously guanine.
   
func isCytosine*(n: AnyNucleotide): bool = n.byte == 0b0010_1000'u8 
  ## Returns true if base is unambiguously cytosine.

func isThymine*(n: DNA | StrictDNA): bool = n.byte == 0b0001_1000'u8 
  ## Returns true if base is unambiguously thymine.

func isUracil*(n: RNA | StrictRNA): bool = n.byte == 0b0001_1000'u8 
  ## Returns true if base is unambiguously uracil.

func isPurine*(n: AnyNucleotide): bool = (n.byte and 0b0011_0111'u8) == 0b0000_0000'u8
  ## Returns true if base ia a unambiguosly purine.

func isPyrimidine*(n: AnyNucleotide): bool = (n.byte and 0b1100_0111'u8) == 0b0000_0000'u8
  ## Returns true if base is a unabmbiguously pyramidine.

func sameBase*(a, b: AnyNucleotide): bool = knownBase(a) and (a == b)
  ## Returns true if bases are unambiguously the same.

func diffBase*(a, b: AnyNucleotide): bool = (a.byte and b.byte) < 0b0001_0000'u8 
  ## Returns true if bases are unambiguously different. A base will be treated 
  ## as different if it is unknown '?' but not if it is any 'N' or gap '-'.

func toNucleotideSeq*[T: AnyNucleotide](data: seq[char]): seq[T] =
  ## Parse character seq as Nucleotide seq
  result = newSeq[T](data.len)
  for i, d in data:
    result[i] = parseChar(d, T)

func toNucleotideSeq*[T: AnyNucleotide](data: string): seq[T] = 
  ## Parse string as Nucleotide seq 
  # TODO: Should just be able to cast string to seq[char] and call the above 
  # func but for some reason it wont work here. This approch works outside of
  # this module file. For example in the aminoAcids module.
  # toNucleotideSeq(cast[seq[char]](data))
  result = newSeq[T](data.len)
  for i, d in data:
    result[i] = parseChar(d, T)