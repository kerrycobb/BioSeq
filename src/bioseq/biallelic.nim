import ./parserMacro

type DiploidBiallelic* = enum db0, db1, db2, dbGap, dbUnk
const diploidBiallelicChar*: array[DiploidBiallelic, char] = ['0', '1', '2', '-', '?']
proc toChar*(n: DiploidBiallelic): char = diploidBiallelicChar[n]
func parseChar*(c: char, typ: typedesc[DiploidBiallelic]): DiploidBiallelic = 
  ## Parse character to DiploidBiallelic enum type.
  generateParser(c, diploidBiallelicChar, DiploidBiallelic)

type HaploidBiallelic* = enum hb0, hb1, hbGap, hbUnk
const haploidBiallelicChar*: array[HaploidBiallelic, char] = ['0', '1', '-', '?']
proc toChar*(n: HaploidBiallelic): char = haploidBiallelicChar[n]
func parseChar*(c: char, typ: typedesc[HaploidBiallelic]): HaploidBiallelic = 
  ## Parse character to DiploidBiallelic enum type.
  generateParser(c, haploidBiallelicChar, HaploidBiallelic)