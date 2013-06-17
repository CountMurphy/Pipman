CON
  ledpin=13
  Btn=10
  up=14
  down=12
  left=11
  right=9
  testLED=27
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000


var
  long pressedStatus
  long upStatus
  long downStatus
  long rightStatus
  long leftStatus

PUB Run  :upSig | downSig,rightSig,leftSig
'upSig is for IDing when track ball pulses for up
'upStatus is to indicate to screen move cursor up
  dira[ledpin]:=1
  leftStatus:=false
  rightStatus:=false
  downStatus:=false
  upStatus:=false

  upSig:=ina[up]
  leftSig:=ina[left]
  rightSig:=ina[right]
  downSig:=ina[down]
  upSig:=ina[up]
  'if btn launch cog, timer 1 minute?

  waitcnt(clkfreq/150+cnt)
  'waitcnt(clkfreq+cnt)
  if ina[up]<>upSig
  '  outa[testLED]:=1
    upSig:=ina[up]
    upStatus:=true
  else
    outa[testLED]:=0
    upStatus:=false

  if ina[down]<>downSig
 '   outa[testLED]:=1
    downSig:=ina[down]
    downStatus:=true
  else
  '  outa[testLED]:=0
    downStatus:=false

  if ina[left]<>leftSig
    'outa[testLED]:=1
    leftSig:=ina[left]
    leftStatus:=true
  else
    'outa[testLED]:=0
    leftStatus:=false


  if ina[right]<>rightSig
 '   outa[testLED]:=1
    rightSig:=ina[right]
    rightStatus:=true
  else
  '  outa[testLED]:=0
    rightStatus:=false

  if ina[Btn]==0
    pressedStatus:=true
  else
    pressedStatus:=false
pub LEDOn
  outa[ledpin]:=1

pub KillLed
  outa[ledpin]:=0
pub isPressed
  return pressedStatus

pub isRight
  return rightStatus
pub isLeft
  return leftStatus
pub isDown
  return downStatus
pub isUp
  return upStatus
