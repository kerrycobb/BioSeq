# TODO: Figure out how to distinguish between DNA and RNA

import sequtils 
import strutils
import algorithm

# IUPAC 8 bit
# http://ape-package.ird.fr/misc/BitLevelCodingScheme.html 

##  Symbol  Binary    uint8  Definition         Complement  
##  A       10001000  136    Adenine            T/U         
##  G       01001000  72     Guanine            C           
##  C       00101000  40     Cytosine           G           
##  T/U     00011000  24     Thymine/Uracil     A           
##  R       11000000  192    A or G             Y           
##  M       10100000  160    A or C             K           
##  W       10010000  144    A or T/U           W           
##  S       01100000  96     G or C             S           
##  K       01010000  80     G or T/U           M           
##  Y       00110000  48     C or T/U           R           
##  V       11100000  224    Not T/U            B           
##  H       10110000  176    Not G              D           
##  D       11010000  208    Not C              H           
##  B       01110000  112    Not A              V           
##  N       11110000  240    Any base           N           
##  -       00000100  4      Alignment gap      -           
##  ?	      00000010  2      Unknown character  ?           

type
  Nucleotide* = distinct uint8

  Sequence* = ref object
    id*: string
    data*: seq[Nucleotide]

  Alignment* = ref object
    ## Object which represents a fasta file which the added constraint that all nucleotide lines must be of the same length
    ntax*: int
    ## Number of sequences
    nchar*: int
    seqs*: seq[Sequence]
  
  Fasta* = ref object
    ## Object which represents a fasta file without any constrains
    ntax*: int
    ## Number of sequences
    nchar*: int
    seqs*: seq[Sequence]

  NucleotideError* = object of CatchableError
  AlignmentError* = object of CatchableError
  FastaError* = object of CatchableError

# TODO: Make slice operators for alignment and sequence objects
proc `and`*(a, b: Nucleotide): uint8 {.borrow.} 
proc `and`*(a: Nucleotide, b: uint8): uint8 {.borrow.} 
proc `and`*(a: uint8, b: Nucleotide): uint8 {.borrow.} 

proc `or`*(a, b: Nucleotide): uint8 {.borrow.} 
proc `or`*(a: Nucleotide, b: uint8): uint8 {.borrow.} 
proc `or`*(a: uint8, b: Nucleotide): uint8 {.borrow.} 

proc `xor`*(a, b: Nucleotide): uint8 {.borrow.} 
proc `xor`*(a: Nucleotide, b: uint8): uint8 {.borrow.} 
proc `xor`*(a: uint8, b: Nucleotide): uint8 {.borrow.} 

proc `==`*(a: Nucleotide, b: uint8): bool {.borrow.} 
proc `==`*(b: uint8, a: Nucleotide): bool {.borrow.} 
proc `==`*(a, b: Nucleotide): bool {.borrow.}


proc len*(s: Sequence): int = s.data.len 


# TODO: Could use these with macros to generate case statements and reduce code
# const
#   iupacDNAChars = ['A','G','C','T','R','M','W','S','K','Y','V','H', 
#       'D','B','N','-','?']

#   iupacRNAChars = ['A','G','C','U','R','M','W','S','K','Y','V','H', 
#       'D','B','N','-','?']

#   iupacBinary = [0b10001000, 0b01001000, 0b00101000, 0b00011000, 0b11000000, 
#       0b10100000, 0b10010000, 0b01100000, 0b01010000, 0b00110000, 0b11100000, 
#       0b10110000, 0b11010000, 0b01110000, 0b11110000, 0b00000100, 0b00000010]

#   iupacBinaryComplement = [0b00011000, 0b00101000, 0b01001000, 0b10001000, 
#       0b00110000, 0b01010000, 0b10010000, 0b01100000, 0b10100000, 0b11000000, 
#       0b01110000, 0b11010000, 0b10110000, 0b11100000, 0b11110000, 0b00000100, 
#       0b00000010]

#   iupacCharDeinitions = [ "Adenine", "Guanine", "Cytosine", "Thymine/Uracil", 
#       "A or G", "A or C", "A or T/U", "G or C", "G or T/U", "C or T/U", 
#       "Not T/U", "Not G", "Not C", "Not A", "Any base", "Alignment gap", 
#       "Unknown character"]

proc toNucleotide*(c: char): Nucleotide = 
  # Convert nucleotide character to uint8 representation 
  var i: int
  case c:
  of 'A':
    i = 136
  of 'T': 
    i = 24 
  of 'G':
    i = 72
  of 'C':
    i = 40
  of 'R':
    i = 192
  of 'Y':
    i = 48
  of 'S':
    i = 96
  of 'W':
    i = 144
  of 'K':
    i = 80
  of 'M':
    i = 160
  of 'B': 
    i = 112
  of 'D': 
    i = 208
  of 'H': 
    i = 176
  of 'V': 
    i = 224
  of 'N':
    i = 240
  of '-': 
    i = 4
  of '?':
    i = 2
  else:
    raise newException(NucleotideError, "Invalid character: " & c) 
  result = Nucleotide(i)

proc toChar*(n: Nucleotide): char = 
  ## Convert uint8 representation to nucleotide character   
  case cast[uint8](n):
  of 136:
    result = 'A'
  of 24:
    result = 'T' 
  of 72:
    result = 'G'
  of 40:
    result = 'C' 
  of 192:
    result = 'R'
  of 48:
    result = 'Y'
  of 96:
    result = 'S'
  of 144:
    result = 'W'
  of 80:
    result = 'K'
  of 160:
    result = 'M'
  of 112:
    result = 'B'
  of 208:
    result = 'D'
  of 176:
    result = 'H' 
  of 224:
    result = 'V'
  of 240:
    result = 'N'
  of 4:
    result = '-'
  of 2:
    result = '?'
  else:
    raise newException(NucleotideError, "Invalid nucleotide: " & $cast[uint8](n)) 

