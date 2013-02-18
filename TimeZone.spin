obj
  cn : "Converter"
  fm : "FloatMath"
  Str: "STRINGS2"
  SN : "Simple_Numbers"

pub GetTimeZone(lon)
  lon:=GetRegion(lon)
  'UTC-8, PST
  if lon<=135 and lon>=120
    'offset 8 hours
    return 8
  'UTC-7
  if lon<=120 and lon>=105
    'offset by 7


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
pri GetRegion(Data)| tempString,ImportantDigit,mainCoord
  mainCoord:=Data/1000000
  'mainCoord is now set as the whole # part of the coordninate.
  'find out if conversion would add another int to mainCoord
  tempString:=SN.dec(Data)
  ImportantDigit:= str.Parse(str.StrRev(tempString),5,1)
  ImportantDigit:= cn.Convert_ascii_string_to_fp(ImportantDigit)
  if ImportantDigit > 5
    mainCoord:=mainCoord+1
  return mainCoord
