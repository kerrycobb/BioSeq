import ../src/bioseq
import std/math
import times
import strutils
import random

const code = [aaF, aaF, aaL, aaL, aaS, aaS, aaS, aaS, aaY, aaY, aaStp, aaStp, aaC, aaC, aaStp, aaW, aaL, aaL, aaL, aaL, aaP, aaP, aaP, aaP, aaH, aaH, aaQ, aaQ, aaR, aaR, aaR, aaR, aaI, aaI, aaI, aaM, aaT, aaT, aaT, aaT, aaN, aaN, aaK, aaK, aaS, aaS, aaR, aaR, aaV, aaV, aaV, aaV, aaA, aaA, aaA, aaA, aaD, aaD, aaE, aaE, aaG, aaG, aaG, aaG]




proc caseStmt(n: array[3, Nucleotide]): AminoAcid = 
  var str = newString(3)
  for i in 0 .. 2:
    str[i] = n[i].char
  case str: 
  of "AAA": result = aaF
  of "AAG": result = aaF
  of "AAC": result = aaL
  of "AAT": result = aaL
  of "AGA": result = aaS
  of "AGG": result = aaS
  of "AGC": result = aaS
  of "AGT": result = aaS
  of "ACA": result = aaY
  of "ACG": result = aaY
  of "ACC": result = aaStp
  of "ACT": result = aaStp
  of "ATA": result = aaC
  of "ATG": result = aaC
  of "ATC": result = aaStp
  of "ATT": result = aaW
  of "GAA": result = aaL
  of "GAG": result = aaL
  of "GAC": result = aaL
  of "GAT": result = aaL
  of "GGA": result = aaP
  of "GGG": result = aaP
  of "GGC": result = aaP
  of "GGT": result = aaP
  of "GCA": result = aaH
  of "GCG": result = aaH
  of "GCC": result = aaQ
  of "GCT": result = aaQ
  of "GTA": result = aaR
  of "GTG": result = aaR
  of "GTC": result = aaR
  of "GTT": result = aaR
  of "CAA": result = aaI
  of "CAG": result = aaI
  of "CAC": result = aaI
  of "CAT": result = aaM
  of "CGA": result = aaT
  of "CGG": result = aaT
  of "CGC": result = aaT
  of "CGT": result = aaT
  of "CCA": result = aaN
  of "CCG": result = aaN
  of "CCC": result = aaK
  of "CCT": result = aaK
  of "CTA": result = aaS
  of "CTG": result = aaS
  of "CTC": result = aaR
  of "CTT": result = aaR
  of "TAA": result = aaV
  of "TAG": result = aaV
  of "TAC": result = aaV
  of "TAT": result = aaV
  of "TGA": result = aaA
  of "TGG": result = aaA
  of "TGC": result = aaA
  of "TGT": result = aaA
  of "TCA": result = aaD
  of "TCG": result = aaD
  of "TCC": result = aaE
  of "TCT": result = aaE
  of "TTA": result = aaG
  of "TTG": result = aaG
  of "TTC": result = aaG
  of "TTT": result = aaG
  else: result = aaX 

proc permut(n: array[3, Nucleotide]): AminoAcid =  
  var num = 0
  for i in 0..2:
    let p = 4^(2-i) 
    num += p * n[i].ord   
  if num < 64:
    result = code[num]  
  else:
    result = aaX 

template benchmark(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
    echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"

var 
  n = 1_000_000_000

benchmark "caseStmt":
  for i in 0 ..< n:
    let a = [DNA(rand(16)), DNA(rand(16)), DNA(rand(16))]
    discard caseStmt(a)

benchmark "permut":
  for i in 0 ..< n:
    let a = [DNA(rand(16)), DNA(rand(16)), DNA(rand(16))]
    discard permut(a)


# n = 1_000_000_000
# nim c -r -d:danger
# CPU Time [caseStmt] 60.999s
# CPU Time [permut] 20.777s