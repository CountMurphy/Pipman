CON
  ledpin=0
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  _GPSData=20

obj
  serial : "Simple_Serial.spin"
  conv : "Simple_Numbers.spin"

pub main
  dira[21]:=1
  'wait 2 secs, power on GPS
  waitcnt(clkfreq+cnt)
  waitcnt(clkfreq+cnt)
  outa[21]:=1
  serial.init(_GPSData,30,4800)
  'dont forget to finalize after reading is done
  repeat
    serial.tx(serial.rx)
