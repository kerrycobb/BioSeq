## Script to convert a Phylip alignment to biallelic data in Nexus format.

import bioseq
import std/strformat
import std/strutils

proc toBiallelic(inPath, outPath: string) = 
  let 
    inAlign = parsePhylipFile(inPath, DNA, Sequential)

    filtered = inAlign.filterColumns({dnaN, dnaUnk, dnaGap})
    emptyCols = inAlign.nchars - filtered.nchars

    biAlign = filtered.toDiploidBiallelic
    multiCols = filtered.nchars - biAlign.nchars 

  biAlign.toNexusFile(outPath)

  if emptyCols > 0:
    echo fmt"{emptyCols} sites with columns containing only N excluded."
  if multiCols > 0:
    echo fmt"{multiCols} sites with more than two character states were excluded."

when isMainModule:
  import cligen; dispatch toBiallelic