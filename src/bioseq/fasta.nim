# import ./nucleotide
import ./seqRecord
import std/streams
import std/strutils
import std/strformat
import std/sequtils

## An iterator for reading the headers and sequence data from a fasta file.
runnableExamples:
  import bioseq
  import std/strutils
  var str = """
  >Sample1
  ATGCATGC
  
  >Sample2
  TTGCATGC
  """.dedent
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
    if line.isEmptyOrWhitespace:
      continue
    if line.startsWith('>'):
      sequence = SeqRecord[typ](id:line[1..^1])
      empty = false
      break 
    else:
      raise newException(FastaError, &"Expected line beginning with '>' at {lineNum} but got: \"{line}\"")
  while stream.readLine(line):
    lineNum += 1 
    if line.isEmptyOrWhitespace:
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
  ## Iterate over records in a Fasta string 
  var ss = newStringStream(str)
  for i in iterFastaStream(ss, typ):
    yield i
  ss.close

iterator iterFastaFile*(path: string, typ: typedesc): SeqRecord[typ] =  
  ## Iterate over records in a Fasta file
  var fs = newFileStream(path)
  for i in iterFastaStream(fs, typ):
    yield i
  fs.close

# import std/math

proc toFastaString*[T](s: SeqRecord[T], lineLength = 80): string = 
  ## Returns string in Fasta format
  var 
    nLines = (s.data.len + lineLength - 1) div lineLength 
  result = newStringOfCap(s.id.len + s.data.len + nLines + 1) 
  result.add('>')
  result.add(s.id)
  result.add('\n')
  var endIx: int
  for i in 0 ..< nLines - 1:
    let startIx = i * lineLength 
    endIx = startIx + lineLength
    for j in startIx ..< endIx:
      result.add(s.data[j].toChar)
    result.add('\n')
  for j in endIx ..< s.data.len:
    result.add(s.data[j].toChar)
  result.add('\n')

proc toFastaString*[T](s: seq[SeqRecord[T]], lineLength = 80): string = 
  ## Returns string in Fasta format
  for i in s:
    result.add(i.toFastaString)

proc toFastaFile*[T](s: SeqRecord[T], path: string, mode: FileMode = fmWrite, 
  # Writes data to file in Fasta format. Use fmAppend to append rather than overwrite.
    lineLength = 80) =  
  var fh = open(path, mode)
  fh.write(s.toFastaString, lineLength)
  fh.close

proc toFastaFile*[T](s: seq[SeqRecord[T]], path: string, mode: FileMode = fmWrite, 
  # Writes data to file in Fasta format. Use fmAppend to append rather than overwrite.
    lineLength = 80) = 
  var fh = open(path, mode)
  for i in s:
    fh.write(i.toFastaString, lineLength)
  fh.close