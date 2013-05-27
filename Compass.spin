CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

  device=$32
   datapin  = 1   'SDA
  clockPin = 0   'SCL

obj
  serial : "Simple_Serial"
  SN : "Simple_Numbers"

var
  long X

pub main| heading
  repeat
    serial.init(1,30,4800)
    getHeading
    serial.str(SN.dec(||X/10))
    serial.str(string("."))
    serial.str(SN.dec(||X//10))
    serial.str(string("   "))

    heading:=getDirection
    serial.str(heading)
    serial.str(string("   "))
    waitcnt(clkfreq+cnt) 'remove this wait


pub StandBy
  start
  send($32)
  send($83) 'sleep mode
  stop
pub Resume
  start
  send($32)
  send($84) 'exit sleep mode to standby mode
  stop
  waitcnt(clkfreq/1000 + cnt)     'wait milisecond
  start
  send($32)
  send($75) 'endter run mode
  stop

pub getHeading|Y,Z

  waitcnt(clkfreq+cnt)

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
    return string("N")
  if heading => 45 and heading=< 89
    return string("NE")
  if heading => 90 and heading=< 134
    return string("E")
  if heading =>135 and heading=<179
    return string("SE")
  if heading => 180 and heading=<224
    return string("S")
  if heading=> 225 and heading=<269
    return string("SW")
  if heading=> 270 and heading=<314
    return string("W")
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

