# TODO: This needs to be rewritten

# import ../sequence
# import streams
# import strutils

# proc parse_strict_phylip_stream*(stream:Stream): Alignment =
#   ## Parse strict phylip stream
#   # TODO Implement error checks using proper exceptions
#   if stream.isNil:
#     echo "Stream is Nil"
#     quit()
#   if stream.atEnd:
#     echo "Stream is empty"
#     quit()
#   var
#     split = stream.readLine().strip().toLowerAscii().split()
#     ntax = parseInt(split[0])
#     nchar = parseInt(split[1])
#     line: string
#     sequence: Sequence
#   result = Alignment(ntax:ntax, nchar:nchar)
#   for i in 0 .. ntax-1:
#     line = stream.readLine()
#     result.sequences.add(Sequence(
#       id:line[0..9].strip(),
#       data:line[10..^1]))
#   while not stream.atEnd:
#     line = stream.readline()
#     for i in 0 .. ntax-1:
#       result.sequences[i].data.add(stream.readLine().strip())

# proc read_strict_phylip_file*(path:string): Alignment =
#   ## Parse strict phylip file
#   # TODO catch parser exceptions and override with file exceptions
#   var fs = newFileStream(path, fmRead)
#   result = parse_strict_phylip_stream(fs)
#   fs.close()
