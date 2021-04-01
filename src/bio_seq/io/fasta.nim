import ../iupac_uint8
import streams
import strutils
import sequtils


# TODO: Implement functions for reading and writing a list of sequences as well

proc parseFastaAlignmentStream*(stream:Stream): Alignment =
  ## Parse fasta stream
  # TODO Implement error checks using proper exceptions
  if stream.isNil:
    raise newException(FastaError, "Stream is Nil")
  if stream.atEnd:
    raise newException(FastaError, "Stream is empty")
  var
    line: string
    sequence: Sequence
  result = Alignment()
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

proc write_fasta_string*(alignment:Alignment, multiline=true): string =
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
          result.add($i)
          column_cnt += 1
        else:
          result.add('\n')
          result.add($i)
          column_cnt = 1
      column_cnt = 0
    else:
      for n in sequence.data:
        result.add(n.toChar())
    if seq_cnt < nseq:
      result.add('\n')
      seq_cnt += 1

proc write_fasta_file*(alignment:Alignment, filename:string, multiline=true) =
  ## Write fasta file
  var str = alignment.write_fasta_string(multiline)
  writeFile(filename, str)


