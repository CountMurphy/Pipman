obj
  cn : "Converter"
  fm : "FloatMath"
  Str: "STRINGS2"
  SN : "Simple_Numbers"
  SC:"Screen"
  Rtc : "DS1302"
  str3: "str3"

var
  long adjDay
  long adjMonth
  long adjYear

pub GetTimeZone(lon,E_W) | decVal,offset
  decVal:=CheckDecVal(lon)
  'decVal:=4
  'convert to int
  lon:=cn.Convert_ascii_string_to_fp(lon)
  lon:=GetRegion(lon,decVal)

  if lon =<165 and lon =>158
    offset:=11
  if lon =<157 and lon =>136
    offset:=10
  if lon =<135 and lon =>128
    offset:=9
  if lon=<127 and lon=>113
    'offset 8 hours
    offset:=8
  if lon=<112 and lon=>105
    'offset by 7
    offset:=7
  if lon=<104 and lon =>90
    offset:=6
  if lon =<89 and lon => 67
    offset:=5
  if lon =<65 and lon =>55
    offset:=4
  if lon =<54 and lon=>35
    offset:=3
  if lon =<34 and lon =>21
    offset:=2
  if lon =<20 and lon =>12
    offset:=1
  if lon =<11 and lon =>0
    offset:=0

  if StrComp(E_W,string("W"))
    offset:=offset*-1
  return offset



pub ParseCurrentDateTime(time,date,lon,E_W,DST) |hour,minute,second,month,day,year,offset,dow
  hour:=0
  minute:=0
  second:=0
  month:=0
  day:=0
  year:=0
  offset:=0
  dow:=0
  SC.Init
  SC.On
  SC.FontSize(1)
  SC.Print(string("Sat Lock..."))
  waitcnt(clkfreq+cnt)
  SC.Clear

  hour:=str3.strParse(time,0,2)
  SC.Print(hour)
  hour:=cn.Convert_ascii_string_to_fp(hour)
  SC.Position(1,0)
  SC.Print(time)
  minute:=str3.strParse(time,2,2)
  SC.Position(2,0)
  SC.Print(minute)
  minute:=cn.Convert_ascii_string_to_fp(minute)
  second:=str3.strParse(time,4,2)
  SC.Position(3,0)
  SC.Print(second)
  second:=cn.Convert_ascii_string_to_fp(second)

  'Dates

  waitcnt(clkfreq+cnt)
  SC.Clear
  'dates
  SC.Position(0,0)
  day:=str3.strParse(date,0,2)
  SC.Print(day)
  day:=cn.Convert_ascii_string_to_fp(day)
  SC.Position(1,0)
  SC.Print(date)
  month:=str3.strParse(date,2,2)
  SC.Position(2,0)
  SC.Print(month)
  month:=cn.Convert_ascii_string_to_fp(month)
  SC.Position(3,0)
  SC.Print(date)
  year:=str3.strParse(date,4,2)
  year:=cn.Convert_ascii_string_to_fp(year)
  SC.Position(4,0)
  SC.Print(year)
  SC.Position(5,0)
  SC.Print(date)


  waitcnt(clkfreq+cnt)
  waitcnt(clkfreq+cnt)
  waitcnt(clkfreq+cnt)


  offset:=GetTimeZone(lon,E_W)
  if DST == true
    offset:=offset+1

 'change date
  adjDay:=0
  adjMonth:=0
  adjYear:=0
  adjustDate(day,month,year,offset,hour)

  'adjust for time zone
  hour:=ajustTime(hour,offset)

  'error check for date parse.  Not sure if code is to blame or poor connection to test gps
  if day==0 or month==0 or year==0 or month > 12 or day >31
    SC.Clear
    return -1

  SC.Clear
  SC.Position(0,0)
  SC.Print(SN.Dec(hour))
  SC.Print(string(":"))
  SC.Print(SN.Dec(minute))
  SC.Print(string(":"))
  SC.Print(SN.Dec(Second))
  SC.Print(string("-"))
  SC.Print(SN.Dec(offset))
  SC.Position(1,0)

  SC.Print(SN.dec(month))
  SC.Print(string("/"))
  SC.Print(SN.dec(day))
  SC.Print(string("/"))
  SC.Print(SN.dec(year))
  SC.Position(2,0)
  SC.Print(date)

  rtc.init(17,16,18)
  rtc.config
  dow:=cn.DateToDOW(adjMonth,adjDay,adjYear)
  SC.Print(string("  "))
  SC.Print(SN.Dec(dow))
  rtc.setDatetime(adjMonth,adjDay,adjYear,dow,hour,minute,second)

  return 0

