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
  long sats
  long fp_number
  long testNum

pub main
  dira[_GPSPwr]:=1
  'wait 2 secs, power on GPS
  waitcnt(clkfreq+cnt)
  waitcnt(clkfreq+cnt)
  outa[_GPSPwr]:=1
  gps.start
  'start
  serial.init(1,30,4800)
  'dont forget to finalize after reading is done
  repeat
    sats:= cn.StrToDec(gps.satellites)
    if sats => 3
      'serial.str(SN.dec(sats))
      'serial.str(gps.latitude)
      'serial.str(gps.N_S)
      'serial.str(string("     "))
      'serial.str(gps.longitude)
      'serial.str(gps.E_W)
      'serial.str(string("    "))


      'serial.str(fs.FloatToString(tz.ConvertToSTD(string("1057.4999"))))
      serial.str(string("    "))



