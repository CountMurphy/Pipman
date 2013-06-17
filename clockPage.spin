CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

obj
  Sen : "Sensors"
  Rtc : "DS1302"
  Config : "Config"
  SC : "Screen"
  Conver: "Converter"
  SN : "Simple_Numbers"
  MN : "Menu"
  TC : "trackBallEx"
var
  long timer

pub main| month,day,dow,year,hour,minute,second,go
  SC.Init
  SC.On

  'set clock
  SetClock
  day:=0
  month:=0
  year:=0
  timer:=0
  go:=true
  repeat
    TC.Run
    if TC.isPressed
      repeat until TC.isPressed==false
        TC.Run
      go:=false
      TC.LEDOn
      SC.ShowFrame(1) 'cant display wallpaper unless this is access first.  Odd
      SC.Clear
      SC.SetByteAddr(Config.Wallpaper(0),Config.Wallpaper(1),Config.Wallpaper(2),Config.Wallpaper(3))
      SC.DisplayImage
      ShowScreen(day,month,year,hour,minute,second,dow)
      SC.FadeOut
  '    Sen.StandBy
      TC.KillLED
   ' if TC.isPressed == true
      timer:=0
    '  go:=true


  MN.Main

pri ShowScreen(day,month,year,hour,minute,second,dow)| exitCode
  SC.FadeIn
  SC.ShowFrame(1) 'cant display wallpaper unless this is access first.  Odd
  SC.Clear
  SC.SetByteAddr(Config.Wallpaper(0),Config.Wallpaper(1),Config.Wallpaper(2),Config.Wallpaper(3))
  SC.DisplayImage
  Sen.Resume
  SC.TxtBackColor($D3,$C4)
  repeat until timer =>50
    SC.TxtColor($00,$00)
    'Print temp
    SC.Position(0,0)
    Sen.PrintTemp
    'print date
    SC.Position(0,7)
    Rtc.readDate(@day,@month,@year,@dow)
    SC.Print(SN.decx(month,2))
    SC.Print(string("-"))
    SC.Print(SN.decx(day,2))
    SC.Print(string("-"))
    SC.Print(SN.decx(year,2))
    SC.Position(1,7)
    case dow
      0: SC.Print(string(" Sunday"))
      1: SC.Print(string(" Monday"))
      2: SC.Print(string(" Tuesday"))
      3: SC.Print(string(" Wednsday"))
      4: SC.Print(string(" Thursday"))
      5: SC.Print(string(" Friday"))
      6: SC.Print(string(" Saturday"))
    'Print Compass
    SC.Position(0,17)
    Sen.PrintDeg
    SC.Position(1,18)
    Sen.PrintHeading
    'print time
    SC.TxtColor($FF,$E0)
    SC.Position(7,3)
    SC.FontSize(2)
    Rtc.readTime(@hour,@minute,@second)
    SC.Print(SN.decx(hour,2))
    SC.Print(string(":"))
    SC.Print(SN.decx(minute,2))
    SC.Print(string(":"))
    SC.Print(SN.decx(second,2))
    SC.FontSize(1)
    timer:=timer+1
    TC.Run'poll button info
    if TC.isPressed ==true
      Sen.StandBy
      exitCode:=MN.Main
      if exitCode==1
        timer:=0
        ShowScreen(day,month,year,hour,minute,second,dow)
   ' waitcnt(clkfreq+cnt)

pri SetClock| dow
  rtc.init(17,16,18)
  rtc.config
  dow:=Conver.DateToDOW(06,16,13)
  rtc.setDatetime(06,16,13,dow,5,59,50)
