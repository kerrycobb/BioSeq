# TODO: Make gaps raise an error in the translate macro. 
# Or should gaps be allowed and translated to ambiguous/unknown?
# TODO: Should turn the current implementation in an ExtendedAminoAcid type 
# and exclude the ambiguous and a typical amino acids from the regular one.

import ./nucleotide
import ./parserMacro
import std/macros
import std/math

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
## B       Asx          Aspartic acid or asparagine 
## Z       Glx          Glutamic acid or glutamine
## \*      Stp          Stop
## X       Amb          Ambiguous/Unknown 
## ======  ===========  ============================ 

runnableExamples:
  import bioseq
  
  let ala = parseChar('A', AminoAcid)  
  assert ala.char() == 'A'

  let amino = translate([dnaT, dnaT, dnaT], gCode1)
  assert amino == aaF


type
  AminoAcid* = enum aaA, aaC, aaD, aaE, aaF, aaG, aaH, aaI, aaK, aaL, aaM, aaN, 
      aaO, aaP, aaQ, aaR, aaS, aaT, aaU, aaV, aaW, aaY, aaB, aaZ, aaStp, aaX

const
  aminoAcidChar*: array[AminoAcid, char] = ['A','C','D','E','F','G','H','I','K',
      'L','M','N','O','P','Q','R','S','T','U','V','W','Y','B','Z','*','X']

  aminoAcidAbrev*: array[AminoAcid, string] = ["Ala","Cys","Asp","Glu","Phe",
      "Gly","His","Ile","Lys","Leu","Met","Asn","Pyl","Pro","Gln","Arg","Ser",
      "Thr","Sec","Val","Trp","Tyr","Asx","Glx","Stp","Amb"]

  aminoAcidName*: array[AminoAcid, string] = ["Alanine","Cysteine",
      "Aspartic Acid","Glutamic Acid","Phenylalanine","Glycine","Histidine",
      "Isoleucine","Lysine","Leucine","Methionine","Asparagine","Pyrrolysine",
      "Proline","Glutamine","Arginine","Serine","Threonine","Selenocysteine",
      "Valine","Tryptophan","Tyrosine","Aspartic acid or asparagine",
      "Glutamic acid or glutamine","Stop","Ambiguous/Unknown"]

func parseChar*(c: char, T: typedesc[AminoAcid]): AminoAcid = 
  ## Parse character to DNA enum type.
  generateParser(c, aminoAcidChar, AminoAcid)

func char*(a: AminoAcid): char = aminoAcidChar[a]
  ## Character representation of amino acid.
  ## 
func toAminoAcidSeq*(data: seq[char]): seq[AminoAcid] =
  ## Parse character seq as Nucleotide seq
  result = newSeq[AminoAcid](data.len)
  for i, d in data:
    result[i] = parseChar(d, AminoAcid)

func toAminoAcidSeq*(data: string): seq[AminoAcid] =
  ## Parse string as Nucleotide seq 
  toAminoAcidSeq(cast[seq[char]](data))

# TODO: Are these useful for anything?
# const
#   dnaCodons = [
#     "AAA", "AAG", "AAC", "AAT", "AGA", "AGG", "AGC", "AGT", 
#     "ACA", "ACG", "ACC", "ACT", "ATA", "ATG", "ATC", "ATT", 
#     "GAA", "GAG", "GAC", "GAT", "GGA", "GGG", "GGC", "GGT",
#     "GCA", "GCG", "GCC", "GCT", "GTA", "GTG", "GTC", "GTT", 
#     "CAA", "CAG", "CAC", "CAT", "CGA", "CGG", "CGC", "CGT", 
#     "CCA", "CCG", "CCC", "CCT", "CTA", "CTG", "CTC", "CTT", 
#     "TAA", "TAG", "TAC", "TAT", "TGA", "TGG", "TGC", "TGT", 
#     "TCA", "TCG", "TCC", "TCT", "TTA", "TTG", "TTC", "TTT"]
#   rnaCodons = [
#     "AAA", "AAG", "AAC", "AAU", "AGA", "AGG", "AGC", "AGU", 
#     "ACA", "ACG", "ACC", "ACU", "AUA", "AUG", "AUC", "AUU", 
#     "GAA", "GAG", "GAC", "GAU", "GGA", "GGG", "GGC", "GGU",
#     "GCA", "GCG", "GCC", "GCU", "GUA", "GUG", "GUC", "GUU", 
#     "CAA", "CAG", "CAC", "CAU", "CGA", "CGG", "CGC", "CGU", 
#     "CCA", "CCG", "CCC", "CCU", "CUA", "CUG", "CUC", "CUU", 
#     "UAA", "UAG", "UAC", "UAU", "UGA", "UGG", "UGC", "UGU", 
#     "UCA", "UCG", "UCC", "UCU", "UUA", "UUG", "UUC", "UUU"]

