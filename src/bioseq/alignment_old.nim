import ./nucleotide
# # # import ./sequence
# import std/algorithm
import std/sequtils
import std/random
# import std/strutils


type
  Sequence*[T] = ref object
    data: seq[T]
    fp: ptr T 
    len: int
    step: int

  Alignment*[T] = ref object
    nseq: int
    nchar: int
    fp: ptr T 
    data: seq[T]

  Column*[T] = ref object
    data: seq[T]
    fp: ptr T
    len: int
    step: int

  CPointer[T] = ptr UncheckedArray[T]
  DimensionError* = object of ValueError
  OutOfBoundsError* = object of ValueError

template checkDim*(cond: untyped, msg = "") =
  when compileOption("assertions"):
    {.line.}:
      if not cond:
        raise newException(DimensionError, msg)

template checkBounds*(cond: untyped, msg = "") =
  when compileOption("assertions"):
    {.line.}:
      if not cond:
        raise newException(OutOfBoundsError, msg)

proc isFull*(s: Sequence): bool {.inline.} =
  s.len == s.data.len

proc isFull*(a: Alignment): bool {.inline.} =
  a.data.len == a.nseq * a.nchar

# proc slowEq[A](v, w: Vector[A]): bool =
#   if v.len != w.len:
#     return false
#   let
#     vp = cast[CPointer[A]](v.fp)
#     wp = cast[CPointer[A]](w.fp)
#   for i in 0 ..< v.len:
#     if vp[i * v.step] != wp[i * w.step]:
#       return false
#   return true

# proc slowEq[A](m, n: Matrix[A]): bool =
#   if m.M != n.M or m.N != n.N:
#     return false
#   let
#     mp = cast[CPointer[A]](m.fp)
#     np = cast[CPointer[A]](n.fp)
#   for i in 0 ..< m.M:
#     for j in 0 ..< m.N:
#       let
#         mel = if m.order == colMajor: mp[j * m.ld + i] else: mp[i * m.ld + j]
#         nel = if n.order == colMajor: np[j * n.ld + i] else: np[i * n.ld + j]
#       if mel != nel:
#         return false
#   return true

# proc `==`*[A](v, w: Vector[A]): bool =
#   if v.isFull and w.isFull:
#     v.data == w.data
#   else:
#     slowEq(v, w)

# proc `==`*[A](m, n: Matrix[A]): bool =
#   if m.isFull and n.isFull and m.order == n.order:
#     m.data == n.data
#   else:
#     slowEq(m, n)

proc sequence*[T](data: seq[T]): Sequence[T] =
  result = Sequence[T](step: 1, len: data.len)
  shallowCopy(result.data, data)
  result.fp = addr(result.data[0])

proc sequence*[T](data: varargs[T]): Sequence[T] =
  sequence[T](@data)

proc stackVector*[N: static[int], T](a: var array[N, T]): Sequence[T] =
  Sequence[T](fp: addr a[0], len: N, step: 1)

proc sharedVector*(N: int, T: typedesc): Sequence[T] =
  Sequence[T](fp: cast[ptr T](allocShared0(N * sizeof(T))), len: N, step: 1)

proc dealloc*[T](s: Sequence[T]) =
  deallocShared(cast[pointer](s.fp))

proc makeSequence*[T](N: int, f: proc (i: int): T): Sequence[T] =
  result = sequence(newSeq[T](N))
  for i in 0 ..< N:
    result.data[i] = f(i)

# template makeVectorI*[A](N: int, f: untyped): Vector[A] =
#   var result = vector(newSeq[A](N))
#   for i {.inject.} in 0 ..< N:
#     result.data[i] = f
#   result

# proc randomVector*(N: int, max: float64 = 1): Vector[float64] =
#   makeVectorI[float64](N, rand(max))

# proc randomVector*(N: int, max: float32): Vector[float32] =
#   makeVectorI[float32](N, rand(max).float32)

