import ../src/bioseq
import std/unittest 

suite "Nucleotide Sequence":

  test "toNucleotideSeq":    
    check $toNucleotideSeq(@['A', 'T', 'G', 'C'], DNA) == "ATGC" 
    check $toNucleotideSeq("ATGC", DNA) == "ATGC" 

  test "Complement":
    check $complement(toNucleotideSeq("ATGC", DNA)) == "TACG" 

  test "Reverse Complement":
    check $reverseComplement(toNucleotideSeq("ATGC", DNA)) == "GCAT" 

  test "Translate":
    let t = toNucleotideSeq("ATGCATGCA", DNA) 
    check $translate(t) == "MHA" 