type
  GeneticCode* = enum 
    ## Genetic codes for translating nucleotides to amino acids. 
    ## 
    ## The genetic code follows the `NCBI definitions <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi>`_ 
    ## 
    ## gCode1  - `The Standard Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG1>`_
    ## gCode2  - `The Vertebrate Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG2>`_
    ## gCode3  - `The Yeast Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG3>`_
    ## gCode4  - `The Mold, Protozoan, and Coelenterate Mitochondrial Code and the Mycoplasma/Spiroplasma Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG4>`_
    ## gCode5  - `The Invertebrate Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG5>`_
    ## gCode6  - `The Ciliate, Dasycladacean and Hexamita Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG6>`_
    ## gCode9  - `The Echinoderm and Flatworm Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG9>`_
    ## gCode10 - `The Euplotid Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG10>`_
    ## gCode11 - `The Bacterial, Archaeal and Plant Plastid Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG11>`_
    ## gCode12 - `The Alternative Yeast Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG12>`_
    ## gCode13 - `The Ascidian Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG13>`_
    ## gCode14 - `The Alternative Flatworm Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG14>`_
    ## gCode16 - `Chlorophycean Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG16>`_
    ## gCode21 - `Trematode Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG21>`_
    ## gCode22 - `Scenedesmus obliquus Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG22>`_
    ## gCode23 - `Thraustochytrium Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG23>`_
    ## gCode24 - `Rhabdopleuridae Mitochondrial Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG24>`_
    ## gCode25 - `Candidate Division SR1 and Gracilibacteria Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG25>`_
    ## gCode26 - `Pachysolen tannophilus Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG26>`_
    ## gCode27 - `Karyorelict Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG27>`_
    ## gCode28 - `Condylostoma Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG28>`_
    ## gCode29 - `Mesodinium Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG29>`_
    ## gCode30 - `Peritrich Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG30>`_
    ## gCode31 - `Blastocrithidia Nuclear Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG31>`_
    ## gCode33 - `Cephalodiscidae Mitochondrial UAA-Tyr Code <https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi#SG33>`_
    ##
    ## A more descriptive alias is available for each genetic code if desired: 
    ## gCode1: `gc_Standard`
    ## gCode2: `gc_Vertebrate_Mito`
    ## gCode3: `gc_Yeast_Mito`
    ## gCode4: `gc_Mold_Protozoan_Coelenterate_Mito_and_Mycoplasma_Spiroplasma`
    ## gCode5: `gc_Invertebrate_Mito`
    ## gCode6: `gc_Ciliate_Dasycladacean_and_Hexamita_Nuc`
    ## gCode9: `gc_Echinoderm_and_Flatworm_Mito`
    ## gCode10: `gc_Euplotid_Nuc`
    ## gCode11: `gc_Bacterial_Archaeal_and_Plant_Plastid`
    ## gCode12: `gc_Alternative_Yeast_Nuc`
    ## gCode13: `gc_Ascidian_Mito`
    ## gCode14: `gc_Alternative_Flatworm_Mito`
    ## gCode16: `gc_Chlorophycean_Mito`
    ## gCode21: `gc_Trematode_Mito`
    ## gCode22: `gc_Scenedesmus_obliquus_Mito`
    ## gCode23: `gc_Thraustochytrium_Mito`
    ## gCode24: `gc_Rhabdopleuridae_Mito`
    ## gCode25: `gc_Candidate_Division_SR1_and_Gracilibacteria`
    ## gCode26: `gc_Pachysolen_tannophilus_Nuc`
    ## gCode27: `gc_Karyorelict_Nuc`
    ## gCode28: `gc_Condylostoma_Nuc`
    ## gCode29: `gc_Mesodinium_Nuc`
    ## gCode30: `gc_Peritrich_Nuc`
    ## gCode31: `gc_Blastocrithidia_Nuc`
    ## gCode33: `gc_Cephalodiscidae_Mito_UAA_Tyr` 
    ## 
    ## The amino acids in each string are ordered relative to this sequence of codons:
    ##  AAA, AAG, AAC, AAT, AGA, AGG, AGC, AGT, ACA, ACG, ACC, ACT, ATA, ATG, 
    ##    ATC, ATT, GAA, GAG, GAC, GAT, GGA, GGG, GGC, GGT, GCA, GCG, GCC, GCT, 
    ##    GTA, GTG, GTC, GTT, CAA, CAG, CAC, CAT, CGA, CGG, CGC, CGT, CCA, CCG, 
    ##    CCC, CCT, CTA, CTG, CTC, CTT, TAA, TAG, TAC, TAT, TGA, TGG, TGC, TGT, 
    ##    TCA, TCG, TCC, TCT, TTA, TTG, TTC, TTT
    
    gCode1  = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YY*WCCSSSSLLFF",
    gCode2  = "KKNN**SSTTTTMMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYWWCCSSSSLLFF",
    gCode3  = "KKNNRRSSTTTTMMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPTTTT**YYWWCCSSSSLLFF",
    gCode4  = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYWWCCSSSSLLFF",
    gCode5  = "KKNNSSSSTTTTMMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYWWCCSSSSLLFF",
    gCode6  = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLQQYY*WCCSSSSLLFF",
    gCode9  = "NKNNSSSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYWWCCSSSSLLFF",
    gCode10 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYCWCCSSSSLLFF",
    gCode11 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YY*WCCSSSSLLFF",
    gCode12 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLSLL**YY*WCCSSSSLLFF",
    gCode13 = "KKNNGGSSTTTTMMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYWWCCSSSSLLFF",
    gCode14 = "NKNNSSSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLY*YYWWCCSSSSLLFF",
    gCode16 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL*LYY*WCCSSSSLLFF",
    gCode21 = "NKNNSSSSTTTTMMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYWWCCSSSSLLFF",
    gCode22 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL*LYY*WCC*SSSLLFF",
    gCode23 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YY*WCCSSSS*LFF",
    gCode24 = "KKNNSKSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYWWCCSSSSLLFF",
    gCode25 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLL**YYGWCCSSSSLLFF",
    gCode26 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLALL**YY*WCCSSSSLLFF",
    gCode27 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLQQYYWWCCSSSSLLFF",
    gCode28 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLQQYYWWCCSSSSLLFF",
    gCode29 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLYYYY*WCCSSSSLLFF",
    gCode30 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLEEYY*WCCSSSSLLFF",
    gCode31 = "KKNNRRSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLEEYYWWCCSSSSLLFF",
    gCode33 = "KKNNSKSSTTTTIMIIEEDDGGGGAAAAVVVVQQHHRRRRPPPPLLLLY*YYWWCCSSSSLLFF",

