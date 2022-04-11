import ./nucleotide
import sequtils

type
  CPointer[T] = ptr UncheckedArray[T]
  Sequence*[T] = ref object
    len: int
    complement: bool 
    data: seq[T]
    step: int
    fp: ptr T 

proc len*[T](s: Sequence[T]): int = 
  s.len

proc sequence*[T](data: seq[T]): Sequence[T] =
  result = Sequence[T](len:data.len, step:1, complement:false)
  shallowCopy(result.data, data)
  result.fp = addr(result.data[0])

proc reverse*[T](s: var Sequence[T]) = 
  let sp = cast[CPointer[T]](s.fp) 
  s.fp = addr(sp[s.step * (s.len - 1)])
  s.step = s.step * -1 

proc complement*[T](s: var Sequence[T]) = 
  if s.complement: 
    s.complement = false
  else: 
    s.complement = true

proc reverseComplement*[T](s: var Sequence[T]) = 
  complement(s)
  reverse(s)

iterator items*[T](s: Sequence[T]): auto {. inline .} =
  let sp = cast[CPointer[T]](s.fp)
  var pos = 0
  if s.complement:
    for i in 0 ..< s.len:
      yield sp[pos].complement
      pos += s.step
  else:
    for i in 0 ..< s.len:
      yield sp[pos]
      pos += s.step


############################
# Single Pointer Alignment
type
  SPAlignment*[T] = ref object
    nseq: int
    nchar: int
    complement: bool 
    data: seq[T]
    step: int
    fp: ptr T 

proc nseq*[T](a: SPAlignment[T]): int = 
  a.nseq

proc nchar*[T](a: SPAlignment[T]): int = 
  a.nchar

proc spalignment*[T](nseq, nchar: int, data: seq[T]): SPAlignment[T] = 
  result = SPAlignment[T](nseq:nseq, nchar:nchar, step:1, complement:false)
  shallowCopy(result.data, data)
  result.fp = addr(result.data[0])

proc reverse*[T](a: var SPAlignment[T]) = 
  let ap = cast[CPointer[T]](a.fp)
  a.fp = addr(ap[a.step * (a.nchar - 1)])
  a.step = a.step * -1

proc complement*[T](a: var SPAlignment[T]) = 
  if a.complement: 
    a.complement = false
  else: 
    a.complement = true

proc reverseComplement*[T](a: var SPAlignment[T]) = 
  complement(a)
  reverse(a)

iterator items*[T](a: SPAlignment[T]): auto {. inline .} = 
  let ap = cast[CPointer[T]](a.fp)
  var pos: int
  if a.complement:
    for i in 0 ..< a.nseq: 
     pos = 0
     for j in 0 ..< a.nchar: 
       yield ap[i * a.nchar + pos].complement
       pos += a.step
  else:
    for i in 0 ..< a.nseq: 
      pos = 0
      for j in 0 ..< a.nchar: 
        yield ap[i * a.nchar + pos]
        pos += a.step


############################
# Alignment
type
  Alignment*[T] = ref object
    nseq: int
    nchar: int
    complement: seq[bool] 
    data: seq[T]
    steps: seq[int]
    fp: seq[ptr T]

proc nseq*[T](a: Alignment[T]): int = 
  a.nseq

proc nchar*[T](a: Alignment[T]): int = 
  a.nchar

proc alignment*[T](nseq, nchar: int, data: seq[T]): Alignment[T] = 
  result = Alignment[T](nseq:nseq, nchar:nchar, steps:repeat(1, nseq), complement:repeat(false, nseq), fp:newSeq[ptr T](nseq))
  shallowCopy(result.data, data)
  for i in 0 ..< nseq:
    result.fp[i] = addr(result.data[i * nchar])  

proc reverse*[T](a: var Alignment[T]) = 
  var ap: CPointer[T] 
  for i in 0 ..< a.nseq:
    ap = cast[CPointer[T]](a.fp[i]) 
    a.fp[i] = addr(ap[a.steps[i] * (a.nchar - 1)])  
    a.steps[i] = a.steps[i] * -1

proc complement*[T](a: var Alignment[T]) = 
  for i in 0 ..< a.nseq:
    if a.complement[i] == true: 
      a.complement[i] = false
    else: 
      a.complement[i] = true

proc reverseComplement*[T](a: var Alignment[T]) = 
  complement(a)
  reverse(a)

iterator items*[T](a: Alignment[T]): auto {. inline .} = 
  var 
    ap: CPointer[T]
  for i in 0 ..< a.nseq: 
    ap = cast[CPointer[T]](a.fp[i])
    for j in 0 ..< a.nchar: 
      if a.complement[i] == true: 
        yield ap[j].complement
      else: 
        yield ap[j]

