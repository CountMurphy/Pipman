CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  _GPSData=20
  _GPSPwr=21

obj
  serial : "Simple_Serial"
  SN : "Simple_Numbers"
  gps : "GPS_IO_mini"
  fm : "FloatMath"
  tz : "TimeZone"
  cn: "Converter"
var
  'long sats
  'long fp_number
  'long testNum
  long cog
pub Init
  dira[_GPSPwr]:=1
  outa[_GPSPwr]:=1
  cog:=gps.start
  'start
  'dont forget to finalize after reading is done
   serial.init(31,30,9600)
  'repeat
  '  sats:= cn.StrToDec(gps.satellites)
   ' if sats => 3
   '   serial.str(SN.dec(sats))
      'serial.str(gps.latitude)
      'serial.str(gps.N_S)
      'serial.str(string("     "))
      'serial.str(gps.longitude)
      'serial.str(gps.E_W)
      'serial.str(string("    "))


'      serial.str(SN.dec(tz.GetTimeZone(gps.longitude,gps.E_W)))

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
pub Kill
  cogstop(cog)
  outa[_GPSPwr]:=0

