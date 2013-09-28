CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

obj
  SC : "Screen"
  SN : "Simple_Numbers.spin"
  str: "str3"
  TC : "trackBallEx"

var
  byte event[30]
  byte dayByte,monthByte,yearByte
  long eventDesc,isValid


pub ReadAll|loopCount
  SC.Init
  SC.MediaInit
  SC.Clear
  'Show All Cal events
  loopCount:=0
  repeat 4
    case loopCount
      0:SC.SetSectorCal0
      1:SC.SetSectorCal1
      2:SC.SetSectorCal2
      3:SC.SetSectorCal3
      4:SC.SetSectorCal4
    PrintCurrent
    SC.Position(loopCount,0)
    ReadFromCard
    loopCount++
  TC.WaitForBtnPress

pub CheckForDate(day,month,year)|loopCount
  SC.Init
  SC.MediaInit
  SC.Clear
  loopCount:=0
  repeat 4
    case loopCount
      0:SC.SetSectorCal0
      1:SC.SetSectorCal1
      2:SC.SetSectorCal2
      3:SC.SetSectorCal3
      4:SC.SetSectorCal4
    ReadFromCard
    loopCount++
    if day ==dayByte and month==monthByte and year==yearByte and isValid==true
      'sound the alarm
      SC.Clear
      SC.Position(0,0)
      SC.Print(string("********ALERT**********"))
      SC.Position(7,0)
      SC.Print(eventDesc)
      SC.Beep
      quit

pri ReadFromCard | dataByte,counter,buffer
  dataByte:=0
  counter:=0
  dayByte:=0
  monthByte:=0
  isValid:=false
  dayByte:=SC.ReadByte
  if dayByte <> $FF
    isValid:=true
    monthByte:=SC.ReadByte
    yearByte:=SC.ReadByte
    repeat
      dataByte:=SC.ReadByte
      if dataByte == $FF
        quit
      event[counter]:=dataByte
      counter++
    buffer:=str.Combine(string(" "),@event)
    eventDesc:=str.substr(buffer,0,counter+1)

pri PrintCurrent
  if isValid==true
    SC.Print(SN.Dec(monthByte))
    SC.Print(string("\"))
    SC.Print(SN.Dec(dayByte))
    SC.Print(string("\"))
    SC.Print(SN.Dec(yearByte))
    'SC.Print(SN.hex(event[0],2))
    SC.Print(eventDesc)