const 
  gc_Standard* = gCode1
  gc_Vertebrate_Mito* = gCode2
  gc_Yeast_Mito* = gCode3
  gc_Mold_Protozoan_Coelenterate_Mito_and_Mycoplasma_Spiroplasma* = gCode4
  gc_Invertebrate_Mito* = gCode5
  gc_Ciliate_Dasycladacean_and_Hexamita_Nuc* = gCode6
  gc_Echinoderm_and_Flatworm_Mito* = gCode9
  gc_Euplotid_Nuc* = gCode10
  gc_Bacterial_Archaeal_and_Plant_Plastid* = gCode11
  gc_Alternative_Yeast_Nuc* = gCode12
  gc_Ascidian_Mito* = gCode13
  gc_Alternative_Flatworm_Mito* = gCode14
  gc_Chlorophycean_Mito* = gCode16
  gc_Trematode_Mito* = gCode21
  gc_Scenedesmus_obliquus_Mito* = gCode22
  gc_Thraustochytrium_Mito* = gCode23
  gc_Rhabdopleuridae_Mito* = gCode24
  gc_Candidate_Division_SR1_and_Gracilibacteria* = gCode25
  gc_Pachysolen_tannophilus_Nuc* = gCode26
  gc_Karyorelict_Nuc* = gCode27
  gc_Condylostoma_Nuc* = gCode28
  gc_Mesodinium_Nuc* = gCode29
  gc_Peritrich_Nuc* = gCode30
  gc_Blastocrithidia_Nuc* = gCode31
  gc_Cephalodiscidae_Mito_UAA_Tyr* = gCode33

macro createGeneticCodeMatrix(): untyped = 
  ## Creates 2D array from GeneticCode strings for easy indexing by the 
  ## translate proc.
  var matrix: array[GeneticCode.high.ord * 64, AminoAcid]
  for i in 0 ..< GeneticCode.high.ord:
    for j in 0 ..< 64:
      let aminoAcidChar = ($GeneticCode(i))[j] 
      matrix[i * 64 + j] = parseChar(aminoAcidChar, AminoAcid)
  result = newLit(matrix)
  # # Alternative which would be called inside of translate() proc
  # result = nnkStmtList.newTree(nnkLetSection.newTree(nnkIdentDefs.newTree(
  #   newIdentNode("geneticCodeMatrix"), newEmptyNode(), newLit(matrix))))

const geneticCodeMatrix = createGeneticCodeMatrix() 

func translate*(nucleotides: array[3, AnyNucleotide], code: GeneticCode): AminoAcid = 
  ## Translate nucleotide codon to amino acid. 
  var num = 0
  for i in 0..2:
    let p = 4^(2-i) 
    num += p * nucleotides[i].ord   
  if num < 64:
    result = geneticCodeMatrix[code.ord * 64 + num]  
  else:
    result = aaX 