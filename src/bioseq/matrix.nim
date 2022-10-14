import ./nucleotide

## Matrix for working with sequence alignments.
## There's not much here yet.

# Existing matrix libraries
# Using uncheckedArrays:
#   https://github.com/planetis-m/manu
#   https://github.com/andreaferretti/neo
#   https://github.com/mratsim/Arraymancer
# Other: 
#   https://github.com/stisa/snail
#   https://github.com/YesDrX/numnim

type 
  Matrix*[T] = object
    rows, cols: int
    data: seq[T]

proc newMatrix*[T](rows, cols: int): Matrix[T] = 
  result.rows = rows
  result.cols = cols
  result.data = newSeq[T](rows * cols)

proc dim*[T](m: Matrix[T]): (int, int) =
  ## Get (row, column) dimensions tuple.
  (m.rows, m.cols)

proc rows*[T](m: Matrix[T]): int =
  ## Get row dimension.
  m.rows

proc cols*[T](m: Matrix[T]): int =
  ## Get column dimension.
  m.cols

template checkBounds*(cond: untyped, msg = "") =
  when compileOption("boundChecks"):
    {.line.}:
      if not cond:
        raise newException(IndexDefect, msg)

proc `[]`*[T](m: Matrix[T], i, j: int): T =
  ## Get a single element.
  checkBounds(i >= 0 and i < m.rows)
  checkBounds(j >= 0 and j < m.cols)
  result = m.data[i * m.cols + j]

proc `[]`*[T](m: var Matrix[T], i, j: int): var T =
  ## Get a single element.
  checkBounds(i >= 0 and i < m.rows)
  checkBounds(j >= 0 and j < m.cols)
  m.data[i * m.cols + j]

proc `[]=`*[T](m: var Matrix[T], i, j: int, s: T) =
  ## Set a single element.
  checkBounds(i >= 0 and i < m.rows)
  checkBounds(j >= 0 and j < m.cols)
  m.data[i * m.cols + j] = s

proc `$`*[T](m: Matrix[T]): string =
  result = newString(m.rows * m.cols + m.rows) 
  for i in 0 ..< m.rows:
    for j in 0 ..< m.cols:
      result[i * m.cols + j + i] = m[i,j].char
    result[(i + 1) * m.cols + i] = '\n'

proc stack*[T](matrices: varargs[Matrix[T]]): Matrix[T] = 
  ## Stack matrices together. 
  result.cols = matrices[0].cols
  for m in matrices:
    result.rows += m.rows
    checkBounds(result.cols == m.cols, "Matrices must have the same number of columns to stack") 
  result.data = newSeq[T](result.rows * result.cols)
  for m in 0 ..< matrices.len:
    for i in 0 ..< matrices[m].rows:
      for j in 0 ..< matrices[m].cols:
        result[m + i, j] = matrices[m][i, j]

proc concat*[T](matrices: varargs[Matrix[T]]): Matrix[T] =
  result.rows = matrices[0].rows
  for m in matrices:
    result.cols += m.cols
    checkBounds(result.rows == m.rows, "Matrices must have the same number of rows to concat")
  result.data = newSeq[T](result.rows * result.cols)
  var offset = 0
  for m in matrices:
    for i in 0 ..< m.rows:
      for j in 0 ..< m.cols:
        result[i, offset + j] = m[i, j]
    offset += m.cols

iterator column*[T](m: Matrix[T], j: int): T = 
  for i in 0 .. m.rows:
    yield m[i, j]

iterator column*[T](m: var Matrix[T], j: int): var T = 
  for i in 0 .. m.rows:
    yield m[i, j]

iterator row*[T](m: Matrix[T], j: int): T = 
  for i in 0 .. m.rows:
    yield m[i, j]

iterator row*[T](m: var Matrix[T], j: int): var T = 
  for i in 0 .. m.rows:
    yield m[i, j]



# Experimenting with ways to get columns and submatrices without copying.
# type
#   Column*[T] = object
#     len, step: int 
#     data: ptr UncheckedArray[T]
#     # data: ref UncheckedArray[T]

# proc column*[T](m: Matrix[T], c: int): Column[T] = 
#   result = Column[T](len: m.cols, step: m.rows)
#   # result.data = cast[ptr UncheckedArray[T]](m[0,c])
#   result.data = cast[ptr UncheckedArray[T]](m[0,c])


# var 
#   m = newMatrix[DNA](3,3)
# m[0,1] = dnaT
# m[1,1] = dnaG
# echo m

# var c = m.column(1) 
# echo c.data[0]


# var p = cast[ptr UncheckedArray[DNA]](m[0,1].addr)
# echo p[0] 

# # proc `[]`*[T](m: Column[T], i: int): T =
# #   ## Get a single element.
# #   checkBounds(i >= 0 and i < m.len)
# #   result = m.data[m.step * i]

# # proc `[]`*[T](m: var Column[T], i: int): var T =
# #   ## Get a single element.
# #   checkBounds(i >= 0 and i < m.len)
# #   # checkBounds(j >= 0 and j < m.c)
# #   m.data[m.step * i]

# # proc `[]=`*[T](m: var Column[T], i: int, s: T) =
# #   ## Set a single element.
# #   checkBounds(i >= 0 and i < m.len)
# #   m.data[m.step * i] = s

# # proc `$`*[T](m: Column[T]): string = 
# #   result = "" 
# #   for i in 0 ..< m.len:
# #     result.add($m[i])
# #     result.add('\n')