proc alignment*[T](nseq, nchar: int, data: seq[T]): Alignment[T] =
  result = Alignment[T](
    nseq: nseq,
    nchar: nchar)
  shallowCopy(result.data, data)
  result.fp = addr(result.data[0])

# proc makeMatrix*[A](M, N: int, f: proc (i, j: int): A, order = colMajor): Matrix[A] =
#   result = matrix[A](order, M, N, newSeq[A](M * N))
#   if order == colMajor:
#     for i in 0 ..< M:
#       for j in 0 ..< N:
#         result.data[j * M + i] = f(i, j)
#   else:
#     for i in 0 ..< M:
#       for j in 0 ..< N:
#         result.data[i * N + j] = f(i, j)

# template makeMatrixIJ*(A: typedesc, M1, N1: int, f: untyped, ord = colMajor): auto =
#   var r = matrix[A](ord, M1, N1, newSeq[A](M1 * N1))
#   if ord == colMajor:
#     for i {.inject.} in 0 ..< M1:
#       for j {.inject.} in 0 ..< N1:
#         r.data[j * M1 + i] = f
#   else:
#     for i {.inject.} in 0 ..< M1:
#       for j {.inject.} in 0 ..< N1:
#         r.data[i * N1 + j] = f
#   r

# proc randomMatrix*[A: SomeFloat](M, N: int, max: A = 1, order = colMajor): Matrix[A] =
#   result = matrix[A](order, M, N, newSeq[A](M * N))
#   for i in 0 ..< (M * N):
#     result.data[i] = rand(max)

# proc randomMatrix*(M, N: int, order = colMajor): Matrix[float64] =
#   randomMatrix(M, N, 1'f64, order)

proc randomAlignment*[T](nseq, nchar: int, chars: seq[T] = @[T(0), T(1), T(2), T(3)]): Alignment[T] =
  result = alignment[T](nseq, nchar, newSeq[T](nseq * nchar))
  for i in 0 ..< result.data.len:
    result.data[i] = sample(chars) 

# proc matrix*[A](xs: seq[seq[A]], order = colMajor): Matrix[A] =
#   when compileOption("assertions"):
#     for x in xs:
#       checkDim(xs[0].len == x.len, "The dimensions do not match")
#   makeMatrixIJ(A, xs.len, xs[0].len, xs[i][j], order)

# proc matrix*[A](xs: seq[Vector[A]], order = colMajor): Matrix[A] =
#   when compileOption("assertions"):
#     for x in xs:
#       checkDim(xs[0].len == x.len, "The dimensions do not match")
#   makeMatrixIJ(A, xs.len, xs[0].len, xs[i][j], order)

# proc stackMatrix*[M, N: static[int]](a: var DoubleArray32[M, N], order = colMajor): Matrix[float32] =
#   let M1: int = if order == colMajor: N else: M
#   let N1: int = if order == colMajor: M else: N
#   result = Matrix[float32](
#     order: order,
#     fp: addr a[0][0],
#     M: M1,
#     N: N1,
#     ld: N
#   )

# proc stackMatrix*[M, N: static[int]](a: var DoubleArray64[M, N], order = colMajor): Matrix[float64] =
#   let M1: int = if order == colMajor: N else: M
#   let N1: int = if order == colMajor: M else: N
#   Matrix[float64](
#     order: order,
#     fp: addr a[0][0],
#     M: M1,
#     N: N1,
#     ld: N
#   )

# proc sharedMatrix*(M, N: int, A: typedesc, order = colMajor): Matrix[A] =
#   Matrix[A](
#     order: order,
#     fp: cast[ptr A](allocShared0(M * N * sizeof(A))),
#     M: if order == colMajor: N else: M,
#     N: if order == colMajor: M else: N,
#     ld: N
#   )

# proc dealloc*[A](m: Matrix[A]) =
#   deallocShared(cast[pointer](m.fp))

# template elColMajor(ap, a, i, j: untyped): untyped =
#   ap[j * a.ld + i]