'Takes string Longitude and converts it to a float Google Maps can use, should be in new class?
'because of this functions hacky nature, I cannot save the concat strings.  I can directly print though
'Even though I know this is Uber wrong on many levels, I am calling the hardware directly here.  May God Forgive me.
pub PrintConvertCoord(Coord,Direction) | intValMain, intValRemainder, DecPos, divisor,intCoord, remainLen,MathCoord,RetVal,FINAL
  'hokay,if coordinate is 12151.2774W, do this:
  '121+(51.2774/60) //seperate by last 2 digits left of decimal
  ' =121.854623333
  'then * -1 because we are in Western Hemisphere

  RetVal:=string(" ")

  DecPos:=CheckDecVal(Coord)
  '51.2774/.000006=85462333333. Real ans is .85462333333333333333333333333333
  'need to go back from DecPos 2 left. intify it, run form.
  intCoord:=cn.Convert_ascii_string_to_fp(Coord)
  intValMain:=GetRegion(intCoord,DecPos)
  if cn.Convert_ascii_string_to_fp(str.Parse(str.StrRev(SN.dec(intCoord)),4,1)) > 5
    intValMain:=intValMain - 1

  'for the remainder, get string len of master, minus intValMain. then parse.
  remainLen:=StrSize(Coord)
  remainLen:=remainLen-StrSize(SN.dec(intValMain))
  'remove Decimal point
  remainLen:=remainLen-1
  intValRemainder:=cn.Convert_ascii_string_to_fp(str.StrRev(str.Parse(str.StrRev(SN.dec(intCoord)),0,remainLen)))

  'if DecPos==4
    MathCoord:=fm.FDiv(intValRemainder,0.06)
  if StrComp(Direction,string("W")) or StrComp(Direction,string("S"))
    RetVal:=string("-")
  'RetVal:=str.Concatenate(RetVal,intValMain)
  'RetVal:=str.Concatenate(RetVal,string("."))
  'RetVal:=str.Concatenate(RetVal,MathCoord)
  'RetVal:=string("TEST")
  'return RetVal
  'FINAL:=string(" ")
  'FINAL:=Str.Concatenate(RetVal,SN.dec(intValMain))
  'FINAL:=Str.Concatenate(FINAL,string("."))
  'FINAL:=Str.Concatenate(FINAL,SN.dec(MathCoord))
  'return FINAL
  'serial.init(1,30,4800)
  SC.Init
  SC.Print(RetVal)
  SC.Print(SN.dec(intValMain))
  SC.Print(string("."))
  SC.Print(SN.dec(MathCoord))

'Takes coordinate, strip off decimal values and calculates timeZone Region
pri GetRegion(Data,decVal)| tempString,ImportantDigit,mainCoord, divisor
'pass in string to get decimal index.  All instances I've seen are #####.####
'if the dec isn't in that spot, account for it
  if decVal==6
    divisor:=100000000
  if decVal==5
    divisor:=10000000
  if decVal==4
    divisor:=1000000
  if decVal==3
    divisor:=100000
  if decVal==2
    divisor:=10000
  if decVal==1
    divisor:=1000
  mainCoord:=Data/divisor
  'mainCoord is now set as the whole # part of the coordninate.
  'find out if conversion would add another int to mainCoord
  tempString:=SN.dec(Data)
  ImportantDigit:= str.Parse(str.StrRev(tempString),5,1)
  ImportantDigit:= cn.Convert_ascii_string_to_fp(ImportantDigit)
  if ImportantDigit > 5
    mainCoord:=mainCoord+1
  return mainCoord


pri CheckDecVal(lon)| revLon,pos
  revLon:=lon
  revLon:=str.StrRev(revLon)
  pos:= str.CharPos(revLon,".",0,StrSize(revLon))
  str.StrRev(revLon)
  return pos

pri ajustTime(hour,offset)
  if (hour + offset) < 0
    'corrections add or sub a day
    case (hour + offset)
      -1: hour:=23
      -2: hour:=22
      -3: hour:=21
      -4: hour:=20
      -5: hour:=19
      -6: hour:=18
      -7: hour:=17
      -8: hour:=16
      -9: hour:=15
      -10: hour:=14
      -11: hour:=13

  else 'too dumb for an else if....sigh
    if (hour+offset) > 23
      'eastern hemesphere
      case (hour+offset)
        24: hour:=0
        25: hour:=1
        26: hour:=2
        27: hour:=3
        28: hour:=4
        29: hour:=5
        30: hour:=6
        31: hour:=7
        32: hour:=8
        33: hour:=9
        34: hour:=10
    else
      hour:=hour+offset

  return hour

pri adjustDate(day,month,year,offset,hour)

  'check to see if needed
  if (hour+offset) >23 or (hour+offset) < 0
    'date needs to change
    if (hour+offset) > 23
      adjDay:=day+1
    else
      adjDay:=day-1
    calChange(adjDay,month,year)
  else
    adjDay:=day
    adjMonth:=month
    adjYear:=year

pri calChange(day,month,year) | alreadyCorrected
  alreadyCorrected:=false
  '31 day months
  if month==1 or month==3 or month==5 or month==7 or month==8 or month==10 or month==12
    alreadyCorrected:=true
    'going forward
    if day > 31
      month:=month+1
      day:=1
      if month > 12
        month:=1
        year:=year+1


    'going back
    if day < 1
      month:=month-1
      day:=rewindDays(month,year)
      'if was jan, now dec
      if month < 1
        month:=12
        day:=31
        year:=year-1


  '30 day months
  if month==4 or month==6 or month==9 or month==11
    if day > 30
      month:=month+1
      day:=1
    else
      if day < 1
        'going back
        month:=month-1
        day:=rewindDays(month,year)




  'Feb...include leap years
  if month== 2 and alreadyCorrected==false
    if cn.isLeapYear(year) ==true
      if day =>29
        if day <> 29
          day:=1
          month:=3
      else
        if day < 1
          day:=31
          month:=1
    else
      if day =>28
        if day <>28
          day:=1
          month:=3
      else
        if day < 1
          day:=31
          month:=1
  adjDay:=day
  adjMonth:=month
  adjYear:=year


pri rewindDays(month,year)| day
  case month
    4: day:=30
    6: day:=30
    9: day:=30
    11: day:=30
    2:
      if cn.isLeapYear(year) ==true
        day:=29
      else
        day:=28
   other: day:=31
  return day
