import iupac_uint8
import streams
import strutils
import sequtils

proc parseFastaAlignmentStream*(stream:Stream): Alignment =
  ## Parse Fasta alignment stream, requires that all fasta entries of 
  ## them stream are of the same length
  if stream.isNil:
    raise newException(FastaError, "Stream is Nil")
  if stream.atEnd:
    raise newException(FastaError, "Stream is empty")
  var
    line: string
    sequence: Sequence
  while not stream.atEnd:
    line = stream.readLine()
    # Skip emty lines
    if not line.isEmptyOrWhitespace():
      # Starts line with additional information
      if line.startsWith('>'):
        # Add data from last iteration to the resulst
        if not sequence.isNil:
          result.add(sequence)
        # read the next line into a sequence
        sequence = Sequence(id: line[1..^1])
      else:
        # Starts line with nucleotide data
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
  ## Parse fasta file
  # TODO catch stream parser exceptions and override with file exceptions
  var fs = newFileStream(path, fmRead)
  result = parseFastaAlignmentStream(fs)
  fs.close()

proc writeFastaAlignmentString*(alignment:Alignment, multiline=true): string =
  ## Write fasta string
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
  ## Write fasta file
  var str = alignment.writeFastaAlignmentString(multiline)
  writeFile(filename, str)


proc parseFastaStream*(stream:Stream): Fasta =
  ## Parse fasta stream
  # TODO Implement error checks using proper exceptions
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

proc parseFastaString*(string: string): Fasta =
  var ss = newStringStream(string)
  result = parseFastaStream(ss)
  ss.close()


proc parseFastaFile*(path:string): Fasta =
  ## Parse fasta file
  # TODO catch stream parser exceptions and override with file exceptions
  var fs = newFileStream(path, fmRead)
  result = parseFastaStream(fs)
  fs.close()

proc writeFastaFile*(fasta: Fasta, path: string) : void =
  let f = open(path, fmWrite)
  for sequence in fasta.seqs:
    f.writeLine(">" & sequence.id)
    f.writeline($sequence.data)

  f.close()

