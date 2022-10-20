import ./matrix
export matrix

type
  Alignment*[T] = object
    ids*: seq[string]
    data*: Matrix[T] 

proc newAlignment*[T](nseqs, nchars: int): Alignment[T] = 
  Alignment[T](ids: newSeq[string](nseqs), data: newMatrix[T](nseqs, nchars))

proc nseqs*[T](a: Alignment[T]): int = 
  a.data.rows()

proc nchars*[T](a: Alignment[T]): int = 
  a.data.cols()