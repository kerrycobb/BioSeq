import ./nucleotide


type 
  Matrix*[T] = object
    rows, columns: int
    data: seq[T]











# Inspiration taken from
# https://github.com/planetis-m/manu
# https://github.com/andreaferretti/neo
# TODO: Decide how to implement row, columns, and individual sequences

# import ./nucleotide

# type
#   Matrix*[T] = object
#     r, c: int
#     data: ptr UncheckedArray[T]

# template checkBounds(cond: untyped, msg = "") =
#   when compileOption("boundChecks"):
#     {.line.}:
#       if not cond:
#         raise newException(IndexDefect, msg)

# template createData(size): untyped =
#   when compileOption("threads"):
#     cast[ptr UncheckedArray[T]](allocShared(size * sizeof(T)))
#   else:
#     cast[ptr UncheckedArray[T]](alloc(size * sizeof(T)))

# # template createData0(size): untyped =
# #   when compileOption("threads"):
# #     cast[ptr UncheckedArray[T]](allocShared0(size * sizeof(T)))
# #   else:
# #     cast[ptr UncheckedArray[T]](alloc0(size * sizeof(T)))

# proc `=destroy`*[T](m: var Matrix[T]) =
#   if m.data != nil:
#     when compileOption("threads"):
#       deallocShared(m.data)
#     else:
#       dealloc(m.data)

# proc `=copy`*[T](m: var Matrix[T]; b: Matrix[T]) =
#   if m.data != b.data:
#     `=destroy`(m)
#     wasMoved(m)
#     m.r = b.r
#     m.c = b.c
#     if b.data != nil:
#       let len = b.r * b.c
#       m.data = createData[T](len)
#       copyMem(m.data, b.data, len * sizeof(T))

# # type
# #   ColVector*[T] = distinct Matrix[T]
# #   RowVector*[T] = distinct Matrix[T]
  
# proc matrix*[T](r, c: int): Matrix[T] {.inline.} =
#   ## Construct alignment. 
#   result.r = r 
#   result.c = c
#   result.data = createData[T](r * c)

# # proc matrixUninit*[T](nRows, nCols: int): Matrix[T] {.inline.} =
# #   ## Construct uninitialized alignment. 
# #   ## TODO: Might want to only keep this one and get rid of others that initialize with arbitarty data
# #   ## since they might not be that useful.
# #   ## TODO: But what does it mean to be uninitialized?
# #   result.nRows = nRows
# #   result.nCols = nCols
# #   result.data = createData[T](nRows * nCols)

# # proc matrix*[T](nRows, nCols: int, s: T): Matrix[T] =
# #   ## Construct constant alignment.
# #   result.nRows = nRows 
# #   result.nCols = nCols
# #   let len = nRows * nCols
# #   result.data = createData[T](len)
# #   for i in 0 ..< len:
# #     result.data[i] = s

# # proc matrix*[T](data: seq[seq[T]]): Matrix[T] =
# #   ## Construct a matrix from a 2-D array.
# #   result.nRows = data.len
# #   result.nCols = data[0].len
# #   for i in 0 ..< result.nRows:
# #     assert(data[i].len == result.nCols, "All rows must have the same length.")
# #   result.data = createData[T](result.nRows * result.nCols)
# #   for i in 0 ..< result.nRows:
# #     for j in 0 ..< result.nCols:
# #       result.data[i * result.nCols + j] = data[i][j]

# # proc getArray*[T](m: Matrix[T]): seq[seq[T]] =
# #   ## Make a two-dimensional array copy of the internal array.
# #   ## TODO: Think of better name?
# #   result = newSeq[seq[T]](m.nRows)
# #   for i in 0 ..< m.nRows:
# #     result[i] = newSeq[T](m.nCols)
# #     for j in 0 ..< m.nCols:
# #       result[i][j] = m.data[i * m.nCols + j]

