# import sequtils
import times
# import os
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
  DNA = enum
    dnaA, dnaC, dnaG, dnaT 

const
  dnaByte: array[DNA, uint8] = [136'u8, 40, 72, 24] 
  dnaChar: array[DNA, char] = ['A', 'C', 'G', 'T']
  dnaComp: array[DNA, DNA] = [dnaT, dnaG, dnaC, dnaA]

proc byte(dna: DNA): uint8 = dnaByte[dna]
proc char(dna: DNA): char = dnaChar[dna]

proc toChar(dna: DNA): char = 
  case dna 
  of dnaA:
    result = 'A'
  of dnaG:
    result = 'G'
  of dnaC:
    result = 'C'
  of dnaT:
    result = 'T'

# Benchmarks
const
  N = 1_000_000_000
var 
  a:  array[N, DNA] 
  b:  array[N, uint8] 
for i in 0 ..< N:
  let d = DNA(rand(0..3))
  a[i] = d 
  b[i] = d.byte 


benchmark "as int":
  var v: bool 
  for rep in 0..int(1e3):
    for i in b:
      v = i == 136'u8
      v = i == 72'u8
      v = i == 40'u8
      v = i == 24'u8

benchmark "int lookup":
  var v: bool
  for rep in 0..int(1e3):
    for i in a: 
      v = i.byte == 136'u8
      v = i.byte == 72'u8
      v = i.byte == 40'u8
      v = i.byte == 24'u8

benchmark "as enum":
  var v: bool
  for rep in 0..int(1e3):
    for i in a: 
      v = i == dnaA  
      v = i == dnaG
      v = i == dnaC
      v = i == dnaT

benchmark "enum assign":
  var v: byte 
  for rep in 0..int(1e11):
    for i in 0 ..< a.len:
      v = a[i].byte

benchmark "int assign":
  var v: byte 
  for rep in 0..int(1e11):
    for i in 0 ..< b.len:
      v = b[i]

benchmark "char case":
  for rep in 0..int(1e11):
    for i in a: 
      discard i.toChar

benchmark "char lookup":
  for rep in 0..int(1e11):
    for i in a: 
      discard i.char


# CPU Time [as int]      11.956s, 11.927s, 12.199s
# CPU Time [int lookup]  11.959s, 11.937s, 11.901s
# CPU Time [as enum]     11.917s, 11.915s, 11.910s
# CPU Time [enum assign] 3.701s, 3.737s, 3.738s
# CPU Time [int assign]  3.779s, 3.708s, 3.719s
# CPU Time [char case]   3.744s, 3.734s, 3.740s
# CPU Time [char lookup] 3.744s, 3.728s, 3.716s