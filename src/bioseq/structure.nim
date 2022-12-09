import ./alignment  
import ./biallelic
import std/strutils

const 
  diploidStructureChar*: array[DiploidBiallelic, string] = [" 0", " 1", " 2", "-9", "-9"]
  haploidStructureChar*: array[HaploidBiallelic, string] = [" 0", " 1", "-9", "-9"]

proc toStructureCharStr*(n: DiploidBiallelic): string = 
  diploidStructureChar[n]

proc toStructureCharStr*(n: HaploidBiallelic): string = 
  haploidStructureChar[n]

iterator toStructure*[T: Biallelic](a: Alignment[T]): string = 
  mixin toStructureCharStr
  var 
    maxIdLen = 0 
  for i in a.ids: 
    if i.len > maxIdLen: 
      maxIdLen = i.len
  for i in 0 ..< a.nseqs:
    var line = newStringOfCap(maxIdLen + (2 * a.nchars))
    line.add(a.ids[i]) 
    line.add(' '.repeat(maxIdLen - line.len))
    for j in 0 ..< a.nchars:
      line.add(' ')
      line.add(a.data[i,j].toStructureCharStr)
    if i < a.nseqs - 1:
      line.add('\n')
    yield line & line

proc toStructureFile*(a: Alignment[Biallelic], path: string) = 
  ## Write data to file in Structure format.
  var fh = open(path, fmWrite)
  for i in a.toStructure:  
    fh.write(i)
  fh.close()

proc toStructureString*[T: Biallelic](a: Alignment[T]): string = 
  ## Write data to string in Structure format.
  for i in a.toStructure:
    result.add(i)

