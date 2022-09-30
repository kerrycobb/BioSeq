# TODO: Figure out what to do about nucleotide ambiguities
# Probably need to make two different versions of this module. One for when 
# nucleotides can be ambiguous and one for when they cannot be.

## IUPAC amino acid code
## 
## Symbol Abreviation Amino Acid
## A    	Ala 	      Alanine
## C    	Cys 	      Cysteine
## D    	Asp 	      Aspartic Acid
## E    	Glu 	      Glutamic Acid
## F    	Phe 	      Phenylalanine
## G    	Gly 	      Glycine
## H    	His 	      Histidine
## I    	Ile 	      Isoleucine
## K    	Lys 	      Lysine
## L    	Leu 	      Leucine
## M    	Met 	      Methionine
## N    	Asn 	      Asparagine
## O      Pyl         Pyrolysine
## P    	Pro 	      Proline
## Q    	Gln 	      Glutamine
## R    	Arg 	      Arginine
## S    	Ser 	      Serine
## T    	Thr 	      Threonine
## U      Sec         Selenocysteine
## V    	Val 	      Valine
## W    	Trp 	      Tryptophan
## Y    	Tyr 	      Tyrosine
## *      Stp         Stop
## X      Amb         Ambiguous/Unknown 
## B      Asx         Aspartic acid or asparagine 
## Z      Glx         Glutamic acid or glutamine

import ./nucleotide
import ./parserMacro
import std/macros

type
  AminoAcid* = enum aaA, aaC, aaD, aaE, aaF, aaG, aaH, aaI, aaK, aaL, aaM, aaN, aaO, aaP, aaQ, aaR, aaS, aaT, aaU, aaV, aaW, aaY, aaStp, aaX, aaB, aaZ

const
  aminoAcidChar*: array[AminoAcid, char] = ['A','C','D','E','F','G','H','I','K','L','M','N','O','P','Q','R','S','T','U','V','W','Y','*','X','B','Z']
  aminoAcidAbrev*: array[AminoAcid, string] = ["Ala","Cys","Asp","Glu","Phe","Gly","His","Ile","Lys","Leu","Met","Asn","Pyl","Pro","Gln","Arg","Ser","Thr","Sec","Val","Trp","Tyr","Stp","Amb","Asx","Glx"]
  aminoAcidName*: array[AminoAcid, string] = ["Alanine","Cysteine","Aspartic Acid","Glutamic Acid","Phenylalanine","Glycine","Histidine","Isoleucine","Lysine","Leucine","Methionine","Asparagine","Pyrrolysine","Proline","Glutamine","Arginine","Serine","Threonine","Selenocysteine","Valine","Tryptophan","Tyrosine","Stop","Ambiguous/Unknown","Aspartic acid or asparagine","Glutamic acid or glutamine"]

func parseChar*(c: char, T: typedesc[AminoAcid]): AminoAcid = 
  ## Parse character to DNA enum type.
  generateParser(c, aminoAcidChar, AminoAcid)

func toAminoAcidSeq*(data: seq[char]): seq[AminoAcid] =
  ## Parse character seq as Nucleotide seq
  result = newSeq[AminoAcid](data.len)
  for i, d in data:
    result[i] = parseChar(d, AminoAcid)

func toAminoAcidSeq*(data: string): seq[AminoAcid] =
  ## Parse string as Nucleotide seq 
  toAminoAcidSeq(cast[seq[char]](data))

func char*(a: AminoAcid): char = aminoAcidChar[a]
  ## Character representation of amino acid.

const  
  dnaCodonSequence* = [ 
    "AAA","AAC","AAG","AAT","ACA","ACC","ACG","ACT","AGA","AGC","AGG","AGT","ATA","ATC","ATG","ATT",
    "CAA","CAC","CAG","CAT","CCA","CCC","CCG","CCT","CGA","CGC","CGG","CGT","CTA","CTC","CTG","CTT",
    "GAA","GAC","GAG","GAT","GCA","GCC","GCG","GCT","GGA","GGC","GGG","GGT","GTA","GTC","GTG","GTT",
    "TAA","TAC","TAG","TAT","TCA","TCC","TCG","TCT","TGA","TGC","TGG","TGT","TTA","TTC","TTG","TTT"]
  rnaCodonSequence* = [ 
    "AAA","AAC","AAG","AAU","ACA","ACC","ACG","ACU","AGA","AGC","AGG","AGU","AUA","AUC","AUG","AUU",
    "CAA","CAC","CAG","CAU","CCA","CCC","CCG","CCU","CGA","CGC","CGG","CGU","CUA","CUC","CUG","CUU",
    "GAA","GAC","GAG","GAU","GCA","GCC","GCG","GCU","GGA","GGC","GGG","GGU","GUA","GUC","GUG","GUU",
    "UAA","UAC","UAG","UAU","UCA","UCC","UCG","UCU","UGA","UGC","UGG","UGU","UUA","UUC","UUG","UUU"]

