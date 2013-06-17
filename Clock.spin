obj
  SC : "Screen"
  rtc : "DS1302.spin"
  SN : "Simple_Numbers.spin"

'Remove this for final
CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

var
  long hour, minute, seconds
pub main

 ' SC.Init
  'waitcnt((clkfreq+cnt)*5)
  rtc.init(17,16,18)
  rtc.config
  rtc.setDatetime(01,17,07,3,5,59,50)
  seconds:=12
 ' SC.Init
 ' SC.On
 ' repeat
 '   waitcnt(clkfreq+cnt)
 '   rtc.readTime(@hour,@minute,@seconds)
 '   SC.print(string(" ",13))
 '   SC.print(SN.decx(hour,2))
 '   SC.print(string(":"))
 '   SC.print(SN.decx(minute,2))
 '   SC.print(string(":"))
 '   SC.print(SN.decx(seconds,2))


'http://playground.arduino.cc/Main/DS1302
'http://forums.parallax.com/showthread.php?128184-Serial-Objects-for-SPIN-Programming
'http://forums.parallax.com/showthread.php?132400-Copy-a-part-of-a-string-to-a-new-string