# template elRowMajor(ap, a, i, j: untyped): untyped =
#   ap[i * a.nseq + j]

proc `[]`*[T](s: Sequence[T], i: int): T {. inline .} =
  checkBounds(i >= 0 and i < s.len)
  return cast[CPointer[T]](s.fp)[s.step * i]

proc `[]`*[T](s: var Sequence[T], i: int): var T {. inline .} =
  checkBounds(i >= 0 and i < s.len)
  return cast[CPointer[T]](s.fp)[s.step * i]

proc `[]=`*[T](s: Sequence[T], i: int, val: T) {. inline .} =
  checkBounds(i >= 0 and i < s.len)
  cast[CPointer[T]](s.fp)[s.step * i] = val

proc `[]`*[T](a: Alignment[T], row, col: int): T {. inline .} =
  checkBounds(row >= 0 and row < a.nseq)
  checkBounds(col >= 0 and col < a.nchar)
  let mp = cast[CPointer[T]](a.fp)
  return mp[row * a.nchar + col]

proc `[]`*[T](a: var Alignment[T], row, col: int): var T {. inline .} =
  checkBounds(row >= 0 and row < a.nseq)
  checkBounds(col >= 0 and col < a.nchar)
  let mp = cast[CPointer[T]](a.fp)
  return mp[row * a.nchar + col]

proc `[]=`*[T](a: var Alignment[T], row, col: int, val: T) {. inline .} =
  checkBounds(row >= 0 and row < a.nseq)
  checkBounds(col >= 0 and col < a.nchar)
  let mp = cast[CPointer[T]](a.fp)
  mp[row * a.nchar + col] = val

proc column*[T](a: Alignment[T], col: int): Column[T] {. inline .} =
  checkBounds(col >= 0 and col < a.nchar)
  let ap = cast[CPointer[T]](a.fp)
  result = Column[T](
    data: a.data,
    fp: addr(ap[col]),
    len: a.nseq,
    step: a.nchar)

proc row*[T](a: Alignment[T], row: int): Sequence[T] {. inline .} =
  checkBounds(row >= 0 and row < a.nseq)
  let ap = cast[CPointer[T]](a.fp)
  result = Sequence[T](
    data: a.data,
    fp: addr(ap[row * a.nchar]),
    len: a.nchar,
    step: 1)

iterator items*[T](s: Sequence[T]): auto {. inline .} =
  let sp = cast[CPointer[T]](s.fp)
  var pos = 0
  for i in 0 ..< s.len:
    yield sp[pos]
    pos += s.step

iterator pairs*[T](s: Sequence[T]): auto {. inline .} =
  let sp = cast[CPointer[T]](s.fp)
  var pos = 0
  for i in 0 ..< s.len:
    yield (i, sp[pos])
    pos += s.step

iterator items*[T](c: Column[T]): auto {. inline .} =
  let cp = cast[CPointer[T]](c.fp)
  var pos = 0
  for i in 0 ..< c.len:
    yield cp[pos]
    pos += c.step

iterator pairs*[T](c: Column[T]): auto {. inline .} =
  let cp = cast[CPointer[T]](c.fp)
  var pos = 0
  for i in 0 ..< c.len:
    yield (i, cp[pos])
    pos += c.step

iterator columns*[T](a: Alignment[T]): auto {. inline .} =
  let
    mp = cast[CPointer[T]](a.fp)
  var col = a.column(0)
  yield col 
  for i in 1 ..< a.nchar:
    col.fp = addr(mp[i * 1])
    yield col 

iterator rows*[T](a: Alignment[T]): auto {. inline .} =
  let
    mp = cast[CPointer[T]](a.fp)
  var row = a.row(0)
  yield row 
  for i in 1 ..< a.nseq:
    row.fp = addr(mp[i * a.nchar])
    yield row 

iterator columnsSlow*[T](a: Alignment[T]): auto {. inline .} =
  for i in 0 ..< a.nchar:
    yield a.column(i)

