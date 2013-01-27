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

var
  long sats
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
    sats:= StrToDec(gps.satellites)
    if sats >= 3
      serial.str(SN.dec(sats))


pri StrToDec(stringptr) : value | char, index, multiply

    '' Converts a zero terminated string representation of a decimal number to a value

    value := index := 0
    repeat until ((char := byte[stringptr][index++]) == 0)
       if char => "0" and char =< "9"
          value := value * 10 + (char - "0")
    if byte[stringptr] == "-"
       value := - value
