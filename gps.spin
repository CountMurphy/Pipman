CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  _GPSData=20
  _GPSPwr=21

obj
  serial : "Simple_Serial"
  SN     : "Simple_Numbers"
  gps    : "GPS_IO_mini"
  fm     : "FloatMath"
  tz     : "TimeZone"
  cn     : "Converter"
  SC     : "Screen"
  TC     : "trackBallEx"
var
  'long sats
  'long fp_number
  'long testNum
  long cog
pub Init
  dira[_GPSPwr]:=1
  outa[_GPSPwr]:=1
  SC.Init
  cog:=gps.start


pub SatCount
  return cn.StrToDec(gps.satellites)
pub Latitude
  return gps.Latitude
pub Longitude
  return gps.Longitude
pub NS
  return gps.N_S
pub EW
  return gps.E_W
pub PrintStdLat
  return tz.PrintConvertCoord(GPS.Latitude,GPS.N_S)
pub PrintStdLong
  return tz.PrintConvertCoord(GPS.Longitude,GPS.E_W)
pub PrintAlt
  return gps.GPSaltitude
pub Kill
  gps.stop
  outa[_GPSPwr]:=0
pub ProcessLocalDateTime(DST)|goOn
  SC.SetByteAddr($00,$00,$00,$00)
  goOn:=PlaySpinnerWhileLocking(400)
  if goOn==0
    repeat until tz.ParseCurrentDateTime(gps.time,gps.date,gps.longitude,gps.E_W,DST) <> -1

pub PlaySpinnerWhileLocking(totalFrames)|frame
  frame:=0
  repeat until cn.StrToDec(gps.satellites) => 3
    TC.Run
    if TC.isPressed ==true
      SC.FadeIn
      SC.Clear
      Kill
      return -1
    else
      if frame < totalFrames
        SC.ShowFrame(frame++)
      else
        if frame <> 700
          SC.FadeOut
          frame:=700
  SC.SoundNotifiy
  return 0

  'Not to be used with date time checking.  Have seperate parsing checks in Timezone class...for reasons
pub isDataValid
  if gps.GPSaltitude ==$00 or gps.Longitude==$00 or gps.E_W==$00 or gps.Latitude == $00 or gps.N_S == $00
    return false
  else
    return true
