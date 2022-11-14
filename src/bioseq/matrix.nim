
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

proc newMatrix*[T](rows, cols: int, data: seq[T]): Matrix[T] =
  assert data.len == rows * cols
  result.rows = rows
  result.cols = cols
  result.data = data 

proc dim*[T](m: Matrix[T]): (int, int) =
  ## Get (row, column) dimensions tuple.
  (m.rows, m.cols)

proc rows*[T](m: Matrix[T]): int =
  ## Get row dimension.
  m.rows

proc cols*[T](m: Matrix[T]): int =
  ## Get column dimension.
  m.cols

template checkBounds(cond: untyped, msg = "") =
  when compileOption("boundChecks"):
    {.line.}:
      if not cond:
        raise newException(IndexDefect, msg)

proc `[]`*[T](m: Matrix[T], row, col: int): T =
  ## Get a single element.
  checkBounds(row >= 0 and row < m.rows)
  checkBounds(col >= 0 and col < m.cols)
  result = m.data[row * m.cols + col]

proc `[]`*[T](m: var Matrix[T], row, col: int): var T =
  ## Get a single element.
  checkBounds(row >= 0 and row < m.rows)
  checkBounds(col >= 0 and col < m.cols)
  m.data[row * m.cols + col]

proc `[]=`*[T](m: var Matrix[T], row, col: int, s: T) =
  ## Set a single element.
  checkBounds(row >= 0 and row < m.rows)
  checkBounds(col >= 0 and col < m.cols)
  m.data[row * m.cols + col] = s

proc toString*[T](m: Matrix[T]): string =
  mixin toChar
  result = newString(m.rows * m.cols + m.rows - 1) 
  for i in 0 ..< m.rows:
    for j in 0 ..< m.cols:
      result[i * m.cols + j + i] = m[i,j].toChar
    if i != m.rows - 1:
      result[(i + 1) * m.cols + i] = '\n'

proc `$`*[T](m: Matrix[T]): string =
  m.toString

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

# iterator column*[T](m: Matrix[T], j: int): T = 
#   for i in 0 .. m.rows:
#     yield m[i, j]

# iterator column*[T](m: var Matrix[T], j: int): var T = 
#   for i in 0 .. m.rows:
#     yield m[i, j]

# iterator row*[T](m: Matrix[T], j: int): T = 
#   for i in 0 .. m.rows:
#     yield m[i, j]

# iterator row*[T](m: var Matrix[T], j: int): var T = 
#   for i in 0 .. m.rows:
#     yield m[i, j]