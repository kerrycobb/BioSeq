import bioseq
import std/strformat

proc missing(path: string) = 
  let 
    inAlign = parsePhylipFile(path, DNA, Sequential)
    filtered = inAlign.filterColumns({dnaN, dnaUnk, dnaGap})
    emptyCols = inAlign.nchars - filtered.nchars
    biAlign = filtered.toDiploidBiallelic
    multiCols = filtered.nchars - biAlign.nchars 

  var counts: seq[(string, float)] 
  for i in 0 ..< biAlign.nseqs:
    let 
      count = biAlign.rowCharacterCount(i, {dbGap, dbUnk})
      prop = count / biAlign.nchars
    counts.add((biAlign.ids[i], prop))
  for i in counts:  
    echo fmt"{counts[0]}: {counts[1]}"  

when isMainModule:
  import cligen; dispatch missing