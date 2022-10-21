import ./matrix
export matrix
import std/strutils

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