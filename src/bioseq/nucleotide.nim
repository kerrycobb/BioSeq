# TODO: could probably come up with better name for this
const iupac_uint8_info = """ 
IUPAC 8 bit unigned integer
http://ape-package.ird.fr/misc/BitLevelCodingScheme.html

Symbol  Binary    uint8  Definition         Complement
A       10001000  136    Adenine            T/U
G       01001000  72     Guanine            C
C       00101000  40     Cytosine           G
T/U     00011000  24     Thymine/Uracil     A
R       11000000  192    A or G             Y
M       10100000  160    A or C             K
W       10010000  144    A or T/U           W
S       01100000  96     G or C             S
K       01010000  80     G or T/U           M
Y       00110000  48     C or T/U           R
V       11100000  224    Not T/U            B
H       10110000  176    Not G              D
D       11010000  208    Not C              H
B       01110000  112    Not A              V
N       11110000  240    Any base           N
-       00000100  4      Alignment gap      -
?	      00000010  2      Unknown character  ?
"""

type
  DNA* = enum dnaA, dnaG, dnaC, dnaT, dnaR, dnaM, dnaW, dnaS, dnaK, dnaY, dnaV, dnaH, dnaD, dnaB, dnaN, dnaGap, dnaUnk
  RNA* = enum rnaA, rnaG, rnaC, rnaU, rnaR, rnaM, rnaW, rnaS, rnaK, rnaY, rnaV, rnaH, rnaD, rnaB, rnaN, rnaGap, rnaUnk

const
  # nucUint8= [136'u8, 72, 40, 24, 192, 160, 144, 96, 80, 48, 224, 176, 208, 112, 240, 4, 2]
  nucByte = [
    0b1000_1000'u8, # = 136
    0b0100_1000,    # = 72 
    0b0010_1000,    # = 40 
    0b0001_1000,    # = 24 
    0b1100_0000,    # = 192 
    0b1010_0000,    # = 160 
    0b1001_0000,    # = 144 
    0b0110_0000,    # = 96 
    0b0101_0000,    # = 80 
    0b0011_0000,    # = 48 
    0b1110_0000,    # = 224 
    0b1011_0000,    # = 176 
    0b1101_0000,    # = 208 
    0b0111_0000,    # = 112 
    0b1111_0000,    # = 240 
    0b0000_0100,    # = 4 
    0b0000_0010]    # = 2 
  dnaByte: array[DNA, byte] = nucByte
  rnaByte: array[RNA, byte] = nucByte
  dnaChar: array[DNA, char] = ['A','G','C','T','R','M','W','S','K','Y','V','H', 'D','B','N','-','?']
  rnaChar: array[RNA, char] = ['A','G','C','T','R','M','W','S','K','Y','V','H', 'D','B','N','-','?']
  dnaComplement: array[DNA, DNA] = [dnaT, dnaC, dnaG, dnaA, dnaY, dnaK, dnaW, dnaS, dnaM, dnaR, dnaB, dnaD, dnaH, dnaV, dnaN, dnaGap, dnaUnk]
  rnaComplement: array[RNA, RNA] = [rnaU, rnaC, rnaG, rnaA, rnaY, rnaK, rnaW, rnaS, rnaM, rnaR, rnaB, rnaD, rnaH, rnaV, rnaN, rnaGap, rnaUnk]

proc byte*(n: DNA): byte = dnaByte[n]
proc byte*(n: RNA): byte = rnaByte[n]

# proc int*(n: DNA): uint8 = n.byte
# proc int*(n: RNA): uint8 = n.byte

proc char*(n: DNA): char = dnaChar[n]
proc char*(n: RNA): char = rnaChar[n]

proc complement*(n: DNA): DNA = dnaComplement[n]
proc complement*(n: RNA): RNA = rnaComplement[n]

proc toDNA*(n: RNA): DNA = DNA(n.ord)
proc toRNA*(n: DNA): RNA = RNA(n.ord)

proc parseChar*(c: char, T: typedesc[DNA]): DNA = 
  case c
  of 'A': result = dnaA
  of 'G': result = dnaG
  of 'C': result = dnaC
  of 'T': result = dnaT
  of 'R': result = dnaR
  of 'M': result = dnaM
  of 'W': result = dnaW
  of 'S': result = dnaS
  of 'K': result = dnaK
  of 'Y': result = dnaY
  of 'V': result = dnaV
  of 'H': result = dnaH
  of 'D': result = dnaD
  of 'B': result = dnaB
  of 'N': result = dnaN
  of '-': result = dnaGap
  of '?': result = dnaUnk
  else: discard

proc parseChar*(c: char, T: typedesc[RNA]): RNA = 
  case c
  of 'A': result = rnaA
  of 'G': result = rnaG
  of 'C': result = rnaC
  of 'U': result = rnaU
  of 'R': result = rnaR
  of 'M': result = rnaM
  of 'W': result = rnaW
  of 'S': result = rnaS
  of 'K': result = rnaK
  of 'Y': result = rnaY
  of 'V': result = rnaV
  of 'H': result = rnaH
  of 'D': result = rnaD
  of 'B': result = rnaB
  of 'N': result = rnaN
  of '-': result = rnaGap
  of '?': result = rnaUnk
  else: discard

proc `$`*(dna: DNA): string = $dna.char
proc `$`*(rna: RNA): string = $rna.char

## TODO: would be better to somehow constrain this to DNA or RNA, 
## currently not the safest approach to avoid duplication
proc knownBase*(n: enum): bool = (n.byte and 8) == 8 
  ## Returns true if base is not ambiguous

# proc isAdenine*(n: enum): bool = n.byte == 136
#   ## Returns true if base is unambiguously adenine

# proc isGuanine*(n: enum): bool = n.byte == 72 
#   ## Returns true if base is unambiguously guanine 
 
# proc isCytosine*(n: enum): bool = n.byte == 40
#   ## Returns true if base is unambiguously cytosine 

# proc isThymine*(n: enum): bool = n.byte == 24
#   ## Returns true if base is unambiguously thymine 

proc isPurine*(n: enum): bool = (n.byte and 55) == 0
  ## Returns true if base ia a purine

proc isPyramidine*(n: enum): bool = (n.byte and 199) == 0
  ## Returns true if base is a pyramidine

proc sameBase*(a, b: enum): bool = knownBase(a) and (a == b)
  ## Returns true if bases are different 

proc diffBase*(a, b: enum): bool = (a.byte and b.byte) < 16 
  ## Returns true if bases are the same 