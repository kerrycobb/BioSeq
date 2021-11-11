#TODO: Add file parsing proc
#TODO: Add sequential phylip parser

import ./iupac_uint8
import strformat
import streams
import strutils
import sequtils

type
  PhylipError* = object of CatchableError

# Original code separating interleaved and sequential into two blocks
# proc parsePhylipStream*(stream:Stream, interleaved=true): Alignment =
#   ## Parse Phylip stream 
#   if stream.isNil:
#     raise newException(PhylipError, "Stream is Nil")
#   if stream.atEnd:
#     raise newException(PhylipError, "Stream is empty")
#   var 
#     header = stream.readLine()
#     dimensions = header.strip().toLowerAscii().split() 
#   if dimensions.len != 2:
#     raise newException(PhylipError, &"Expected alignment dimensions. Got: \"{header}\"")
#   var
#     nseqs = parseInt(dimensions[0])
#     nchars = parseInt(dimensions[1])
#     alignment = Alignment(nseqs:nseqs, nchars:nchars, seqs:newSeq[Sequence](nseqs)) 
#     firstBlock = true
#     lineNum = 1
#     seqIx = 0 
#     posIxs = repeat(0, nseqs) 
#   for i in 0 ..< nseqs:
#     alignment.seqs[i] = Sequence(data:newSeq[Nucleotide](nchars))
#   if interleaved:
#     # Parse Interleaved
#     while not stream.atEnd():
#       let line = stream.readLine().strip()
#       lineNum += 1
#       if line.len != 0:
#         var seqString: string 
#         if firstBlock:
#           var split = line.split(maxsplit=1)
#           if not split.len == 2:
#             raise newException(PhylipError, &"Cannot determine sequence ID at line: {lineNum}")
#           alignment.seqs[seqIx].id = split[0] 
#           seqString = split[1]
#         else:
#           seqString = line
#         for i in seqString.replace(" ", ""):
#           if posIxs[seqIx] < nchars:
#             alignment.seqs[seqIx].data[posIxs[seqIx]] = toNucleotide(i) 
#             posIxs[seqIx] += 1
#           else:
#             raise newException(PhylipError, &"Number of specified characters exceeded at line: {lineNum}")
#         seqIx += 1
#         if seqIx == nseqs:
#           firstBlock = false
#           seqIx = 0
#   else:
#     # Parse Sequential
#     while not stream.atEnd():
#       let line = stream.readLine().strip()
#       lineNum += 1
#       if line.len != 0:
#         var seqString: string 
#         if firstBlock:
#           var split = line.split(maxsplit=1)
#           if not split.len == 2:
#             raise newException(PhylipError, &"Cannot determine sequence ID at line: {lineNum}")
#           alignment.seqs[seqIx].id = split[0] 
#           seqString = split[1]
#           firstBlock = false
#         else:
#           seqString = line
#         for i in seqString.replace(" ", ""):
#           if posIxs[seqIx] < nchars:
#             alignment.seqs[seqIx].data[posIxs[seqIx]] = toNucleotide(i) 
#             posIxs[seqIx] += 1
#           else:
#             raise newException(PhylipError, &"Number of specified characters exceeded at line: {lineNum}")
#         if posIxs[seqIx] == nchars:
#           firstBlock = true 
#           seqIx += 1 
#   for i in 0 ..< nseqs:
#     if posIxs[i] < nchars:
#       raise newException(PhylipError, &"Unexpected end of Phylip, too few characters for sequence: {alignment.seqs[i].id}")
#   result = alignment

proc parsePhylipStream*(stream:Stream, interleaved=true): Alignment =
  ## Parse Phylip stream 
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
    # TODO: Figure out error check for the parsing these integers
    nseqs = parseInt(dimensions[0])
    nchars = parseInt(dimensions[1])
    alignment = Alignment(nseqs:nseqs, nchars:nchars, seqs:newSeq[Sequence](nseqs)) 
    firstBlock = true
    lineNum = 1
    seqIx = 0 
    posIxs = repeat(0, nseqs) 
  for i in 0 ..< nseqs:
    alignment.seqs[i] = Sequence(data:newSeq[Nucleotide](nchars))
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
        if not interleaved:
          firstBlock = false
      else:
        seqString = line
      for i in seqString.replace(" ", ""):
        if posIxs[seqIx] < nchars:
          alignment.seqs[seqIx].data[posIxs[seqIx]] = toNucleotide(i) 
          posIxs[seqIx] += 1
        else:
          raise newException(PhylipError, &"Number of specified characters exceeded at line: {lineNum}")
      if interleaved:
        seqIx += 1
        if seqIx == nseqs:
          firstBlock = false
          seqIx = 0
      else:
        if posIxs[seqIx] == nchars:
          firstBlock = true 
          seqIx += 1 
  for i in 0 ..< nseqs:
    if posIxs[i] < nchars:
      raise newException(PhylipError, &"Unexpected end of Phylip, too few characters for sequence: {alignment.seqs[i].id}")
  result = alignment

proc parsePhylipString*(s: string, interleaved=true): Alignment = 
  ## Parse Phylip string
  var ss = newStringStream(s)
  result = parsePhylipStream(ss, interleaved)
  ss.close()


# var 
#   s1 = """
#   2 8
# Tax1 ATGC
# Tax2 ATGC
# TTTT
# AAAA
# """
#   s2 = """
#   2 8
# Tax1 ATGC
# TTTT
# Tax2 ATGC
# AAAA
# """
#   a1 = parsePhylipString(s1, interleaved=true)
#   a2 = parsePhylipString(s2, interleaved=false)

# echo a1
# echo a2