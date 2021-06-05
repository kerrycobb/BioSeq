import std/strutils
import std/options
import std/strutils

# Tag description are copied from https://samtools.github.io/hts-specs/SAMv1.pdf
# at 7 Jan 2021
#

# ---------------- TERMINOLOGY ----------------------
#[ 
Alternate locus:  https://www.ncbi.nlm.nih.gov/grc/help/definitions/
A sequence that provides an alternate representation of a locus found in a largely haploid assembly. These sequences don't represent a complete chromosome sequence although there is no hard limit on the size of the alternate locus; currently these are less than 1 Mb. Previously these sequences have been referred to as "partial chromosomes", "alternate alleles", and "alternate haplotypes". However, these terms are confusing because they contain terms that have biological implications. Diploid assemblies (which by definition are from a single individual) should not have alternate loci representations. Multiple scaffolds from different loci that are considered to be part of the same haplotype should be grouped into alternate locus groups (e.g. mouse 129/Sv group). Note: an alternate locus group was previously considered an alternate partial assembly.]#

type
  TagKind* = enum  # the different node types
    HD,          
    SQ,
    RG,
    PQ,
    CO
  
  SOKind* = enum
    unknown,
    unsorted,
    queryname,
    coordinate
  
  GOKind* = enum
    none,
    query,
    reference

  TPKind* = enum
    circular,
    linear
  
  Tag* = ref object
    case kind*: TagKind
      of HD: 
        #TODO Is using Options usefull here, in the end
        #all values do get their default value anyway
        VN*: string 
        SO*: Option[SOKind]
        GO*: Option[GOKind]
        SS*: Option[string] #TODO
      # Reference sequence dictionary. The order of @SQ lines defines the alignment sorting order.
      of SQ: 
        #[ Reference sequence name. The SN tags and all individual AN names in all @SQ lines must be distinct. 
        The value of this field is used in the alignment records in RNAME and RNEXT fields.]#
        SN: string
        # Reference sequence length. Range: [1, 2^31 − 1]
        LN: int32
        #[ Indicates that this sequence is an alternate locus.8 The value is the locus in the primary assembly
        for which this sequence is an alternative, in the format ‘chr:start-end’, ‘chr ’ (if known), or ‘*’ (if
        unknown), where ‘chr ’ is a sequence in the primary assembly. Must not be present on sequences
        in the primary assembly. ]#
        AH: Option[string]
        AN: Option[seq[string]]
        AS: Option[string]
        DS: Option[string]
        M5: Option[string]
        SP: Option[string]
        TP: Option[TPKind]
        UR: Option[string]
      of RG: strVal: string
      of PQ: discard
      of CO: discard

  SAMHeader* = ref object
    headers*: seq[Tag]
  
  SAM* = ref object
    header*: SAMHeader

  SAMError* = object of CatchableError

proc parseHD(tags: var seq[string]): Tag =
  #TODO Figure /^[0-9]+\.[0-9]+$/ out
  #TODO case statment to array[string, proc] ?
  var t: Tag
  new(t)
  while tags.len != 0:
    # get the tag and the argument we want to parse
    let tag_arg = tags[0]
    # TODO clearer
    # Split tag_arg comibination at ":" to get the tag and the value
    let tar_arg_split = tag_arg.split(":")
    let tag = tar_arg_split[0]
    let arg = tar_arg_split[1]
    # Check which tag we got
    case tag:
      of "VN":
        #TODO BUG this is REQUIERED, all my test pass even though I dont 
        #specift VN, thats a BUG
        #TODO Check for incorrect format
        t.VN = arg 
      of "SO":
        case arg:
          of "unknown":
            t.SO = some(SOKind.unknown)
          of "unsorted":
            t.SO = some(SOKind.unsorted)
          of "queryname":
            t.SO = some(SOKind.queryname)
          of "coordinate":
            t.SO = some(SOKind.coordinate)
          else:
            discard #TODO ERROR
      of "GO":
        case arg:
          of "none":
            t.GO = some(GOKind.none)
          of "query":
            t.GO = some(GOKind.query)
          of "reference":
            t.GO = some(GOKind.reference)
          else:
            discard #TODO ERROR
      of "SS":
        discard
      else:
        discard #TODO ERROR
    # Get next tag
    tags = tags[1 .. ^1]
    
  #must be specified otherwise its correct
  if t.VN == "":
    #TODO Error
    discard
  # if those values are not specified by the user, we set 
  # the specified defaults
  if not t.SO.isSome:
    t.SO = some(SOKind.unknown)
  if not t.GO.isSome:
    t.GO = some(GOKind.none)

  t

proc parseSQ(tags: var seq[string]): Tag =
  #TODO case statment to array[string, proc] ?
  var t: Tag
  new(t)
  while tags.len != 0:
    # get the tag and the argument we want to parse
    let tag_arg = tags[0]
    # TODO clearer
    # Split tag_arg comibination at ":" to get the tag and the value
    let tar_arg_split = tag_arg.split(":")
    let tag = tar_arg_split[0]
    let arg = tar_arg_split[1]
    # Check which tag we got
    case tag:
      of "SN":
        #TODO Check for distinctness
        #TODO Check formate [:rname:∧*=][:rname:]*
        t.SN = arg
      of "LN":
        t.LN = (int32)parseInt(arg)
      of "AH":
        t.AH = some(arg)
      of "AN":
        t.AN = some(arg.split(","))
      of "AS":
        t.AS = some(arg)
      of "DS":
        t.DS = some(arg)
      of "M5":
        #TODO Implement
        t.M5 = some("")
      of "SP":
        t.SP = some("")
      of "TP":
        case arg:
          of "circular":
            t.TP = some(TPKind.circular)
          of "linear":
            t.TP = some(TPKind.linear)
          else:
            #TODO Error
            discard 
      of "UR":
        t.UR = some(arg)
    
    tags = tags[1 .. ^1]
    #TODO
    if t.SN == "":
      discard
    if t.LN == 0:
      # ERROR
      discard

  t

proc parseHeader*(sam: var SAM, line: string)= 
  new(sam.header)
  if line == "":
    return
    # Because the headerline is optional
  if line[0] != '@':
    raise newException(SAMError, "Header must start with an @")
  #TODO Find out if there is a specified order of the header tags
  var split_line: seq[string]
  case line[1 .. 2]:
    of "HD":
      split_line = line.split('\t')
      # exlude @HD in call
      split_line = split_line[1 .. ^1]
      let ret = parseHD(split_line )
      sam.header.headers.add(ret)
    of "SQ":
      split_line = line.split('\t')
      let ret = parseSQ(split_line )
      sam.header.headers.add(ret)
    of "RG":
      split_line = line.split('\t')
    of "PQ":
      split_line = line.split('\t')
    of "CO":
      split_line = line.split('\t')
    else:
      #TODO Error
      discard