proc complement*(n: Nucleotide): Nucleotide =
  ## Return complementary base   
  var i: uint8 
  case cast[uint8](n):
  of 136: # A > T/U
    i = 24 
  of 24: # T/U > A
    i = 136 
  of 72: # G > C 
    i =40 
  of 40: # C > G
    i = 72 
  of 192: # R > Y
    i = 48 
  of 48: # Y > R
    i = 192 
  of 96: # S > S
    i = 96 
  of 144: # W > W
    i = 144 
  of 80: # K > M
    i = 160 
  of 160: # M > K
    i = 80 
  of 112: # B > V
    i = 224 
  of 208: # D > H
    i = 176 
  of 176: # H > D
    i = 208 
  of 224: # B > B 
    i = 112 
  of 240:
    i = 240 
  of 4:
    i = 4 
  of 2:
    i = 2 
  else:
    raise newException(NucleotideError, "Invalid nucleotide: " & $cast[uint8](n)) 
  result = Nucleotide(i)

proc `$`*(a: Nucleotide): string =
  result = $a.toChar

proc `$`*(s: Sequence): string = 
  var seqStr = ""
  for i in s.data:
    seqStr.add(i.toChar())
  result = "id: " & s.id & ", data: " & seqStr


proc `$`*(a: Alignment): string =
  result = "ntax: " & $a.ntax & ", nchar: " & $a.nchar & "\n"
  for i in a.seqs:
    result.add($i & "\n")

proc `$`*(a: Fasta): string =
  result = "ntax: " & $a.ntax & ", nchar: " & $a.nchar & "\n"
  for i in a.seqs:
    result.add($i & "\n")

proc sequence*(a: Sequence): string =
  for i in a.data:
    result.add(i.toChar)

proc sequences*(a: Fasta): string =
  for i in a.seqs:
    result.add(i.sequence)

proc knownBase*(n: Nucleotide): bool = (n and 8) == 8 
  ## Returns true if base is not ambiguous

proc isAdenine*(n: Nucleotide): bool = n == 136
  ## Returns true if base is unambiguously adenine

proc isGuanine*(n: Nucleotide): bool = n == 72 
  ## Returns true if base is unambiguously guanine 
 
proc isCytosine*(n: Nucleotide): bool = n == 40
  ## Returns true if base is unambiguously cytosine 

proc isThymine*(n: Nucleotide): bool = n == 24
  ## Returns true if base is unambiguously thymine 

proc isPurine*(n: Nucleotide): bool = (n and 55) == 0
  ## Returns true if base ia a purine

proc isPyramidine*(n: Nucleotide): bool = (n and 199) == 0
  ## Returns true if base is a pyramidine

proc sameBase*(a, b: Nucleotide): bool = knownBase(a) and (a == b)
  ## Returns true if bases are different 

proc diffBase*(a, b: Nucleotide): bool = (a and b) < 16 
  ## Returns true if bases are the same 

proc newSequence*(id, data: string): Sequence =
  ## Create new sequence object
  result = Sequence(id:id) 
  for i in data:
    result.data.add(i.toNucleotide())

proc add*(alignment: var Alignment, sequence: Sequence) =
  ## Add sequence object to alignment object
  if alignment.isNil:
    alignment = Alignment()
  if alignment.ntax == 0:
    alignment.nchar = sequence.len
  else:
    if sequence.data.len != alignment.nchar:
      raise newException(AlignmentError, "Sequence length does not match alignment")
  alignment.seqs.add(sequence)
  alignment.ntax += 1

proc add*(alignment: var Alignment, sequences: seq[Sequence]) = 
  ## Convenience proc
  for sequence in sequences:
    alignment.add(sequence)

proc add*(fasta: var Fasta, sequence: Sequence) =
  ## Add sequence object to fasta object
  if fasta.isNil:
    fasta = Fasta()
  if fasta.ntax == 0:
    fasta.nchar = sequence.len
  fasta.seqs.add(sequence)
  fasta.ntax += 1

proc countSegregatingSites*(alignment: Alignment): int =
  for i in 0 ..< alignment.nchar: # Iter over sites in alignment 
    while true:
      for j in 0 ..< alignment.ntax: # Iter over seqs in alignmnent 
        if diffBase(alignment.seqs[0].data[i], alignment.seqs[j].data[i]):
          result += 1
          break
      break

proc nucleotideDiversity*(alignment: Alignment): float = 
  # TODO: Make sure this is right
  var pi = 0.0
  var nchar = float(alignment.nchar)
  for i in 0 ..< alignment.ntax - 1:
    for j in i + 1 ..< alignment.ntax: 
      var diff = 0 
      for k in 0 ..< alignment.nchar:
        if diffBase(alignment.seqs[i].data[k], alignment.seqs[j].data[k]):
          diff += 1 
      pi = ((float(diff) / nchar) + pi) / 2
  result = pi

proc reverse*(sequence: Sequence) = 
  sequence.data.reverse()

proc complement*(sequence: Sequence) = 
  for i, d in sequence.data:
    sequence.data[i] = complement(d)

proc reverseComplement*(sequence: Sequence) = 
  sequence.complement()
  sequence.reverse()
