## Script converting phylip alignment to structure file encoded as biallelic data

import bioseq
import std/strformat
import std/algorithm

proc equalWidthBinCount*[T](s, bins: seq[T]): seq[int] = 
  assert bins.isSorted
  for i in 0 .. bins.len - 2:
    let
      lower = bins[i]
      upper = bins[i + 1]
    var count = 0
    for j in s: 
      if j >= lower and j < upper:
        count += 1
    result.add(count)

proc missing(inPath, outPath: string) = 
  let 
    inAlign = parsePhylipFile(inPath, DNA, Sequential)
    filtered = inAlign.filterColumns({dnaN, dnaUnk, dnaGap})
    emptyCols = inAlign.nchars - filtered.nchars
    biAlign = filtered.toDiploidBiallelic
    multiCols = filtered.nchars - biAlign.nchars 

  # Row proportion of missing data
  var rowProps: seq[(string, float)] 
  for i in 0 ..< biAlign.nseqs:
    let 
      count = biAlign.rowCharacterCount(i, {dbGap, dbUnk})
      prop = count / biAlign.nchars
    rowProps.add((biAlign.ids[i], prop)) 
  rowProps = rowProps.sortedByIt(it[1])
  echo fmt"{biAlign.nseqs} samples"
  echo fmt"Empty columns: {emptyCols}"
  echo fmt"Multi allelic columns: {multiCols}"
  echo fmt"Remaining columns: {biAlign.nchars}"
  echo "Percent Missing Data:"
  for i in rowProps:  
    echo fmt"{i[0]}: {i[1]}"  

  # Column proportion of missing data
  var colProps: seq[float] 
  for i in 0 ..< biAlign.nchars:
    let
      count = biAlign.colCharacterCount(i, {dbGap, dbUnk}) 
      prop = count / biAlign.nseqs
    colProps.add(prop)
  let 
    bins = @[0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    binnedColProps = equalWidthBinCount(colProps, bins)
  echo "\nLoci with N proportion of missing sites:"
  for i in 0 .. bins.len - 2: 
    echo fmt"{bins[i]}-{bins[i+1]}: {binnedColProps[i]}"
  
  biAlign.toStructureFile(outPath)

when isMainModule:
  import cligen; dispatch missing