iterator rowsSlow*[T](a: Alignment[T]): auto {. inline .} =
  for i in 0 ..< a.nseq:
    yield a.row(i)

iterator items*[T](a: Alignment[T]): auto {. inline .} =
  let mp = cast[CPointer[T]](a.fp)
  for row in 0 ..< a.nseq:
    for col in 0 ..< a.nchar:
      yield mp[row * a.nchar + col] 

iterator pairs*[T](a: Alignment[T]): auto {. inline .} =
  let mp = cast[CPointer[T]](a.fp)
  for row in 0 ..< a.nseq:
    for col in 0 ..< a.nchar:
      yield ((row, col), mp[row * a.nchar + col])

proc clone*[T](s: Sequence[T]): Sequence[T] =
  if s.isFull:
    var dataCopy = s.data
    return sequence(dataCopy)
  else:
    return sequence(toSeq(s.items))

proc clone*[T](a: Alignment[T]): Alignment[T] =
  if a.isFull:
    var dataCopy = a.data
    result = alignment[T](a.nseq, a.nchar, dataCopy)
  else:
    result = alignment(a.nseq, a.nchar, newSeq[T](a.nseq * a.nchar))
    # TODO: copy one row or column at a time, comment in Neo package
    for t, v in a:
      let (i, j) = t
      result[i, j] = v

# proc map*[A, B](v: Vector[A], f: proc(x: A): B): Vector[B] =
#   result = zeros(v.len, B)
#   for i, x in v:
#     result.data[i] = f(x) # `result` is full here, we can assign `data` directly

# proc map*[A, B](m: Matrix[A], f: proc(x: A): B): Matrix[B] =
#   result = zeros(m.M, m.N, B, m.order)
#   if m.isFull:
#     for i in 0 ..< (m.M * m.N):
#       result.data[i] = f(m.data[i])
#   else:
#     for t, v in m:
#       let (i, j) = t
#       # TODO: make things faster here
#       result[i, j] = f(v)

proc `$`*[T](s: Sequence[T]): string =
  result = ""
  for i in s:
    result.add(i.char)

proc `$`*[T](c: Column[T]): string =
  result = ""
  for i in c: 
    result.add(i.char)
    result.add("\n")

proc `$`*[T](a: Alignment[T]): string =
  result = ""
  for i in 0 ..< a.nseq: 
    for j in 0 ..< a.nchar:
      result.add(a.data[i * a.nchar + j].char)
    result.add("\n")

# proc asMatrix*[A](v: Vector[A], a, b: int, order = colMajor): Matrix[A] =
#   if v.isFull:
#     checkDim(v.len == a * b, "The dimensions do not match: N = " & $(v.len) & ", A = " & $(a) & ", B = " & $(b))
#     result = matrix(
#       order = order,
#       M = a,
#       N = b,
#       data = v.data
#     )
#   else:
#     result = v.clone().asMatrix(a, b, order)

# proc asVector*[A](m: Matrix[A]): Vector[A] =
#   if m.isFull:
#     vector(m.data)
#   else:
#     vector(toSeq(m.items))

# # Stacking

proc hstack*[T](seqs: varargs[Sequence[T]]): Sequence[T] =
  var L = 0
  for i in seqs:
    L += i.len
  result = Sequence(newSeq[T](L))
  var pos = 0
  for s in seqs:
    for j, x in s:
      result.data[pos + j] = x
    pos += s.len

template concat*[T](seqs: varargs[Sequence[T]]): Sequence[T] =
  hstack(seqs)

template vstack*[T](seqs: varargs[Sequence[T]]): Alignment[T] =
  alignment(@seqs)

