import ./matrix
import ./nucleotide
import std/strutils

export matrix

type
  Alignment*[T] = object
    ids*: seq[string]
    data*: Matrix[T] 

proc newAlignment*[T](nseqs, nchars: int): Alignment[T] = 
  Alignment[T](ids: newSeq[string](nseqs), data: newMatrix[T](nseqs, nchars))

proc newAlignment*[T](nseqs, nchars: int, ids: seq[string], data: seq[T]): Alignment[T] = 
  assert ids.len == nseqs
  assert data.len == nseqs * nchars
  Alignment[T](ids:ids, data: newMatrix[T](nseqs, nchars, data))

proc nseqs*[T](a: Alignment[T]): int = 
  a.data.rows

proc nchars*[T](a: Alignment[T]): int = 
  a.data.cols

proc `$`*[T](a: Alignment[T]): string =
  mixin toChar
  var maxLenId = 0
  for i in a.ids: 
    if i.len > maxLenId: 
      maxLenId = i.len
  for i in 0 ..< a.nseqs:   
    var idStr = newString(maxLenId + 1)
    for j in 0 ..< a.ids[i].len:
      idStr[j] = a.ids[i][j]
    result.add(idStr.replace('\x00', ' '))
    var dataStr = newString(50)
    if a.nchars > 50:
      for j in 0 ..< 50:
        dataStr[j] = a.data[i,j].toChar
      dataStr.add("...")
    else:
      for j in 0 ..< a.nchars:
        dataStr[j] = a.data[i,j].toChar
    result.add(dataStr)
    if i != a.nseqs - 1:
      result.add("\n")

proc filterColumns*[T](a: Alignment[T], filter: set[T]): Alignment[T] = 
  ## Filter columns for which the set of character states is equal or a subset
  ## of the given set.
  var keepCols = newSeqOfCap[int](a.nchars)
  for col in 0 ..< a.nchars:
    var charSet: set[T]
    for row in 0 ..< a.nseqs:
      charSet.incl(a.data[row, col])
    if not (charSet <= filter): 
      keepCols.add(col)
  result = newAlignment[T](a.nseqs, keepCols.len)
  for row in 0 ..< a.nseqs:
    result.ids[row] = a.ids[row] 
    for col in 0 ..< keepCols.len:
      result.data[row, col] = a.data[row, keepCols[col]]

proc rowCharacterCount*[T](a: Alignment[T], row: int, chars: set[T]): int = 
  ## Count number of characters in row belonging to chars set.
  ## Doesn't account for ambiguous characters
  # TODO: What to do about ambiguous characters?
  for i in 0 ..< a.nchars: 
    if a.data[row, i] in chars:
      result += 1

proc colCharacterCount*[T](a: Alignment[T], col: int, chars: set[T]): int = 
  ## Count number of characters in row belonging to chars set.
  ## Doesn't account for ambiguous characters
  # TODO: What to do about ambiguous characters?
  for i in 0 ..< a.nseqs: 
    if a.data[i, col] in chars:
      result += 1


# TODO: Old implementation than needs to be integrated with the new code
# proc nucleotideDiversity*(alignment: Alignment): float = 
#   # TODO: Make sure this is right
#   var pi = 0.0
#   var nchar = float(alignment.nchars)
#   for i in 0 ..< alignment.nseqs - 1:
#     for j in i + 1 ..< alignment.nseqs: 
#       var diff = 0 
#       for k in 0 ..< alignment.nchars:
#         if diffBase(alignment.seqs[i].data[k], alignment.seqs[j].data[k]):
#           diff += 1 
#       pi = ((float(diff) / nchar) + pi) / 2
#   result = pi

################################################################################
# TODO: An approach similar to Dendropy might be better for these funtions. 
# Each different character type will need a couple of different ignorable types
# such as gap states and missing states. This would allow for more code reuse. 

proc alleleCount*[T: Nucleotide](align: Alignment[T], col: int): int = 
  ## N counted as missing data.
  mixin toUnambiguousSet
  assert col >= 0 and col < align.nchars
  var charSet: set[T]
  for row in 0 ..< align.nseqs:
    let c = align.data[row, col] 
    if not (c in {T(14), T(15), T(16)}): # {N, -, ?}
      charset.incl(toUnambiguousSet(c))
  result = charSet.len

proc alleleCount*[T: StrictNucleotide](align: Alignment[T], col: int): int = 
  mixin toUnambiguousSet
  assert col >= 0 and col < align.nchars
  var charSet: set[T]
  for row in 0 ..< align.nseqs:
    let c = align.data[row, col]
    charset.incl(toUnambiguousSet(c))
  result = charSet.len

proc numPolymorphicSites*[T](align: Alignment[T]): int = 
  ## Returns the number of polymorphic (segregating) sites in the alignment.
  #TODO: Might be able to make this faster for Nucleotides doing something like
  # I did in the old implementation
  for i in 0 ..< align.nchars:
    if align.alleleCount(i) > 1:
      result += 1

# Old implementation
# proc countSegregatingSites*(alignment: Alignment): int =
# Wouldn't work if first site was N?
#   for i in 0 ..< alignment.nchars: # Iter over sites in alignment 
#     while true:
#       for j in 0 ..< alignment.nseqs: # Iter over seqs in alignmnent 
#         if diffBase(alignment.seqs[0].data[i], alignment.seqs[j].data[i]):
#           result += 1
#           break
#       break

