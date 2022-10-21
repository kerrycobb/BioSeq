import std/strutils
import ./sequence

type
  SeqRecord*[T] = object
    id*: string
    data*: seq[T]

proc `$`*[T](s: SeqRecord[T]): string = 
  result = [s.id, " ", s.data.toString].join()