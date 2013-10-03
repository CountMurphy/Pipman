CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
obj
  serial : "FullDuplexSerial"
  TC     : "trackBallEx"
  SC     : "Screen"
  SN    :  "Simple_Numbers"
  str   :  "str3"
  CL    :  "calendar"
var
  byte details[30]
pub Init
  serial.start(31,30,0,9600)
  SC.Init
  SC.MediaInit

pub ExportGPSSingle| dataByte
  SC.SetSectorGPS
  Transmit
  DisplayMsg
pub ExportGPSTrack
  SC.SetSectorGPSMap
  Transmit
  DisplayMsg
pub ImportCal | eventNum,day,month,year,buffer,count
  eventNum:=serial.rx
  day:=serial.rx
  month:=serial.rx
  year:=serial.rx

  count:=0
  repeat
    buffer:=serial.rx
    if buffer == $FF
      quit
    details[count]:=buffer
    count++

  buffer:=str.Combine(string(" "),@details)
  serial.stop

  SC.Clear
  SC.Print(string("Calendar # "))
  SC.Print(SN.dec(eventNum))
  SC.Position(1,0)
  SC.Print(SN.hex(day,2))
  SC.Print(SN.hex(month,2))
  SC.Print(SN.hex(year,2))
  SC.Position(2,0)
  SC.Print(buffer)

  'Save that data
  SC.MediaInit
  case eventNum
    0: SC.SetSectorCal0
    1: SC.SetSectorCal1
    2: SC.SetSectorCal2
    3: SC.SetSectorCal3
    4: SC.SetSectorCal4
  SC.WriteByte(day)
  SC.WriteByte(month)
  SC.WriteByte(year)
  SC.SaveStr(buffer)
  SC.Flush
  waitcnt(clkfreq+cnt)
  SC.Clear

pub DelCal(num)
  CL.DelCal(num)

pri Transmit | dataByte
  dataByte:=0
  repeat until strcomp(dataByte,string("FF")) ==-1
    dataByte:=SC.ReadByteAsString
    serial.str(dataByte)

pri DisplayMsg
  SC.Clear
  SC.Position(0,0)
  SC.Print(string("Export Complete"))
  waitcnt(clkfreq+cnt)
  waitcnt(clkfreq+cnt)


