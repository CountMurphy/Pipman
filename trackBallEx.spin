CON

  Btn=15
  up=14
  down=13
  left=11
  right=12
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000


var
  long pressedStatus
  long upStatus
  long downStatus
  long rightStatus
  long leftStatus

PUB Run

  waitcnt(clkfreq/10+cnt)
  if ina[up]==0
    upStatus:=true
  else
    upStatus:=false

  if ina[down]==0
    downStatus:=true
  else
    downStatus:=false

  if ina[left]==0
    leftStatus:=true
  else
    leftStatus:=false


  if ina[right]==0
    rightStatus:=true
  else
    rightStatus:=false

  if ina[Btn]==0
    pressedStatus:=true
  else
    pressedStatus:=false

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
pub WaitForBtnPress
  repeat
    Run
    if isPressed ==true
      repeat until isPressed==false
        Run
      return
