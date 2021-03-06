CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

  device=$32
   datapin  = 1   'SDA
  clockPin = 0   'SCL

obj
  SC : "Screen"
  SN : "Simple_Numbers"
  CN : "Converter"
  Str : "STRINGS2"
var
  long X

pub PrintDeg
  SC.Init
  getHeading
  SC.print(SN.decf(||X/10,3))
  SC.print(string("."))
  SC.print(SN.dec(||X//10))

pub PrintHeading
  SC.Print(getDirection)

pub StandBy
  start
  send($32)
  send($83) 'sleep mode
  stop
pub Resume'fix this, or we waste 4.5 ma!
  start
  send($32)
  send($84) 'exit sleep mode to standby mode
  stop
  waitcnt(clkfreq/1000 + cnt)     'wait milisecond
  start
  send($32)
  send($75) 'endter run mode
  stop


pub PrintTemp| var1,toInt,final,tdec
  SC.InIt
  start
  send($91)
  'var1:=(receive(true) << 4) | (receive(true)>>4)

  var1:=(receive(true)<<4) | (receive(true)>>4)
  stop
  toInt:=CN.StrToDec(SN.dec(var1))
  'var1:=var1*0.0625
  '((var1*625)*9/5)+32
'  final:=FM.FMul(var1,0.0625)
  final:=(((var1*625)*9)/5)+320000
  SC.print(SN.dec((final/10000)))
  SC.print(string("."))
  if final/10000 < 100
    tdec:=2
  else
    tdec:=3
  SC.print(Str.parse(SN.dec(final),tdec,1))
 ' sc.position(2,0)
 ' sc.print(SN.dec(final))

pub getHeading|Y,Z

  start
  send($32)
  send($50) 'get tilt heading info!
  stop
  waitcnt(clkfreq/1000 + cnt)     'wait milisecond
  start
  send($33)
  X:=(receive(true) << 8) | (receive(true))
  Y:=(receive(true) << 8) | (receive(true))
  Z:=(receive(true) << 8) | (receive(false))
  stop
  ~~X
  X:=X

pub getDirection| heading
  heading:=X/10
  if heading => 0 and heading=<44
    return string("N ")
  if heading => 45 and heading=< 89
    return string("NE")
  if heading => 90 and heading=< 134
    return string("E ")
  if heading =>135 and heading=<179
    return string("SE")
  if heading => 180 and heading=<224
    return string("S ")
  if heading=> 225 and heading=<269
    return string("SW")
  if heading=> 270 and heading=<314
    return string("W ")
  if heading=>315 and heading=<360
    return string("NW")

PRI send(value) ' I²C Send data - 4 Stack Longs

  value := ((!value) >< 8)

  repeat 8
    dira[dataPin]  := value
    dira[clockPin] := false
    dira[clockPin] := true
    value >>= 1

  dira[dataPin]  := false
  dira[clockPin] := false
  result         := !(ina[dataPin])
  dira[clockPin] := true
  dira[dataPin]  := true

PRI receive(aknowledge) ' I²C receive data - 4 Stack Longs

  dira[dataPin] := false

  repeat 8
    result <<= 1
    dira[clockPin] := false
    result         |= ina[dataPin]
    dira[clockPin] := true

  dira[dataPin]  := aknowledge
  dira[clockPin] := false
  dira[clockPin] := true
  dira[dataPin]  := true


PRI start ' 3 Stack Longs

  outa[dataPin]  := false
  outa[clockPin] := false
  dira[dataPin]  := true
  dira[clockPin] := true

PRI stop ' 3 Stack Longs

  dira[clockPin] := false
  dira[dataPin]  := false

