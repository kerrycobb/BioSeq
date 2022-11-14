import ./alignment
import std/strformat

import ./nucleotide
import ./aminoAcid
import ./biallelic 

proc nexusFormatCommand(typ: typedesc[DNA]): string =  
  result = "    FORMAT DATATYPE=DNA MISSING=? GAP=-;" 

proc nexusFormatCommand(typ: typedesc[RNA]): string =  
  result = "    FORMAT DATATYPE=RNA MISSING=? GAP=-;" 

proc nexusFormatCommand(typ: typedesc[DiploidBiallelic]): string =  
  result = "    FORMAT DATATYPE=STANDARD SYMBOLS=\"012\" MISSING=? GAP=-;" 

proc nexusFormatCommand(typ: typedesc[HaploidBiallelic]): string =  
  result = "    FORMAT DATATYPE=STANDARD SYMBOLS=\"01\" MISSING=? GAP=-;" 

iterator toNexus*[T](a: Alignment[T]): string = 
  mixin nexusFormatCommand
  yield "#NEXUS\n"
  yield "BEGIN DATA;\n"
  yield &"    DIMENSIONS NTAX={a.nseqs} NCHAR={a.nchars};\n"
  yield nexusFormatCommand(T) & "\n"
  yield "    MATRIX\n"
  var maxLen = 0
  for i in a.ids:
    if i.len > maxLen: maxLen = i.len
  for i in 0 ..< a.nseqs:
    var data = newStringOfCap(maxLen + a.nchars + 12)
    data.add(' '.repeat(8))
    data.add(a.ids[i])
    data.add(' '.repeat(maxLen - a.ids[i].len + 4))
    for j in 0 ..< a.nchars:
      data.add(a.data[i, j].toChar)
    data.add('\n')
    yield data
  yield "    ;\n"
  yield "END;"

proc toNexusFile*[T](a: Alignment[T], path: string, mode: FileMode = fmWrite) = 
  var fh = open(path, mode)
  for i in a.toNexus: 
    fh.write(i)
  fh.close

proc toNexusString*[T](a: Alignment[T]): string = 
  for i in a.toNexus:
    result.add(i)