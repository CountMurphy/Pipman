CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  _GPSData=20
  _GPSPwr=21

obj
  serial : "Simple_Serial"
  SN : "Simple_Numbers"
  gps : "GPS_IO_mini"
  Maths : "FloatMath"

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
    if Maths.FRound(gps.satellites) > 0
      serial.str(gps.satellites)
