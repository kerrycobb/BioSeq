# TODO: Make gaps raise an error in the translate macro. 
# Or should gaps be allowed and translated to ambiguous/unknown?
# TODO: Should turn the current implementation in an ExtendedAminoAcid type 
# and exclude the ambiguous and a typical amino acids from the regular one.

import ./nucleotide
import ./parserMacro
import std/macros

## The `aminoAcid` module contains the `AminoAcid` `enum` type for working with  
## amino acid sequence data. Using an enum type provides convenience and type safety.
## The `AminoAcid` type is an extended IUPAC code which includes Prolysine, Selenocysteine, 
## and the two ambiguous characters 'B' and 'Z'. A full description of the 
## implementation can be seen in the table below. This module provides functions
## for parsing amino acid characters and for translating a nucleic acid condon. 
## 
## The genetic codes for translating to amino acids are sourced from 
## NCIB at https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi.
## 
## ======  ===========  ============================ 
## Symbol  Abreviation  Amino Acid
## ======  ===========  ============================ 
## A    	 Ala 	        Alanine
## C    	 Cys 	        Cysteine
## D    	 Asp 	        Aspartic Acid
## E    	 Glu 	        Glutamic Acid
## F    	 Phe 	        Phenylalanine
## G    	 Gly 	        Glycine
## H    	 His 	        Histidine
## I    	 Ile 	        Isoleucine
## K    	 Lys 	        Lysine
## L    	 Leu 	        Leucine
## M    	 Met 	        Methionine
## N    	 Asn 	        Asparagine
## O       Pyl          Pyrolysine
## P    	 Pro 	        Proline
## Q    	 Gln 	        Glutamine
## R    	 Arg 	        Arginine
## S    	 Ser 	        Serine
## T    	 Thr 	        Threonine
## U       Sec          Selenocysteine
## V    	 Val 	        Valine
## W    	 Trp 	        Tryptophan
## Y    	 Tyr 	        Tyrosine
## \*      Stp          Stop
## X       Amb          Ambiguous/Unknown 
## B       Asx          Aspartic acid or asparagine 
## Z       Glx          Glutamic acid or glutamine
## ======  ===========  ============================ 

runnableExamples:
  import bioseq
  
  let ala = parseChar('A', AminoAcid)  
  assert ala.char() == 'A'

  let amino = translate([dnaT, dnaT, dnaT], gc_Standard_1)
  assert amino == aaF


type
  AminoAcid* = enum aaA, aaC, aaD, aaE, aaF, aaG, aaH, aaI, aaK, aaL, aaM, aaN, 
      aaO, aaP, aaQ, aaR, aaS, aaT, aaU, aaV, aaW, aaY, aaStp, aaX, aaB, aaZ

const
  aminoAcidChar*: array[AminoAcid, char] = ['A','C','D','E','F','G','H','I','K',
      'L','M','N','O','P','Q','R','S','T','U','V','W','Y','*','X','B','Z']

  aminoAcidAbrev*: array[AminoAcid, string] = ["Ala","Cys","Asp","Glu","Phe",
      "Gly","His","Ile","Lys","Leu","Met","Asn","Pyl","Pro","Gln","Arg","Ser",
      "Thr","Sec","Val","Trp","Tyr","Stp","Amb","Asx","Glx"]

  aminoAcidName*: array[AminoAcid, string] = ["Alanine","Cysteine",
      "Aspartic Acid","Glutamic Acid","Phenylalanine","Glycine","Histidine",
      "Isoleucine","Lysine","Leucine","Methionine","Asparagine","Pyrrolysine",
      "Proline","Glutamine","Arginine","Serine","Threonine","Selenocysteine",
      "Valine","Tryptophan","Tyrosine","Stop","Ambiguous/Unknown",
      "Aspartic acid or asparagine","Glutamic acid or glutamine"]

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
  ## Codon tables
  dnaCodonSequence* = [
    "TTT","TTC","TTA","TTG","TCT","TCC","TCA","TCG",
    "TAT","TAC","TAA","TAG","TGT","TGC","TGA","TGG",
    "CTT","CTC","CTA","CTG","CCT","CCC","CCA","CCG",
    "CAT","CAC","CAA","CAG","CGT","CGC","CGA","CGG",
    "ATT","ATC","ATA","ATG","ACT","ACC","ACA","ACG",
    "AAT","AAC","AAA","AAG","AGT","AGC","AGA","AGG",
    "GTT","GTC","GTA","GTG","GCT","GCC","GCA","GCG",
    "GAT","GAC","GAA","GAG","GGT","GGC","GGA","GGG"]
    
  rnaCodonSequence* = [
    "UUU","UUC","UUA","UUG","UCU","UCC","UCA","UCG",
    "UAU","UAC","UAA","UAG","UGU","UGC","UGA","UGG",
    "CUU","CUC","CUA","CUG","CCU","CCC","CCA","CCG",
    "CAU","CAC","CAA","CAG","CGU","CGC","CGA","CGG",
    "AUU","AUC","AUA","AUG","ACU","ACC","ACA","ACG",
    "AAU","AAC","AAA","AAG","AGU","AGC","AGA","AGG",
    "GUU","GUC","GUA","GUG","GCU","GCC","GCA","GCG",
    "GAU","GAC","GAA","GAG","GGU","GGC","GGA","GGG"]