# # proc getRowPacked*[T](m: Matrix[T]): seq[T] {.inline.} =
# #   ## Copy the internal one-dimensional row packed array.
# #   result = newSeq[T](m.nRows * m.nCols)
# #   for i in 0 ..< result.len:
# #     result[i] = m.data[i]

# proc dim*[T](m: Matrix[T]): (int, int) {.inline.} =
#   ## Get (row, column) dimensions tuple.
#   (m.r, m.c)

# proc rows*[T](m: Matrix[T]): int {.inline.} =
#   ## Get row dimension.
#   m.r

# proc cols*[T](m: Matrix[T]): int {.inline.} =
#   ## Get column dimension.
#   m.c

# proc `[]`*[T](m: Matrix[T], i, j: int): T {.inline.} =
#   ## Get a single element.
#   checkBounds(i >= 0 and i < m.r)
#   checkBounds(j >= 0 and j < m.c)
#   result = m.data[i * m.c + j]

# proc `[]`*[T](m: var Matrix[T], i, j: int): var T {.inline.} =
#   ## Get a single element.
#   checkBounds(i >= 0 and i < m.r)
#   checkBounds(j >= 0 and j < m.c)
#   m.data[i * m.c + j]

# proc `[]=`*[T](m: var Matrix[T], i, j: int, s: T) {.inline.} =
#   ## Set a single element.
#   checkBounds(i >= 0 and i < m.r)
#   checkBounds(j >= 0 and j < m.c)
#   m.data[i * m.c + j] = s

# # # proc `[]`*[T](c: ColVector[T], i: int): T {.inline.} =
# # #   ## Get a single element.
# # #   checkBounds(i >= 0 and i < Matrix[T](c).nRows)
# # #   Matrix[T](c).data[i]

# # # proc `[]`*[T](c: var ColVector[T], i: int): var T {.inline.} =
# # #   ## Get a single element.
# # #   checkBounds(i >= 0 and i < Matrix[T](c).nRows)
# # #   Matrix[T](c).data[i]

# # # proc `[]=`*[T](c: var ColVector[T], i: int, s: T) {.inline.} =
# # #   ## Set a single element.
# # #   checkBounds(i >= 0 and i < Matrix[T](c).nRows)
# # #   Matrix[T](c).data[i] = s

# # # proc `[]`*[T](r: RowVector[T], j: int): T {.inline.} =
# # #   ## Get a single element.
# # #   checkBounds(j >= 0 and j < Matrix[T](r).n)
# # #   Matrix[T](r).data[j]

# # # proc `[]`*[T](r: var RowVector[T], j: int): var T {.inline.} =
# # #   ## Get a single element.
# # #   checkBounds(j >= 0 and j < Matrix[T](r).n)
# # #   Matrix[T](r).data[j]

# # # proc `[]=`*[T](r: var RowVector[T], j: int, s: T) {.inline.} =
# # #   ## Set a single element.
# # #   checkBounds(j >= 0 and j < Matrix[T](r).n)
# # #   Matrix[T](r).data[j] = s

# # template `^^`(dim, i: untyped): untyped =
# #   (when i is BackwardsIndex: dim - int(i) else: int(i))

# # proc `[]`*[T, U, V, W, X](m: Matrix[T], r: HSlice[U, V], c: HSlice[W,
# #     X]): Matrix[T] =
# #   ## Get a submatrix,
# #   ## ``m[i0 .. i1, j0 .. j1]``
# #   let ra = m.nColsRows ^^ r.a
# #   let rb = m.nColsRows ^^ r.b
# #   checkBounds(ra >= 0 and rb < m.nColsRows, "Subalignment dimensions")
# #   let ca = m.nCols ^^ c.a
# #   let cb = m.nCols ^^ c.b
# #   checkBounds(ca >= 0 and cb < m.nCols, "Subalignment dimensions")
# #   result = matrixUninit[T](rb - ra + 1, cb - ca + 1)
# #   for i in 0 ..< result.m:
# #     for j in 0 ..< result.n:
# #       result[i, j] = m[i + ra, j + ca]

