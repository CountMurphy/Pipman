CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  gpsDataCache=$2FAF0 '100 megs into the card
obj
  serial : "Simple_Serial"
  SN     : "Simple_Numbers"
  Str    : "STRINGS2"
  TC :  "TrackBallEx"
  conf  :"Config"

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

pub Print(data)
  serial.tx($00)
  serial.tx($06)
  serial.str(data)
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
  serial.tx($40)
  'duration
  serial.tx($03)
  serial.tx($E8)'one sec
  WaitForComplete
  TC.WaitForBtnPress

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

pub DrawTri(X1,Y1,X2,Y2,X3,Y3,color1,color2)
  serial.tx($FF)
  serial.tx($C9)
  serial.tx($00)
  serial.tx(X1)
  serial.tx($00)
  serial.tx(Y1)
  serial.tx($00)
  serial.tx(X2)
  serial.tx($00)
  serial.tx(Y2)
  serial.tx($00)
  serial.tx(X3)
  serial.tx($00)
  serial.tx(Y3)
  serial.tx(color1)
  serial.tx(color2)
  WaitForComplete

pub SetSectorGPS
  SetByteAddr($0C,$80,$00,$00)

pub SetSectorCal0
  SetByteAddr(conf.Cal0(0),conf.Cal0(1),conf.Cal0(2),conf.Cal0(3))

pub SetSectorCal1
  SetByteAddr(conf.Cal1(0),conf.Cal1(1),conf.Cal1(2),conf.Cal1(3))

pub SetSectorCal2
  SetByteAddr(conf.Cal2(0),conf.Cal2(1),conf.Cal2(2),conf.Cal2(3))

pub SetSectorCal3
  SetByteAddr(conf.Cal3(0),conf.Cal3(1),conf.Cal3(2),conf.Cal3(3))

pub SetSectorCal4
  SetByteAddr(conf.Cal4(0),conf.Cal4(1),conf.Cal4(2),conf.Cal4(3))


'ONLY CALL AFTER SET SECTOR COMMAND!
'for set, take size in bytes, pad with 512ish (leftover sector) add next item
'512 sector size
pub SaveStr(data)|count
  repeat strsize(data)
    WriteByte(byte[data++])

pub flush
  serial.tx($FF)
  serial.tx($B2)
  WaitForComplete
  WaitForComplete
  WaitForComplete

pub ReadByteAsString
  serial.tx($FF)
  serial.tx($B7)
'  Print(SN.hex(WaitForComplete,2))'general ok
'  Print(SN.hex(WaitForComplete,2))'data1
'  Print(SN.hex(WaitForComplete,2))'data2
  if serial.rx ==$06
    serial.rx
    return SN.hex(serial.rx,2)
  else
    return string("IO Error")

pub ReadByte
  serial.tx($FF)
  serial.tx($B7)
'  Print(SN.hex(WaitForComplete,2))'general ok
'  Print(SN.hex(WaitForComplete,2))'data1
'  Print(SN.hex(WaitForComplete,2))'data2
  if serial.rx ==$06
    serial.rx
    return serial.rx
  else
    return string("IO Error")

pub WriteByte(char)| retval1,retval2,retval3
  if char <> 0
    serial.tx($FF)
    serial.tx($B5)
    serial.tx($00)
    serial.tx(char)
   'if serial.rx ==$06
    'serial.rx
    'Print(SN.hex(serial.rx,2))
    retval1:=WaitForComplete
    retval2:=WaitForComplete
    retval3:=WaitForComplete
'    Print(SN.hex(char,2))
'    Print(SN.hex(retval1,2))
'    Print(SN.hex(retval2,2))
'    Print(SN.hex(retval3,2))
  else
    Print(string("nulled out"))


pri WaitForComplete
  return serial.rx

