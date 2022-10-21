import ./alignment
import ./nucleotide
import ./aminoAcid
import std/streams
import std/strutils
import std/strformat

## Procs for reading and writing DNA alignments in Phylip format
runnableExamples:
  import bioseq
  let 
    str = """
      2 8
      Sample1 ATGC
      Sample2 TTGC
      ATGC
      ATGC
      2 8
      Sample3 GTGC
      Sample4 CTGC
      ATGC
      ATGC
      """
    a = parsePhylipString(str, DNA, Interleaved)
  echo a
  # Sample1 ATGCATGC
  # Sample2 TTGCATGC

  for i in iterPhylipString(str, DNA, Interleaved): 
    echo i
  # Sample1 ATGCATGC
  # Sample2 TTGCATGC
  # Sample3 GTGCATGC
  # Sample4 CTGCATGC

## ```Nim
## let a = parsePhylipFile("input.phy", DNA, Sequential)
## ```

type
  PhylipFormat* = enum Interleaved, Sequential

  PhylipError* = object of CatchableError

  PhylipState = enum phyStart, phyInterleavedStart, phyInterleaved, 
      phySequentialStart, phySequential, phyEnd, phyEOF

  PhylipParser[T] = object
    alignment: Alignment[T]
    format: PhylipFormat
    stream: Stream
    lineNum: int
    state: PhylipState 

proc parsePhylipAlignment[T](p: var PhylipParser[T], allowEmpty=false) = 
  mixin parseChar
  var 
    line = ""
    currentTaxon = 0
    currentLen = 0
    cumLen = 0
  p.state = phyStart
  while p.stream.readLine(line):
    p.lineNum += 1
    if line.isEmptyOrWhitespace: # Skip empty lines. Stop current loop here.
      continue
    case p.state
    of phyStart: # Parse header
      var 
        dimensions = line.strip.split 
        nseqs: int
        nchars: int
      if dimensions.len != 2:
        raise newException(PhylipError, fmt"Expected dimension at line {p.lineNum}")
      try:  
        nseqs = parseInt(dimensions[0])
        nchars = parseInt(dimensions[1])
      except:
        raise newException(PhylipError, fmt"Could not parse dimensions at line {p.lineNum}")
      if nseqs < 2:
        raise newException(PhylipError, fmt"Expected at least two sequences at line {p.lineNum}")
      if nchars < 1:
        raise newException(PhylipError, fmt"Expected at least one character at line {p.lineNum}")
      p.alignment = newAlignment[T](nseqs, nchars)
      case p.format
      of Interleaved:
        p.state = phyInterleavedStart
      of Sequential:
        p.state = phySequentialStart 

    of phyInterleavedStart: # Parse first block of interleaved file
      var parts = line.strip.split(maxsplit=1)
      if parts.len != 2: 
        raise newException(PhylipError, fmt"Expected ID and sequence at line {p.lineNum}")
      var
        id = parts[0]
        sequence = parts[1].replace(" ", "")
      if currentTaxon == 0:
        currentLen = sequence.len 
      elif sequence.len != currentLen:
        raise newException(PhylipError, fmt"Line lengths within block must be equal at line {p.lineNum}")
      p.alignment.ids[currentTaxon] = id 
      for i in 0 ..< sequence.len:
        try:
          p.alignment.data[currentTaxon, i] = parseChar(sequence[i], T)
        except ValueError:
          raise newException(PhylipError, fmt"Invalid {$T} character '{sequence[i]}' at line {p.lineNum}. Header may not match data")
      if currentTaxon == p.alignment.nseqs - 1: 
        cumLen += sequence.len 
        if cumLen == p.alignment.nchars: 
          p.state = phyEnd
          break
        else:
          p.state = phyInterleaved
          currentTaxon = 0
      else:
        currentTaxon += 1
    
    of phyInterleaved: # Parse remaining blocks of interleaved file
      var sequence = line.replace(" ", "")
      if currentTaxon == 0:
        currentLen = sequence.len
      elif currentLen != sequence.len:
        raise newException(PhylipError, fmt"Line lengths within block must be equal at line {p.lineNum}. Header may not match data")
      for i in 0 ..< sequence.len:
        try:
          p.alignment.data[currentTaxon, cumLen + i] = parseChar(sequence[i], T)
        except ValueError:
          raise newException(PhylipError, fmt"Invalid {$T} character '{sequence[i]}' at line {p.lineNum}")

      if currentTaxon == p.alignment.nseqs - 1: 
        cumLen += sequence.len
        if cumLen == p.alignment.nchars: 
          p.state = phyEnd
          break
        else:
          currentTaxon = 0
      else:
        currentTaxon += 1
    
    of phySequentialStart: # Parse first line of sequential sequence 
      let 
        stripped = line.strip 
        parts = stripped.split(maxsplit=1)
      if parts.len != 2: 
        raise newException(PhylipError, fmt"Expected ID and sequence at line {p.lineNum}")
      var
        id = parts[0]
        sequence = parts[1].replace(" ", "")
      p.alignment.ids[currentTaxon] = id 
      for i in 0 ..< sequence.len:
        try:
          p.alignment.data[currentTaxon, i] = parseChar(sequence[i], T)
        except ValueError:
          raise newException(PhylipError, fmt"Invalid {$T} character '{sequence[i]}' at line {p.lineNum}. Header may not match data")
      cumLen += sequence.len
      if cumLen == p.alignment.nchars: 
        if currentTaxon == p.alignment.nseqs - 1: 
          p.state = phyEnd
          break
        else:
          currentTaxon += 1
          cumLen = 0
      else:
        p.state = phySequential
    
    of phySequential: # Parse remaining lines of sequential sequence 
      var sequence = line.replace(" ", "")
      for i in 0 ..< sequence.len:
        try:
          p.alignment.data[currentTaxon, cumLen + i] = parseChar(sequence[i], T)
        except ValueError:
          raise newException(PhylipError, fmt"Invalid {$T} character '{sequence[i]}' at line {p.lineNum}. Header may not match data")
      cumLen += sequence.len
      if cumLen == p.alignment.nchars: 
        if currentTaxon == p.alignment.nseqs - 1: 
          p.state = phyEnd
          break
        else:
          currentTaxon += 1
          cumLen = 0
          p.state = phySequentialStart
    
    else:
      raise newException(PhylipError, "Internal error.")
      
  if p.state != phyEnd:
    if allowEmpty:
      if p.state != phyStart:
        raise newException(PhylipError, "Unexpected end of Phylip")
      else:
        p.state = phyEOF
    else:
      raise newException(PhylipError, "Unexpected end of Phylip")

