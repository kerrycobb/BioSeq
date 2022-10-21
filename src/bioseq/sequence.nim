import ./nucleotide
import ./aminoAcid
import std/algorithm

## Procs for dealing with sequences of Nucleotides

proc toSeq*(data: seq[char], typ: typedesc): seq[typ] = 
  result = newSeq[typ](data.len)
  for i, d in data:
    result[i] = parseChar(d, typ)

proc toSeq*(data: string, typ: typedesc): seq[typ] = 
  result = toSeq(cast[seq[char]](data), typ)

func toString*[T](data: seq[T]): string =  
  result = newString(data.len)
  for i in 0 ..< data.len:
    result[i] = data[i].toChar

func toCharSeq*[T](data: seq[T]): seq[char] = 
  result = newSeq[char](data.len)
  for i in 0 ..< data.len:
    result[i] = data[i].toChar

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
  result.reverse

func reverseComplement*[T: AnyNucleotide](s: var seq[T]) = 
  ## Replace a sequence of nucleotides with the reverse complement.
  s.reverse
  s.complement

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