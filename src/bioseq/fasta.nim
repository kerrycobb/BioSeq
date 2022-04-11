import ./iupac_uint8
import streams
import strutils

type
  FastaError* = object of CatchableError

proc parseFastaStream*(stream:Stream): SequenceList =
  ## Parse FASTA stream
  if stream.isNil:
    raise newException(FastaError, "Stream is Nil")
  if stream.atEnd:
    raise newException(FastaError, "Stream is empty")
  var
    line: string
    sequence: Sequence
  while not stream.atEnd:
    line = stream.readLine()
    if not line.isEmptyOrWhitespace():
      if line.startsWith('>'):
        if not sequence.isNil:
          result.add(sequence)
        sequence = Sequence(id:line[1..^1])
      else:
        if not sequence.isNil:
          for i in line:
            if i != ' ':
              sequence.data.add(toNucleotide(i))
  if not sequence.isNil:
    result.add(sequence)
  else:
    raise newException(FastaError, "Stream does not contain valid fasta data")

proc parseFastaString*(string: string): SequenceList =
  var ss = newStringStream(string)
  result = parseFastaStream(ss)
  ss.close()

proc parseFastaFile*(path:string): SequenceList =
  ## Parse FASTA file
  # TODO: catch stream parser exceptions and override with file exceptions
  var fs = newFileStream(path, fmRead)
  result = parseFastaStream(fs)
  fs.close()

proc writeFastaFile*(fasta: SequenceList, path: string) =
  let f = open(path, fmWrite)
  for sequence in fasta.seqs:
    f.writeLine(">" & sequence.id)
    f.writeline($sequence.data)
  f.close()

proc parseFastaAlignmentStream*(stream:Stream): Alignment =
  ## Parse Fasta alignment stream
  if stream.isNil:
    raise newException(FastaError, "Stream is Nil")
  if stream.atEnd:
    raise newException(FastaError, "Stream is empty")
  var
    line: string
    sequence: Sequence
  while not stream.atEnd:
    line = stream.readLine()
    if not line.isEmptyOrWhitespace():
      if line.startsWith('>'):
        if not sequence.isNil:
          result.add(sequence)
        sequence = Sequence(id: line[1..^1])
      else:
        if not sequence.isNil:
          for i in line:
            if i != ' ':
              sequence.data.add(toNucleotide(i))

  if not sequence.isNil:
    result.add(sequence)
  else:
    raise newException(FastaError, "Stream does not contain valid fasta data")

proc parseFastaAlignmentString*(string: string): Alignment =
  var ss = newStringStream(string)
  result = parseFastaAlignmentStream(ss)
  ss.close()

proc parseFastaAlignmentFile*(path:string): Alignment =
  ## Parse FASTA alignment file
  # TODO catch stream parser exceptions and override with file exceptions
  var fs = newFileStream(path, fmRead)
  result = parseFastaAlignmentStream(fs)
  fs.close()

# TODO: Split this up so strings are returned one line at a time. Use that for 
# both string and file writing so file can be written to incrementally
proc writeFastaAlignmentString*(alignment:Alignment, multiline=true): string =
  ## Write FASTA alignment string
  var
    nseq = alignment.seqs.len
    column_cnt = 0
    seq_cnt = 1
  for sequence in alignment.seqs:
    result.add('>')
    result.add(sequence.id)
    result.add('\n')
    if multiline:
      for i in sequence.data:
        if column_cnt < 80:
          result.add(i.toChar)
          column_cnt += 1
        else:
          result.add('\n')
          result.add(i.toChar)
          column_cnt = 1
      column_cnt = 0
    else:
      for n in sequence.data:
        result.add(n.toChar())
    if seq_cnt < nseq:
      result.add('\n')
      seq_cnt += 1

proc writeFastaAlignmentStringToFile*(alignment:Alignment, filename:string, multiline=true) =
  ## Write FASTA alignment file
  var str = alignment.writeFastaAlignmentString(multiline)
  writeFile(filename, str)

