CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
obj
  serial : "Simple_Serial"
  TC: "trackBallEx"



pub Init
  serial.init(27,26,9600)
  repeat
    TC.Run
    if TC.isPressed==true
      repeat until TC.isPressed==false
        TC.Run
      TC.LEDOn
    'waitcnt(clkfreq+cnt)
      repeat
        serial.str(string("test   "))
