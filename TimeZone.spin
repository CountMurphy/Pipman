obj
  cn : "Converter"
  fm : "FloatMath"
  Str: "STRINGS2"
  SN : "Simple_Numbers"

  serial : "Simple_Serial"

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

'Takes string Longitude and converts it to a float Google Maps can use
pub ConvertToSTD(Coord) | intVal, tests
  'hokay,if coordinate is 12151.2774W, do this:
  '121+(51.2774/60) //seperate by last 2 digits left of decimal
  ' =121.854623333
  'then * -1 because we are in Western Hemisphere

  'despite its horrid name, this really just converts to int
  intVal:=cn.Convert_ascii_string_to_fp(Coord)
  tests:=fm.FDiv(51.2774,60)'notes...theres no way to div 51.2774/60
  return tests



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

