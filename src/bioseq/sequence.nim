import ./nucleotide
import ./aminoAcid
import std/algorithm

## Procs for dealing with sequences of Nucleotides

func toNucleotideSeq*(data: seq[char], typ: typedesc[AnyNucleotide]): seq[typ] =
  ## Parse character seq as Nucleotide seq
  result = newSeq[typ](data.len)
  for i, d in data:
    result[i] = parseChar(d, typ)

func toNucleotideSeq*(data: string, typ: typedesc[AnyNucleotide]): seq[typ] = 
  ## Parse string as Nucleotide seq 
  # TODO: Should just be able to cast string to seq[char] and call the above 
  # func but for some reason it wont work here. This approch works outside of
  # this module file. For example in the aminoAcids module.
  # toNucleotideSeq(cast[seq[char]](data))
  result = newSeq[typ](data.len)
  for i, d in data:
    result[i] = parseChar(d, typ)

func toString*[T: AnyNucleotide](data: seq[T]): string =  
  ## Returns string representation of nucleotide sequence.
  result = newString(data.len)
  for i in 0 ..< data.len:
    result[i] = data[i].char

func toCharSeq*[T: AnyNucleotide](data: seq[T]): seq[char] = 
  ## Returns seq of characters representing nucleotide sequence.
  result = newSeq[char](data.len)
  for i in 0 ..< data.len:
    result[i] = data[i].char

func `$`*(data: seq[AnyNucleotide]): string = 
  result = newstring(data.len)
  for i in 0 ..< data.len:
    result[i] = data[i].char

func complement*[T: AnyNucleotide](s: seq[T]): seq[T] = 
  ## Returns the complement of a sequence of nucleotides.
  result = newSeq[T](s.len)
  for i in 0 ..< s.len:
    result[i] = s[i].complement

func complement*[T: AnyNucleotide](s: var seq[T]) = 
  ## Replaces a sequence of nucleotides with the complement.
  for i in 0 ..< s..len:
    s[i] = s[i].complement

func reverseComplement*[T: AnyNucleotide](s: seq[T]): seq[T] = 
  ## Returns the reverse complement of a sequence of nucleotides.
  result = complement(s)
  result.reverse()

func reverseComplement*[T: AnyNucleotide](s: var seq[T]) = 
  ## Replace a sequence of nucleotides with the reverse complement.
  s.reverse()
  s.complement()

proc translate*[T: AnyNucleotide](s: seq[T], code: GeneticCode = gCode1): seq[AminoAcid] =
  ## Translate sequence of nucleotides to sequence of amino acid.
  ## 
  ## See documentation for `GeneticCode` `here<./aminoAcid.html#GeneticCode>`_
  assert s.len mod 3 == 0 
  result = newSeq[AminoAcid](s.len div 3)
  for i in 0 ..< result.len:
    let 
      a = 0 + i * 3
      b = 2 + i * 3
      codon = s[a..b] 
    result[i] = translateCodon([codon[0],codon[1],codon[2]], code)


 