iterator iterPhylipStream*(stream: Stream, typ: typedesc, fmt: PhylipFormat): Alignment[typ] = 
  var parser = PhylipParser[typ](stream:stream, format:fmt)
  while true:  
    parser.parsePhylipAlignment(allowEmpty=true)
    if parser.state == phyEOF:
      break
    else:
      yield parser.alignment 

iterator iterPhylipString*(str: string, typ: typedesc, fmt: PhylipFormat): Alignment[typ] = 
  var ss = newStringStream(str)
  for i in iterPhylipStream(ss, typ, fmt):
    yield i 
  ss.close

iterator iterPhylipFile*(path: string, typ: typedesc, fmt: PhylipFormat): Alignment[typ] = 
  var fs = newFileStream(path)
  for i in iterPhylipStream(fs, typ, fmt):
    yield i 
  fs.close

proc parsePhylipStream*(stream: Stream, typ: typedesc, fmt: PhylipFormat): Alignment[typ] =
  ## Read Phylip stream.
  var parser = PhylipParser[typ](stream:stream, format:fmt)
  parser.parsePhylipAlignment
  result = parser.alignment

proc parsePhylipFile*(path: string, typ: typedesc, fmt: PhylipFormat): Alignment[typ] = 
  ## Read Phylip file.
  var fs = newFileStream(path)
  result = parsePhylipStream(fs, typ, fmt)
  fs.close

proc parsePhylipString*(str: string, typ: typedesc, fmt: PhylipFormat): Alignment[typ] =
  ## Read Phylip string.
  var ss = newStringStream(str)
  result = parsePhylipStream(ss, typ, fmt)
  ss.close