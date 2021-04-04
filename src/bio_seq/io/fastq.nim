import zip/gzipfiles
import ../iupac_uint8
## Sources used in the writing of this parser
## For a basic introduction look at
## http://homer.ucsd.edu/homer/basicTutorial/fastqFiles.html
## For different types of FastQ files look at
## https://www.ncbi.nlm.nih.gov/sra/docs/submitformats/#fastq-files 
##


type 
  Record = ref object
    header: string
    ## Header line of fastq file, should start with @ and followed by a unique readname(uniqueness, is not enforced at the moment)
    nucs: seq[Nucleotide]
    ## Actual nucleotide data
    secHeader: string
    ## Second header, must start with a + but can be empty, even then the + is still required 
    quality: string
    ## Phred score for the respecitve nucleotides must be the same length, as `nucs`

  FastQ = ref object
    sequences: seq[Record]

  FastQError* = object of CatchableError

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



proc parseFastQFile(filepath: string): FastQ =
  let gzfs = newGzFileStream(filepath)
  
  var fastQ: FastQ
  new(fastQ)
  
  var l:string
  while not gzfs.atEnd():
    # add error checks to every readline, look into monads again
    l = gzfs.readLine()
    let h = parseHeader(l)
    l = gzfs.readLine()
    let n = parseNucleotides(l)
    l = gzfs.readLine()
    let sc = parseSecHeader(l)


when isMainModule:
  let gzfs = newGzFileStream("tests/files/test1.fastq.gz")
  
  while not gzfs.atEnd():
    echo gzfs.readLine()
    echo gzfs.readLine()
    echo gzfs.readLine()
    echo gzfs.readLine()