# # proc `[]`*[T](m: Matrix[T], r, c: openarray[SomeInteger]): Matrix[T] =
# #   ## Get a submatrix,
# #   ## ``m[[0, 2, 3, 4], [1, 2, 3, 4]]``
# #   checkBounds(r.len <= m.nColsRows, "Subalignment dimensions")
# #   checkBounds(c.len <= m.nCols, "Subalignment dimensions")
# #   result = matrixUninit[T](r.len, c.len)
# #   for i in 0 ..< r.len:
# #     for j in 0 ..< c.len:
# #       result[i, j] = m[r[i], c[j]]

# # proc `[]`*[T, U, V](m: Matrix[T], r: HSlice[U, V], c: openarray[
# #     SomeInteger]): Matrix[T] =
# #   ## Get a submatrix,
# #   ## ``m[i0 .. i1, [0, 2, 3, 4]]``
# #   let ra = m.nColsRows ^^ r.a
# #   let rb = m.nColsRows ^^ r.b
# #   checkBounds(ra >= 0 and rb < m.nColsRows, "Subalignment dimensions")
# #   checkBounds(c.len <= m.nCols, "Subalignment dimensions")
# #   result = matrixUninit[T](rb - ra + 1, c.len)
# #   for i in 0 ..< result.m:
# #     for j in 0 ..< c.len:
# #       result[i, j] = m[i + ra, c[j]]

# # proc `[]`*[T, U, V](m: Matrix[T], r: openarray[SomeInteger], c: HSlice[U,
# #     V]): Matrix[T] =
# #   ## Get a submatrix,
# #   ## ``m[[0, 2, 3, 4], j0 .. j1]``
# #   checkBounds(r.len <= m.nColsRows, "Subalignment dimensions")
# #   let ca = m.nCols ^^ c.a
# #   let cb = m.nCols ^^ c.b
# #   checkBounds(ca >= 0 and cb < m.nCols, "Subalignment dimensions")
# #   result = matrixUninit[T](r.len, cb - ca + 1)
# #   for i in 0 ..< r.len:
# #     for j in 0 ..< result.n:
# #       result[i, j] = m[r[i], j + ca]

# # proc `[]=`*[T, U, V, W, X](m: var Matrix[T], r: HSlice[U, V], c: HSlice[W, X],
# #     b: Matrix[T]) =
# #   ## Set a submatrix,
# #   ## ``m[i0 .. i1, j0 .. j1] = a``
# #   let ra = m.nColsRows ^^ r.a
# #   let rb = m.nColsRows ^^ r.b
# #   checkBounds(rb - ra + 1 == b.m, "Subalignment dimensions")
# #   let ca = m.nCols ^^ c.a
# #   let cb = m.nCols ^^ c.b
# #   checkBounds(cb - ca + 1 == b.n, "Subalignment dimensions")
# #   for i in 0 ..< b.m:
# #     for j in 0 ..< b.n:
# #       m[i + ra, j + ca] = b[i, j]

# # proc `[]=`*[T](m: var Matrix[T], r, c: openarray[SomeInteger], b: Matrix[T]) =
# #   ## Set a submatrix,
# #   ## ``m[[0, 2, 3, 4], [1, 2, 3, 4]] = a``
# #   checkBounds(r.len == b.m, "Subalignment dimensions")
# #   checkBounds(c.len == b.n, "Subalignment dimensions")
# #   for i in 0 ..< r.len:
# #     for j in 0 ..< c.len:
# #       m[r[i], c[j]] = b[i, j]

# # proc `[]=`*[T, U, V](m: var Matrix[T], r: HSlice[U, V], c: openarray[
# #     SomeInteger], b: Matrix[T]) =
# #   ## Set a submatrix,
# #   ## ``m[i0 .. i1, [0, 2, 3, 4]] = a``
# #   let ra = m.nColsRows ^^ r.a
# #   let rb = m.nColsRows ^^ r.b
# #   checkBounds(rb - ra + 1 == b.m, "Subalignment dimensions")
# #   checkBounds(c.len == b.n, "Subalignment dimensions")
# #   for i in 0 ..< b.m:
# #     for j in 0 ..< c.len:
# #       m[i + ra, c[j]] = b[i, j]

