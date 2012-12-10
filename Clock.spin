obj
  serial : "Simple_Serial.spin"

'Remove this for final
CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

pub main
  serial.init(31,30,9600)
  'waitcnt((clkfreq+cnt)*5)
  repeat
    serial.str(string("test"))
    waitcnt(clkfreq+cnt)

