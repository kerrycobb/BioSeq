import ./matrix
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