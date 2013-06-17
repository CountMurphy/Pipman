CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
obj
  serial : "Simple_Serial"
  SN     : "Simple_Numbers"


'All of this could probably use a refactoring, but not sure if worth the effort.  have a deadline

pub Init
  serial.init(5,4,9600)

pub ShowVideo
  MediaInit
  serial.tx($FF)
  serial.tx($BB)
  serial.tx($00)
  serial.tx($00)
  serial.tx($00)
  serial.tx($00)
  WaitForComplete

pub MediaInit
  serial.tx($FF)
  serial.tx($B1)
  WaitForComplete

pub Print(str)
  serial.tx($00)
  serial.tx($06)
  serial.str(str)
  'null terminate this bitch
  serial.tx($00)
  WaitForComplete


pub FadeOut| contrastNum
  contrastNum:=15
  repeat while contrastNum > -1
    Contrast(contrastNum)
    contrastNum:=contrastNum-1
    waitcnt(clkfreq/8000+cnt)

pub FadeIn| contrastNum
  contrastNum:=0
  repeat while contrastNum < 16
    Contrast(contrastNum)
    contrastNum:=contrastNum+1
    waitcnt(clkfreq/8000+cnt)
pub Off
  Contrast(0)
pub On
  Contrast(15)

pub Contrast(num)
  serial.tx($FF)
  serial.tx($66)
  serial.tx(00)
  serial.tx(num)
  WaitForComplete

pub Clear
  serial.tx($FF)
  serial.tx($D7)
  WaitForComplete

pub FontSize(size)
  'any int from 1-16
  if size <1 or size >16
    size:=1
  serial.tx($FF)
  serial.tx($7B)
  serial.tx(00)
  serial.tx(size)
  WaitForComplete
  serial.tx($FF)
  serial.tx($7C)
  serial.tx($00)
  serial.tx(size)
  WaitForComplete

pub Position(line,col)
  serial.tx($FF)
  serial.tx($E4)
  serial.tx(00)
  serial.tx(line)
  serial.tx(00)
  serial.tx(col)
  WaitForComplete


pub TxtColor(hexPart1,hexPart2)
  serial.tx($FF)
  serial.tx($7F)
  serial.tx(hexPart1)
  serial.tx(hexPart2)
  WaitForComplete

pub ShowFrame(frameNum)
  MediaInit
  serial.tx($FF)
  serial.tx($BA)
  'x
  serial.tx(00)
  serial.tx(00)
  'y
  serial.tx(00)
  serial.tx(00)
  'frame
  serial.tx(00)
  serial.tx(frameNum)
  WaitForComplete

  'disable txt background or not. must be 1 or 0
pub TxtTrans(bool)
  serial.tx($FF)
  serial.tx($77)
  serial.tx(00)
  serial.tx(bool)
  WaitForComplete

pub DisplayImage
  MediaInit
  serial.tx($FF)
  serial.tx($B3)
  'x
  serial.tx(00)
  serial.tx(00)
  'y
  serial.tx(00)
  serial.tx(00)
  WaitForComplete

pub Beep
  serial.tx($FF)
  serial.tx($DA)
  'note
  serial.tx(00)
  serial.tx($2D)
  'duration
  serial.tx($03)
  serial.tx($E8)'one sec
  WaitForComplete

pub DrawRec(X1,Y1,X2,Y2,colorHex1,colorHex2)
  serial.tx($FF)
  serial.tx($CF)
  'X1
  serial.tx($00)
  serial.tx(X1)
  'Y1
  serial.tx($00)
  serial.tx(Y1)
  'X2
  serial.tx($00)
  serial.tx(X2)
  'Y2
  serial.tx($00)
  serial.tx(Y2)
  'Color
  serial.tx(colorHex1)
  serial.tx(colorHex2)
  WaitForComplete

pub ChangeColor(oldColor1,oldColor2,newColor1,newColor2)
  serial.tx($FF)
  serial.tx($BE)
  serial.tx(oldColor1)
  serial.tx(oldColor2)
  serial.tx(newColor1)
  serial.tx(newColor2)
  WaitForComplete

pub SetByteAddr(High1,High2,Low1,Low2)
  serial.tx($FF)
  serial.tx($B9)
  serial.tx(High1)
  serial.tx(High2)
  serial.tx(Low1)
  serial.tx(Low2)
  WaitForComplete

pub SetSectorAddr(High1,High2,Low1,Low2)
  serial.tx($FF)
  serial.tx($B8)
  serial.tx(High1)
  serial.tx(High2)
  serial.tx(Low1)
  serial.tx(Low2)
  WaitForComplete

pub TxtBackColor(hex1,hex2)
  serial.tx($FF)
  serial.tx($7E)
  serial.tx(hex1)
  serial.tx(hex2)
  WaitForComplete

pri WaitForComplete
  return serial.rx

