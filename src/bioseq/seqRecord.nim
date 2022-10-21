

type
  SeqRecord*[T] = object
    id*: string
    data*: seq[T]

proc `$`*[T](s: SeqRecord[T]): string = 
  result.add(s.id, " ", $s.data)