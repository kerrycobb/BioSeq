import zip/gzipfiles
import ../iupac_uint8
import sequtils
import strutils
import sugar
## Sources used in the writing of this parser
## For a basic introduction look at
## http://homer.ucsd.edu/homer/basicTutorial/fastqFiles.html
## For different types of FastQ files look at
## https://www.ncbi.nlm.nih.gov/sra/docs/submitformats/#fastq-files 
## For phred scores look at 
## http://drive5.com/usearch/manual/quality_score.html
##
## !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI
## |    |    |    |    |    |    |    |    | 
## 0....5...10...15...20...25...30...35...40
## |    |    |    |    |    |    |    |    |
## worst................................best

# TODO
# Add line and colum information for errors

type 
  Record* = ref object
    header: string
    ## Header line of fastq file, should start with @ and followed by a unique readname(uniqueness, is not enforced at the moment)
    nucs: seq[Nucleotide]
    ## Actual nucleotide data
    secHeader: string
    ## Second header, must start with a + but can be empty, even then the + is still required 
    quality: string
    ## Phred score for the respecitve nucleotides must be the same length, as `nucs`
    ## Atm. the moment on
  PhredScore = enum
    phred33
    phred64
    undecided

  FastQ* = ref object
    sequences: seq[Record]
    phred: PhredScore

  FastQError* = object of CatchableError

template tryExpr(onFail: string, expr: untyped, ) = 
  {.line: instantiationInfo().}:
    try: expr
    except IOError:
      raise newException(FastQError, onFail)

proc `$`*(s: Record): string = 
  let h =  s.header
  var n: string = map(s.nucs, toChar).map((c: char) => $c).join
  let sh = s.secHeader
  let q = s.quality
  result = h & "\n" & n & "\n" & sh & "\n" & q & "\n"

proc `$`*(s: var FastQ): string = 
  for r in s.sequences:
    result.add($r)

proc parseHeader(header: string): string =
  if header == "":
    raise newException(FastQError, "Header line must not be empty")
  if header[0] != '@':
    raise newException(FastQError, "Header must start with an @")
  header[1 .. ^1]
   
proc parseNucleotides(nucs: string): seq[Nucleotide] =
  for n in nucs:
    result.add(n.toNucleotide)
  result

proc parseSecHeader(header: string): string =
  if header[0] != '+':
    raise newException(FastQError, "Second header must start with a +")
  header[1 .. ^1]

proc parseQuality(qual: string): (string) =
  for q in qual:
    if int(q) < 33 or int(q) > 106:
      raise newException(FastQError, "Unsopported phred score")
    result.add(q)


proc parseFastQFile*(filepath: string): FastQ =
  let gzfs = newGzFileStream(filepath)
  
  var fastQ: FastQ
  new(fastQ)
  
  var l:string
  while not gzfs.atEnd():
    # add error checks to every readline, look into monads again
    tryExpr("Header expected"):
      l = gzfs.readLine()
    let h = parseHeader(l)

    tryExpr("Nucleotides expected"):
      l = gzfs.readLine()
    let n = parseNucleotides(l)
    
    tryExpr("Second header expected"):
      l = gzfs.readLine()
    let sc = parseSecHeader(l)
    
    tryExpr("Quality string expected"):
      l = gzfs.readLine()
    let q = parseQuality(l)
    
    if q.len != n.len:
      raise newException(FastQError, "Nucleotide sequence and quality line have different length")
    else:
      var r: Record
      new(r)
      r.header = h
      r.nucs = n
      r.secHeader = sc
      r.quality = q
      fastQ.sequences.add(r)
  fastQ

when isMainModule:
  var f: FastQ
  new(f)
  f = parseFastQFile("tests/files/test1.fastq.gz")
  echo f
