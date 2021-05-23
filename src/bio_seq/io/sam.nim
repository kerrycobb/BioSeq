import strutils
import options

# Tag description are copied from https://samtools.github.io/hts-specs/SAMv1.pdf
# at 7 Jan 2021
#

# ---------------- TERMINOLOGY ----------------------
#[ 
Alternate locus:  https://www.ncbi.nlm.nih.gov/grc/help/definitions/
A sequence that provides an alternate representation of a locus found in a largely haploid assembly. These sequences don't represent a complete chromosome sequence although there is no hard limit on the size of the alternate locus; currently these are less than 1 Mb. Previously these sequences have been referred to as "partial chromosomes", "alternate alleles", and "alternate haplotypes". However, these terms are confusing because they contain terms that have biological implications. Diploid assemblies (which by definition are from a single individual) should not have alternate loci representations. Multiple scaffolds from different loci that are considered to be part of the same haplotype should be grouped into alternate locus groups (e.g. mouse 129/Sv group). Note: an alternate locus group was previously considered an alternate partial assembly.]#

type
  TagKind = enum  # the different node types
    HD,          
    SQ,
    RG,
    PQ,
    CO
  SOKind = enum
    unknown,
    unsorted
    queryname
    coordinate
  
  GOKind = enum
    none,
    query,
    reference


  Tag = ref object
    case kind: TagKind
      of HD: 
        VN: string 
        SO: Option[SOKind]
        GO: Option[GOKind]
        SS: Option[string] #TODO
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
        TP: Option[string]
        UR: Option[string]
      of RG: strVal: string
      of PQ: discard
      of CO: discard

    


  SAMHeader = object
    discard
  
  SAM = object
    header: SAMHeader

  SAMError* = object of CatchableError

proc parseHD(tags: var seq[string])=
  #TODO Figure /^[0-9]+\.[0-9]+$/ out
  echo tags
  while tags.len != 0:
    # get the tag and the argument we want to parse
    let tag_arg = tags[0]
    # TODO clearer
    let tar_arg_split = tag_arg.split(":")
    let tag = tar_arg_split[0]
    let arg = tar_arg_split[1]

    # Get next tag
    tags = tags[1 .. ^1]
    


proc parseHeader*(header: string): string =
  if header == "":
    # Because the headerline is optional
    return "" 
  if header[0] != '@':
    raise newException(SAMError, "Header must start with an @")
#TODO Find out if there is a specified order of the header tags
  var split_line: seq[string]
  case header[1 .. 2]:
    of "HD":
      split_line = header.split('\t')
      # exlude @HD in call
      split_line = split_line[1 .. ^1]
      parseHD(split_line )
    of "SQ":
      split_line = header.split('\t')
    of "RG":
      split_line = header.split('\t')
    of "PQ":
      split_line = header.split('\t')
    of "CO":
      split_line = header.split('\t')
    else:
      #TODO Error
      discard


  header[1 .. ^1]