# # proc `[]=`*[T, U, V](m: var Matrix[T], r: openarray[SomeInteger], c: HSlice[U,
# #     V], b: Matrix[T]) =
# #   ## Set a submatrix,
# #   ## ``m[[0, 2, 3, 4], j0 .. j1] = a``
# #   checkBounds(r.len == b.m, "Subalignment dimensions")
# #   let ca = m.nCols ^^ c.a
# #   let cb = m.nCols ^^ c.b
# #   checkBounds(cb - ca + 1 == b.n, "Subalignment dimensions")
# #   for i in 0 ..< r.len:
# #     for j in 0 ..< b.n:
# #       m[r[i], j + ca] = b[i, j]

# # proc stack*[T](matrices: varargs[Matrix[T]]): Matrix[T] = 
# #   ## Stack matrices together. 
# #   result.nCols = matrices[0].nCols
# #   when compileOption("assertions"):
# #     for m in matrices:
# #       assert(result.nCols == m.nCols, "All matrices must have the same number of columns")
# #   result.nRows = 0
# #   for m in matrices:
# #     result.nRows += m.nRows 
# #   result.data = createData[T](result.nRows * result.nCols)
# #   var pos = 0
# #   for m in matrices:
# #     for i in 0 ..< m.nRows:
# #       for j in 0 ..< m.nCols:
# #         result[pos + i, j] = m[i, j]

# # proc concat*[T](matrices: varargs[Matrix[T]]): Matrix[T] =
# #   result.nRows = matrices[0].nRows
# #   when compileOption("assertions"):
# #     for m in matrices:
# #       assert(result.nRows == m.nRows, "All matrices must have the same number of rows")
# #   result.nCols = 0
# #   for m in matrices:
# #     result.nCols += m.nCols
# #   result.data = createData[T](result.nRows * result.nCols)
# #   var pos = 0
# #   for m in matrices:
# #     for i in 0 ..< m.nRows:
# #       for j in 0 ..< m.nCols:
# #         result[i, pos + j] = m[i, j]
# #     pos += m.nCols

# proc `$`*[T](m: Matrix[T]): string =
#   result = "" 
#   for i in 0 ..< m.r:
#     for j in 0 ..< m.c:
#       result.add($m[i,j])
#     result.add('\n')


# var m = matrix[DNA](4, 5)

# m[0,2] = dnaT
# m[1,2] = dnaG
# m[2,2] = dnaC
# m[3,2] = dnaN



# type
#   Column*[T] = object
#     len, step: int 
#     # data: ptr UncheckedArray[T]
#     data: ptr T

# proc column*[T](m: Matrix[T], c: int): Column[T] = 
#   result = Column[T](len: m.c, step: m.r)
#   # result.data = cast[ptr UncheckedArray[T]](m[0,c].addr)
#   result.data = m[0,c].addr

# var c = m.column(2) 

# # var p = cast[ptr UncheckedArray[DNA]](m[0,2].addr)
# # echo p[0] 

# # proc `[]`*[T](m: Column[T], i: int): T {.inline.} =
# #   ## Get a single element.
# #   checkBounds(i >= 0 and i < m.len)
# #   result = m.data[m.step * i]

# # proc `[]`*[T](m: var Column[T], i: int): var T {.inline.} =
# #   ## Get a single element.
# #   checkBounds(i >= 0 and i < m.len)
# #   # checkBounds(j >= 0 and j < m.c)
# #   m.data[m.step * i]

# # proc `[]=`*[T](m: var Column[T], i: int, s: T) {.inline.} =
# #   ## Set a single element.
# #   checkBounds(i >= 0 and i < m.len)
# #   m.data[m.step * i] = s

# # proc `$`*[T](m: Column[T]): string = 
# #   result = "" 
# #   for i in 0 ..< m.len:
# #     result.add($m[i])
# #     result.add('\n')