proc hstack*[T](alignments: varargs[Alignment[T]]): Alignment[T] =
  let R = alignments[0].nseq
  when compileOption("assertions"):
    for a in alignments:
      checkDim(R == a.nseq, "The vertical dimensions do not match")
  var C = 0
  for a in alignments:
    C += a.nchar 
  result = alignment[T](R, C, newSeq[T](R * C))
  var pos = 0
  for a in alignments:
    for row in 0 ..< a.nseq:
      for col in 0 ..< a.nchar:
        result[row, pos + col] = a[row, col]
    pos += a.nchar 

proc vstack*[T](alignments: varargs[Alignment[T]]): Alignment[T] =
  let C = alignments[0].nchar
  when compileOption("assertions"):
    for a in alignments:
      checkDim(C == a.nchar, "The horizontal dimensions do not match")
  var R = 0
  for a in alignments:
    R += a.nseq 
  result = alignment[T](R, C, newSeq[T](R * C))
  var pos = 0
  for a in alignments:
    for row in 0 ..< a.nseq:
      for col in 0 ..< a.nchar:
        result[pos + row, col] = a[row, col]
    pos += a.nseq 


proc pointerAt[T](s: Sequence[T], i: int): ptr T {. inline .} =
  let p = cast[CPointer[T]](s.fp)
  addr p[i]

# proc `[]`*[A](v: Vector[A], s: Slice[int]): Vector[A] {. inline .} =
#   Vector[A](data: v.data, fp: v.pointerAt(s.a), step: v.step, len: s.b - s.a + 1)

# proc `[]=`*[A](v: var Vector[A], s: Slice[int], val: Vector[A]) {. inline .} =
#   checkBounds(s.a >= 0 and s.b < v.len)
#   checkDim(s.b - s.a + 1 == val.len)
#   when A is SomeFloat:
#     copy(val.len, val.fp, val.step, v.pointerAt(s.a), v.step)
#   else:
#     var count = 0
#     for i in s:
#       v[i] = val[count]
#       count += 1

type All* = object

proc `[]`*[T](a: Alignment[T], rows, cols: Slice[int]): Alignment[T] =
  checkBounds(rows.a >= 0 and rows.b < a.nseq)
  checkBounds(cols.a >= 0 and cols.b < a.ncol)
  let
    mp = cast[CPointer[T]](a.fp)
    fp = addr(mp[rows.a * a.nseq + cols.a])
  result = Alignment[T](
    nseq: (rows.b - rows.a + 1),
    nchar: (cols.b - cols.a + 1),
    data: a.data,
    fp: fp)

proc `[]`*[T](a: Alignment[T], rows: Slice[int], cols: typedesc[All]): Alignment[T] =
  a[rows, 0 ..< a.nchar]

proc `[]`*[T](a: Alignment[T], rows: typedesc[All], cols: Slice[int]): Alignment[T] =
  a[0 ..< a.nseq, cols]

proc `[]=`*[T](a: var Alignment[T], rows, cols: Slice[int], val: Alignment[T]) {. inline .} =
  checkBounds(rows.a >= 0 and rows.b < a.nseq)
  checkBounds(cols.a >= 0 and cols.b < a.nchar)
  checkDim(rows.len == val.nseq)
  checkDim(cols.len == val.nchar)
  let
    mp = cast[CPointer[T]](a.fp)
    vp = cast[CPointer[T]](val.fp)
  var row = 0
  var col = 0
  for r in rows:
    col = 0
    for c in cols:
      mp[r * a.nseq + c] = vp[row * val.nseq + col] 
      col += 1
    row += 1

proc `[]=`*[T](a: var Alignment[T], rows: Slice[int], cols: typedesc[All], val: Alignment[T]) {. inline .} =
  a[rows, 0 ..< a.nchar] = val

proc `[]=`*[T](a: var Alignment[T], rows: typedesc[All], cols: Slice[int], val: Alignment[T]) {. inline .} =
  a[0 ..< a.nseq, cols] = val





var 
  a = randomAlignment[DNA](2, 2)
  b = randomAlignment[DNA](2, 2)


echo a
echo b

echo hstack(a,b)

echo vstack(a,b)

