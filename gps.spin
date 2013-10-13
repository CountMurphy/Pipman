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
  return gps.Altitude
pub Kill
  gps.stop
  outa[_GPSPwr]:=0
pub ProcessLocalDateTime(DST)
  SC.SetByteAddr($00,$00,$00,$00)
  PlaySpinnerWhileLocking(500)
  repeat until tz.ParseCurrentDateTime(gps.time,gps.date,gps.longitude,gps.E_W,DST) <> -1

pub PlaySpinnerWhileLocking(totalFrames)|frame
  frame:=0
  repeat until cn.StrToDec(gps.satellites) => 3
    TC.Run
    if TC.isPressed ==true
      SC.FadeIn
      SC.Clear
      Kill
      return
    else
      if frame < totalFrames
        SC.ShowFrame(frame++)
      else
        if frame <> 700
          SC.FadeOut
          frame:=700