type
  GeneticCode* = enum 
    ## Genetic codes for translating nucleotides to amino acids. See source for more information.
    ## Source: https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi
    gc_Standard_1 = "FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Vertebrate_Mito_2 = "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSS**VVVVAAAADDEEGGGG",
    gc_Yeast_Mito_3 = "FFLLSSSSYY**CCWWTTTTPPPPHHQQRRRRIIMMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Mold_Protozoan_Coelenterate_Mito_and_Mycoplasma_Spiroplasma_4 = "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Invertebrate_Mito_5 = "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSSSVVVVAAAADDEEGGGG",
    gc_Ciliate_Dasycladacean_and_Hexamita_Nuc_6 = "FFLLSSSSYYQQCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Echinoderm_and_Flatworm_Mito_9 = "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG",
    gc_Euplotid_Nuc_10 = "FFLLSSSSYY**CCCWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Bacterial_Archaeal_and_Plant_Plastid_11 = "FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Alternative_Yeast_Nuc_12 = "FFLLSSSSYY**CC*WLLLSPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Ascidian_Mito_13 = "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSGGVVVVAAAADDEEGGGG",
    gc_Alternative_Flatworm_Mito_14 = "FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG",
    gc_Chlorophycean_Mito_16 = "FFLLSSSSYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Trematode_Mito_21 = "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNNKSSSSVVVVAAAADDEEGGGG",
    gc_Scenedesmus_obliquus_Mito_22 = "FFLLSS*SYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Thraustochytrium_Mito_23 = "FF*LSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Rhabdopleuridae_Mito_24 = "FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSSKVVVVAAAADDEEGGGG",
    gc_Candidate_Division_SR1_and_Gracilibacteria_25 = "FFLLSSSSYY**CCGWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Pachysolen_tannophilus_Nuc_26 = "FFLLSSSSYY**CC*WLLLAPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Karyorelict_Nuc_27 = "FFLLSSSSYYQQCCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Condylostoma_Nuc_28 = "FFLLSSSSYYQQCCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Mesodinium_Nuc_29 = "FFLLSSSSYYYYCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Peritrich_Nuc_30 = "FFLLSSSSYYEECC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Blastocrithidia_Nuc_31 = "FFLLSSSSYYEECCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG",
    gc_Cephalodiscidae_Mito_UAA_Tyr_33 = "FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSSKVVVVAAAADDEEGGGG"


macro generateTranslation(nucleotides: array[3, Nucleotide], aminoAcids: string): untyped = 
  # TODO: Raise exception if codon includes gaps 
  # TODO: Change this to use the sum of the ordinals instead of converting to string 
  # which would make the macro unnecessary.
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

func translate*(nucleotides: array[3, AnyNucleotide], code: GeneticCode): AminoAcid = 
  ## Translate nucleotide codo to amino acid
  generateTranslation(nucleotides, $code) 