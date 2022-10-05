# Script to reorder the genetic code string from Genbank for use in the aminoAcid module.

import std/tables
import std/algorithm
import std/sequtils
import std/enumerate
import math

# Genetic codes directly from Genbank: https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi
let geneticCode = {
  "gCode1" : "FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode2" : "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSS**VVVVAAAADDEEGGGG",
  "gCode3" : "FFLLSSSSYY**CCWWTTTTPPPPHHQQRRRRIIMMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode4" : "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode5" : "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSSSVVVVAAAADDEEGGGG",
  "gCode6" : "FFLLSSSSYYQQCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode9" : "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG",
  "gCode10": "FFLLSSSSYY**CCCWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode11": "FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode12": "FFLLSSSSYY**CC*WLLLSPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode13": "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSGGVVVVAAAADDEEGGGG",
  "gCode14": "FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG",
  "gCode16": "FFLLSSSSYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode21": "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNNKSSSSVVVVAAAADDEEGGGG",
  "gCode22": "FFLLSS*SYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode23": "FF*LSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode24": "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSSKVVVVAAAADDEEGGGG",
  "gCode25": "FFLLSSSSYY**CCGWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode26": "FFLLSSSSYY**CC*WLLLAPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode27": "FFLLSSSSYYQQCCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode28": "FFLLSSSSYYQQCCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode29": "FFLLSSSSYYYYCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode30": "FFLLSSSSYYEECC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode31": "FFLLSSSSYYEECCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
  "gCode33": "FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSSKVVVVAAAADDEEGGGG"}.toOrderedTable

# Codons in NCBI Genbank Order
let 
  codons = [
    "TTT","TTC","TTA","TTG","TCT","TCC","TCA","TCG",
    "TAT","TAC","TAA","TAG","TGT","TGC","TGA","TGG",
    "CTT","CTC","CTA","CTG","CCT","CCC","CCA","CCG",
    "CAT","CAC","CAA","CAG","CGT","CGC","CGA","CGG",
    "ATT","ATC","ATA","ATG","ACT","ACC","ACA","ACG",
    "AAT","AAC","AAA","AAG","AGT","AGC","AGA","AGG",
    "GTT","GTC","GTA","GTG","GCT","GCC","GCA","GCG",
    "GAT","GAC","GAA","GAG","GGT","GGC","GGA","GGG"]

  # New base order for new codon order
  charVal = {'A': 0, 'G': 1, 'C':2, 'T':3}.newTable 

# Reorder codons by their sum
var codonVal = initOrderedTable[string, int]()
for cod in codons:
  var num = 0
  for i, j in cod:
    let p = 4^(3 - 1 - i)
    num += p * charVal[j]
  codonVal[cod] = num 
codonVal.sort(proc (x, y: (string, int)): int = cmp(x[1], y[1]), order = SortOrder.Ascending)

# Reordered codon sequence 
var newCodons: seq[string]
for i in codonVal.keys:
  newCodons.add(i) 

# Map codons to amino acid characters for each genetic code
var codonTableSeq: seq[(string, OrderedTable[string, char])]
for name, aminoAcidChars in geneticCode.pairs:
  var codonToAminoMapping: seq[(string, char)] 
  for pairs in zip(codons, aminoAcidChars):
    let (cod, amino) = pairs
    codonToAminoMapping.add((cod, amino))
  codonTableSeq.add((name, codonToAminoMapping.toOrderedTable()))
let codonTable = codonTableSeq.toOrderedTable()

# Make new amino acid strings with new order
var newGeneticCodeSeq: seq[(string, string)]
for name in geneticCode.keys:
  var newStr = newString(64)   
  for i in 0 ..< 64:
    newStr[i] = codonTable[name][newCodons[i]] 
  newGeneticCodeSeq.add((name, newStr))

# Print codons and amino acid strings in new order
echo newCodons
for i in newGeneticCodeSeq:
  echo i[0] & " = \"" & i[1] & "\","