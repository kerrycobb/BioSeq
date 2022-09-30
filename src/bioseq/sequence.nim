import ./nucleotide
# import std/algorithm
# import std/sequtils
# import std/random

type
  Sequence*[M, T] = object
    meta*: M
    data*: T

# type
#   Sequence*[T] = ref object
#     id*: string
#     data: seq[T]

# iterator items*[T](sequence: var Sequence[T]): T =  
#   for i in sequence.data: 
#     yield i

# # proc `$`*[T](s: Sequence[T]): string = 
# #   result = ""
# #   if s.id.len > 10:
# #     result.add(s.id[0..9])
# #     result.add("...: ")
# #   else:
# #     result.add(s.id)
# #     result.add(": ")
# #   if result.len + s.data.len > 80:
# #     for i in 0 ..< 77 - result.len:   
# #       result.add(s.data[i].char)
# #     result.add("...")
# #   else:
# #     for i in 0 ..< s.data.len:
# #       result.add(s.data[i].char)

# # proc len*[T](s: Sequence[T]): int = s.data.len
# #   ## Returns number of nucleotides in the sequence

# proc newSequence*[T](id: string, nchars: int): Sequence[T] = 
#   result = Sequence[T](id: id, data: newSeq[T](nchars)) 

# proc newSequence*[T](nchars: int): Sequence[T] = 
#   result = newSequence[T]("", nchars)




# # proc randomSequence*[T](id: string, nchars: int, chars: openArray[T] = @[T(0)..T(3)]): Sequence[T] = 
# #   result = newSequence[T](id, nchars)
# #   for i in 0 ..< nchars:
# #     result.data[i] = sample(chars)

# # proc randomSequence*[T](nchars: int, chars: openArray[T] = @[T(0)..T(3)]): Sequence[T] = 
# #   result = randomSequence("", nchars, chars)

# # proc sequenceFromString*[T](id, str: string): Sequence[T] = 
# #   result = Sequence[T](id:id, data:newSeq[T](str.len))
# #   for i, c in str:
# #     result.data[i] = parseChar(c, T) 

# # proc sequenceFromString*[T](str: string): Sequence[T] = 
# #   result = sequenceFromString[T]("", str) 

# # proc add*[T](sequence: var Sequence[T], chars: varargs[char]) = 
# #   for i in chars:
# #     sequence.data.add(i.parseChar(T))

# # proc add*[T](sequence: var Sequence[T], chars: varargs[enum]) =  
# #   for i in chars:
# #     sequence.data.add(i)

# # # proc concat*[T](s1: var Sequence[T], s2: Sequence[T]) = 

# # proc complement*[T](sequence: var Sequence[T]) = 
# #   for i in sequence: 
# #     i.complement 

# # proc reverse*[T](sequence: var Sequence[T]) = 
# #   sequence.data.reverse

# # proc reverseComplement*[T](sequence: var Sequence[T]) = 
# #   sequence.reverse
# #   for i in sequence: 
# #     i.complement 

# # proc getComplement*[T](sequence: Sequence[T]): Sequence[T] = 
# #   result = sequence
# #   result.complement

# # proc getReverse*[T](sequence: Sequence[T]): Sequence[T] =
# #   result = sequence
# #   result.reverse

# # proc getReverseComplement*[T](sequence: Sequence[T]): Sequence[T] = 
# #   result = sequence
# #   result.reverseComplement