# TODO: Why is -d:release so slow for equality int lookup? Should try more recent nim version then report.

import times
import strutils
import random

template benchmark(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
    echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"

type
  DNA = enum dnaA, dnaG, dnaC, dnaT, dnaR, dnaM, dnaW, dnaS, dnaK, dnaY, dnaV, dnaH, dnaD, dnaB, dnaN, dnaGap, dnaUnk

const
  dnaByte: array[DNA, uint8] = [0b1000_1000'u8, 0b0100_1000, 0b0010_1000, 0b0001_1000, 0b1100_0000, 0b1010_0000, 0b1001_0000, 0b0110_0000, 0b0101_0000, 0b0011_0000, 0b1110_0000, 0b1011_0000, 0b1101_0000, 0b0111_0000, 0b1111_0000, 0b0000_0100, 0b0000_0010]
  dnaChar: array[DNA, char] = ['A','G','C','T','R','M','W','S','K','Y','V','H', 'D','B','N','-','?']
  dnaComp: array[DNA, DNA] = [dnaT, dnaC, dnaG, dnaA, dnaY, dnaK, dnaW, dnaS, dnaM, dnaR, dnaB, dnaD, dnaH, dnaV, dnaN, dnaGap, dnaUnk]

proc byte(dna: DNA): uint8 = dnaByte[dna]
proc char(dna: DNA): char = dnaChar[dna]

proc toChar(dna: DNA): char = 
  case dna 
  of dnaA: result = 'A'
  of dnaG: result = 'G'
  of dnaC: result = 'C'
  of dnaT: result = 'T'
  of dnaR: result = 'R'
  of dnaM: result = 'M'
  of dnaW: result = 'W'
  of dnaS: result = 'S'
  of dnaK: result = 'K'
  of dnaY: result = 'Y'
  of dnaV: result = 'V'
  of dnaH: result = 'H'
  of dnaD: result = 'D'
  of dnaB: result = 'B'
  of dnaN: result = 'N'
  of dnaGap: result = '-'
  of dnaUnk: result = '?'

# Benchmarks
const
  N = 100_000_000
echo "N: " & $N
var 
  a:  array[N, DNA] 
  b:  array[N, uint8] 
for i in 0 ..< N:
  let d = DNA(rand(0..16))
  a[i] = d 
  b[i] = d.byte 


let n1 = 1000
echo "n1: " & $n1
benchmark "equality int direct":
  for rep in 0..n1:
    for i in b:
      var b1 = i == 136'u8
      var b2 = i == 72'u8
      var b3 = i == 40'u8
      var b4 = i == 24'u8

benchmark "equality int lookup":
  for rep in 0..n1:
    for i in a: 
      var b1 = i.byte == 136'u8
      var b2 = i.byte == 72'u8
      var b3 = i.byte == 40'u8
      var b4 = i.byte == 24'u8

benchmark "equality enum":
  for rep in 0..n1:
    for i in a: 
      var b1 = i == dnaA  
      var b2 = i == dnaG
      var b3 = i == dnaC
      var b4 = i == dnaT


let n2 = int(1e10)
echo "n2: " & $n2
benchmark "enum to int assignment":
  for rep in 0..n2:
    for i in 0 ..< a.len:
       var v = a[i].byte

benchmark "int to int assignment":
  for rep in 0..n2:
    for i in 0 ..< b.len:
      var v = b[i]


let n3 = int(100)
echo "n3: " & $n3
benchmark "char from case statment":
  for rep in 0..n3:
    for i in a: 
      var c = i.toChar

benchmark "char from enum lookup":
  for rep in 0..n3:
    for i in a: 
      var c = i.char

# Results

# nim c -r -d:release int_vs_enum.nim
# N: 100000000
# n1: 1000
# CPU Time [equality int direct] 1.474s
# CPU Time [equality int lookup] 1.434s
# CPU Time [equality enum] 1.431s
# n2: 10000000000
# CPU Time [enum to int assignment] 0.448s
# CPU Time [int to int assignment] 0.480s
# n3: 100
# CPU Time [char from case statment] 1.336s
# CPU Time [char from enum lookup] 0.146s

# nim c -r -d:danger int_vs_enum.nim
# N: 100000000
# n1: 1000
# CPU Time [equality int direct] 1.269s
# CPU Time [equality int lookup] 62.858s
# CPU Time [equality enum] 1.203s
# n2: 7766279631452241920
# CPU Time [enum to int assignment] 0.000s
# CPU Time [int to int assignment] 0.000s
# n3: 100
# CPU Time [char from case statment] 1.149s
# CPU Time [char from enum lookup] 0.167s