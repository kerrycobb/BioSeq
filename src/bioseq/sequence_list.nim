import ./nucleotide
import ./sequence
import std/algorithm
import std/sequtils
import std/strutils

type
  SequenceList*[T] = ref object
    nseqs*: int
    seqs: seq[Sequence[T]]

iterator items*[T](list: var SequenceList[T]): Sequence[T] = 
  for i in list.seqs:
    yield i

proc `$`*[T](l: SequenceList[T]): string = 
  result = ""
  var idLen = 0  
  for s in l.seqs:
    if s.id.len > idLen: 
      if s.id.len > 10:
        idLen = 10
        break
      else:
        idLen = s.id.len
  for i, s in l.seqs:   
    if s.id.len > idLen:
      result.add(s.id[0 .. idLen - 4])
      result.add("...")
    else:
      result.add(s.id)
      result.add(repeat(' ', idLen - s.id.len))
    result.add(": ")
    var
      max = s.data.len 
      ellipse = false 
    if s.data.len + idLen > 78: 
      max = 75 - idLen
      ellipse = true
    for j in 0 ..< max:
      result.add(s.data[j].char)
    if ellipse:
      result.add("...")
    if i < l.nseqs: 
      result.add("\n")

proc add*[T](list: var SequenceList[T], seqs: varargs[Sequence[T]]) = 
  if list.isNil:
    list = SequenceList[T]()  
  for i in seqs:
    list.seqs.add(i)
    list.nseqs.inc

# proc concat*[T](l1: var SequenceList[T], l2: SequenceList[T]) = 

proc complement*[T](list: var SequenceList[T]) = 
  for i in list: 
    i.complement 

proc reverse*[T](list: var SequenceList[T]) =
  for i in list: 
    i.reverse 

proc reverseComplement*[T](list: var SequenceList[T]) = 
  for i in list: 
    i.reverseComplement 

proc getComplement*[T](list: SequenceList[T]): SequenceList[T] = 
  result = list
  result.complement

proc getReversed*[T](list: SequenceList[T]): SequenceList[T] = 
  result = list
  result.reverse

proc getReverseComplement*[T](list: SequenceList[T]): SequenceList[T] = 
  result = list
  result.reverseComplement