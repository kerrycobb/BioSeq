import iupac_uint8
import std/strformat
import std/streams
import std/strutils
import std/sequtils

type
  PhylipError* = object of CatchableError

proc parsePhylipStream*(stream:Stream, interleaved=true): Alignment =
  ## Parse strict Phylip stream, identifiers must be less than 10 characters 
  ## long and padded by spaces
  if stream.isNil:
    raise newException(PhylipError, "Stream is Nil")
  if stream.atEnd:
    raise newException(PhylipError, "Stream is empty")
  var 
    header = stream.readLine()
    dimensions = header.strip().toLowerAscii().split() 
  if dimensions.len != 2:
    raise newException(PhylipError, &"Expected alignment dimensions. Got: \"{header}\"")
  var
    nseqs = parseInt(dimensions[0])
    nchars = parseInt(dimensions[1])
    alignment = Alignment(nseqs:nseqs, nchars:nchars, seqs:newSeq[Sequence](nseqs)) 
    firstBlock = true
    lineNum = 1
    seqIx = 0 
    posIxs = repeat(0, nseqs) 
  for i in 0 ..< nseqs:
    alignment.seqs[i] = Sequence(data:newSeq[Nucleotide](nchars))
  if interleaved:
    while not stream.atEnd():
      let line = stream.readLine().strip()
      lineNum += 1
      if line.len != 0:
        var seqString: string 
        if firstBlock:
          var split = line.split(maxsplit=1)
          if not split.len == 2:
            raise newException(PhylipError, &"Cannot determine sequence ID at line: {lineNum}")
          alignment.seqs[seqIx].id = split[0] 
          seqString = split[1]
        else:
          seqString = line
        for i in seqString.replace(" ", ""):
          if posIxs[seqIx] < nchars:
            alignment.seqs[seqIx].data[posIxs[seqIx]] = toNucleotide(i) 
            posIxs[seqIx] += 1
          else:
            raise newException(PhylipError, &"Number of specified characters exceeded at line: {lineNum}")
        seqIx += 1
        if seqIx == nseqs:
          firstBlock = false
          seqIx = 0
    for i in 0 ..< nseqs:
      if posIxs[i] < nchars:
        raise newException(PhylipError, &"Unexpected end of Phylip, too few characters for sequence: {alignment.seqs[i].id}")
    result = alignment
  else:
    raise newException(PhylipError, "Sequential Phylip files not yet supported")

proc parseStrictPhylipString*(s: string, interleaved=true): Alignment = 
  ## Parse strict phylip string
  var ss = newStringStream(s)
  result = parsePhylipStream(ss, interleaved)
  ss.close()