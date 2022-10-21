import ./nucleotide
import ./seqRecord
import std/streams
import std/strutils
import std/strformat
import std/sequtils

## An iterator for reading the headers and sequence data from a fasta file.
runnableExamples:
  var str = """
  >Sample1
  ATGCATGC
  
  >Sample2
  TTGCATGC
  """
  for i in iterFastaString(str, DNA):
    echo i
  # Sample1 ATGCATGC
  # Sample2 TTGCATGC

type
  FastaError* = object of CatchableError

iterator iterFastaStream*(stream: Stream, typ: typedesc): SeqRecord[typ] =
  mixin parseChar
  var 
    sequence: SeqRecord[typ]
    sequenceFragments: seq[seq[typ]]
    lineNum = 0
    line = ""
    empty = true
  while stream.readLine(line):
    lineNum += 1
    if line.isEmptyOrWhitespace():
      continue
    if line.startsWith('>'):
      sequence = SeqRecord[typ](id:line[1..^1])
      empty = false
      break 
    else:
      raise newException(FastaError, fmt"Expected description at line {lineNum} but got: {line}")
  while stream.readLine(line):
    lineNum += 1 
    if line.isEmptyOrWhitespace():
      continue
    if line.startsWith('>'):
      sequence.data = concat(sequenceFragments)
      yield sequence
      sequence = SeqRecord[typ](id:line[1..^1])
      sequenceFragments.setLen(0)
    else:
      var 
        seqString = line.replace(" ", "")  
        seqFragment = newSeq[typ](seqString.len)
      for i in 0 ..< seqString.len:
        try:
          seqFragment[i] = parseChar(seqString[i], typ)
        except ValueError:
          raise newException(FastaError, fmt"Invalid {$typ} character '{seqString[i]}' at line {lineNum}")
      sequenceFragments.add(seqFragment)
      
  if empty: 
    raise newException(FastaError, "Empty Fasta stream")
  sequence.data = concat(sequenceFragments)
  yield sequence

iterator iterFastaString*(str: string, typ: typedesc): SeqRecord[typ] =  
  var ss = newStringStream(str)
  for i in iterFastaStream(ss, typ):
    yield i
  ss.close()

iterator iterFastaFile*(path: string, typ: typedesc): SeqRecord[typ] =  
  var fs = newFileStream(path)
  for i in iterFastaStream(fs, typ):
    yield i
  fs.close()