type
  AminoAcidCode* = enum 
    acStandard =             "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSS*CWCLFLF",
    acVertmito =             "KNKNTTTT*S*SMIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSWCWCLFLF",
    acYeastmito =            "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSWCWCLFLF",
    acMoldmito =             "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSWCWCLFLF",
    acInvertmito =           "KNKNTTTTSSSSMIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSWCWCLFLF",
    acCiliate =              "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVVQYQYSSSS*CWCLFLF",
    acEchinomito =           "NNKNTTTTSSSSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSWCWCLFLF",
    acEuplotid =             "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSCCWCLFLF",
    acPlantplastid =         "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSS*CWCLFLF",
    acAltyeast =             "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLSLEDEDAAAAGGGGVVVV*Y*YSSSS*CWCLFLF",
    acAscidianmito =         "KNKNTTTTGSGSMIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSWCWCLFLF",
    acAltflatwormmito =      "NNKNTTTTSSSSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVVYY*YSSSSWCWCLFLF",
    acBlepharismamacro =     "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*YQYSSSS*CWCLFLF",
    acChlorophyceanmito =    "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*YLYSSSS*CWCLFLF",
    acTrematodemito =        "NNKNTTTTSSSSMIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSSWCWCLFLF",
    acScenedesmusmito =      "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*YLY*SSS*CWCLFLF",
    acThraustochytriummito = "KNKNTTTTRSRSIIMIQHQHPPPPRRRRLLLLEDEDAAAAGGGGVVVV*Y*YSSSS*CWC*FLF"

macro generateTranslation(nucleotides: array[3, Nucleotide], aminoAcids: string): untyped = 
  # TODO: Raise exception if codon includes gaps 
  ## Generates case statement for translating Amino acid codon sequence
  ## 
  ## Generated code:
  ## 
  ## var str = newString(3)
  ## for i in 0 .. 2:
  ##   str[i] = nucleotides[i].char
  ## case str
  ## of dnaCodonSequence[0]:
  ##   result = parseChar(standard[0], AminoAcid)
  ## ...
  ## else:
  ##   result = aaX 
  result = nnkStmtList.newTree()
  # Determnine if nucleotides are RNA or DNA and select appropriate Codon seuqences
  var codons: array[64, string]
  if nucleotides.getTypeInst.repr == "array[0 .. 2, DNA]":
    codons = dnaCodonSequence 
  elif nucleotides.getTypeInst.repr == "array[0 .. 2, RNA]":
    codons = rnaCodonSequence 
  # Generate code to convert array of nucleotides into 3 character string
  result.add(
    nnkVarSection.newTree(
      nnkIdentDefs.newTree(newIdentNode("str"), newEmptyNode(),  
          nnkCall.newTree(newIdentNode("newString"), newLit(3)))),
    nnkForStmt.newTree(
      newIdentNode("i"),
      nnkInfix.newTree(newIdentNode(".."), newLit(0), newLit(2)),
      nnkStmtList.newTree(
        nnkAsgn.newTree(
          nnkBracketExpr.newTree(newIdentNode("str"), newIdentNode("i")),
          nnkDotExpr.newTree(nnkBracketExpr.newTree(nucleotides, 
              newIdentNode("i")), newIdentNode("char"))))))
  # Generate case statement
  var caseStmt = nnkCaseStmt.newTree(newIdentNode("str"))
  # For each codon assign the correct amino acid
  for i in 0 .. 63:
    caseStmt.add(
      nnkOfBranch.newTree(
        newLit(codons[i]),
        nnkStmtList.newTree(
          nnkAsgn.newTree(
            newIdentNode("result"),
            nnkCall.newTree(newIdentNode("parseChar"), 
                nnkBracketExpr.newTree(aminoAcids, newIntLitNode(i)), 
                newIdentNode("AminoAcid"))))))
  # If the string doesn't match a valid codon then assign unknown amino acid
  caseStmt.add(  
    nnkElse.newTree(
      nnkAsgn.newTree(newIdentNode("result"), newLit(aaX))
  ))
  result.add(caseStmt) 
  # echo result.repr

func translate*(nucleotides: array[3, Nucleotide], code: AminoAcidCode = acStandard): AminoAcid = 
  ## Translate nucleotide codo to amino acid
  generateTranslation(nucleotides, $code) 