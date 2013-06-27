CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  right=1
  left=0

obj
  SC : "screen"
  SN : "Simple_Numbers"
  Rtc: "DS1302"
  TC : "trackBallEx"
  Conver: "Converter"

pub main | hour,minute, currentPosition,day,month,year,timeOk,datePOS
  SC.Init
  SC.clear

  hour:=12
  minute:=0
  day:=1
  month:=1
  year:=0
  timeOk:=false
  SC.DrawTri($2F,$5A,$1F,$66,$3F,$66,$F8,$00)
  currentPosition:=left
  DrawTime(hour,minute)
  waitcnt(clkfreq+cnt)
  repeat until timeOk==true
    TC.Run
    if TC.isPressed ==true
      timeOk:=true
      repeat until TC.isPressed==false
        TC.Run
    if TC.isRight
      'clear old Tri
      SC.DrawTri($2F,$5A,$1F,$66,$3F,$66,$00,$00)
      SC.DrawTri($6E,$5A,$5E,$66,$7E,$66,$F8,$00)
      currentPosition:=right
    if TC.isLeft
      'clear old Tri
      SC.DrawTri($2F,$5A,$1F,$66,$3F,$66,$F8,$00)
      SC.DrawTri($6E,$5A,$5E,$66,$7E,$66,$00,$00)
      currentPosition:=left
    if TC.isUp ==true
      case currentPosition
        left: hour:=hour+1
        right: minute:=minute+1
      EnsureBoundries(@hour,@minute)
      DrawTime(hour,minute)
    if TC.isDown ==true
      case currentPosition
        left: hour:=hour-1
        right: minute:=minute-1
      EnsureBoundries(@hour,@minute)
      DrawTime(hour,minute)
 '   waitcnt(clkfreq+cnt)

  'Date set loop
  SC.Clear
  SC.DrawTri($28,$5A,$18,$66,$38,$66,$F8,$00)
  datePOS:=0
  DrawDate(day,month,year)
  repeat until TC.isPressed==true
    TC.Run

    if TC.isRight ==true
      case datePOS
        0:
          SC.DrawTri($28,$5A,$18,$66,$38,$66,$00,$00)
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$F8,$00)
          datePOS:=1
        1:
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$00,$00)
          SC.DrawTri($7D,$5A,$6D,$66,$8D,$66,$F8,$00)
          datePOS:=2

    if TC.isLeft ==true
      case datePOS
        1:
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$00,$00)
          SC.DrawTri($28,$5A,$18,$66,$38,$66,$F8,$00)
          datePOS:=0
        2:
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$F8,$00)
          SC.DrawTri($7D,$5A,$6D,$66,$8D,$66,$00,$00)
          datePOS:=1

    if TC.isUp == true
      case datePOS
        0: month:=month+1
        1: day:=day+1
        2: year:=year+1
      EnsureDateBoundries(@year,@day,@month)
      DrawDate(day,month,year)

    if TC.isDown ==true
      case datePOS
        0: month:=month-1
        1: day:=day-1
        2: year:=year-1
      EnsureDateBoundries(@year,@day,@month)
      DrawDate(day,month,year)

  SetClock(month,day,year,hour,minute,0)
  return 1
pri DrawTime(hour,minute)
  SC.FontSize(0)
  SC.TxtColor($FF,$E0)
  SC.Position(7,4)
  SC.FontSize(3)
  SC.Print(SN.decx(hour,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(minute,2))

pri EnsureBoundries(hour,minute)
  if long[hour] > 24
    long[hour]:=00
  if long[hour] <0
    long[hour]:=24
  if long[minute] > 60
    long[minute]:=00
  if long[minute] <0
    long[minute]:=60

pri EnsureDateBoundries(year,day,month)
  if long[year] < 0
    long[year]:=0
  if long[day] > 31
    long[day]:=1
  if long[day]<1
    long[day]:=31
  if long[month] > 12
    long[month]:=1
  if long[month] < 1
    long[month]:=12
pri DrawDate(day,month,year)
  SC.FontSize(0)
 ' SC.TxtColor($FF,$E0)
  SC.Position(7,4)
  SC.FontSize(2)
  SC.Print(SN.decx(month,2))
  SC.Print(string("/"))
  SC.Print(SN.decx(day,2))
  SC.Print(string("/"))
  SC.Print(SN.decx(year,2))

pri SetClock(month,day,year,hour,minute,second)| dow
  rtc.init(17,16,18)
  rtc.config
  dow:=Conver.DateToDOW(month,day,year)
  rtc.setDatetime(month,day,year,dow,hour,minute,second)
