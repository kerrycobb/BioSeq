import ../src/bioseq
import std/unittest 

suite "Nucleotide Sequence":

  test "To Seq":    
    check toSeq(@['A', 'T', 'G', 'C'], DNA) == @[dnaA, dnaT, dnaG, dnaC] 
    check toSeq("ATGC", DNA) == @[dnaA, dnaT, dnaG, dnaC]

  test "Complement":
    check complement(toSeq("ATGC", DNA)) == @[dnaT, dnaA, dnaC, dnaG] 

  test "Reverse Complement":
    check reverseComplement(toSeq("ATGC", DNA)) == @[dnaG, dnaC, dnaA, dnaT] 

  test "Translate":
    let t = toSeq("ATGCATGCA", DNA) 
    check translate(t) == @[aaM, aaH, aaA] 