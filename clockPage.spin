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
  GPS : "gps"
  fd  : "FullDuplexSerial"
  CL  : "Calendar"
var
  long timer
  long stack[20]

pub main| month,day,dow,year,hour,minute,second,go
  dira[21]:=1
  outa[21]:=0 'Disable GPS on start
  repeat 2
    waitcnt(clkfreq+cnt)
  SC.Init
  SC.On
  SC.Print(string("Pipman Wristputer"))
  SC.Position(1,0)
  SC.Print(string("Version 1.3"))
  repeat 2
    waitcnt(clkfreq+cnt)
  SC.Clear
  SC.MediaInit
  SC.ShowFrame(1)
  SC.Clear
  'Set DST and get current local datetime
  day:=0
  month:=0
  year:=0
  timer:=0
  DSTConfig
  go:=true
  rtc.init(17,16,18)
  repeat
    TC.Run
    if TC.isPressed
      repeat until TC.isPressed==false
        TC.Run
      go:=false
      SC.ShowFrame(1) 'cant display wallpaper unless this is access first.  Odd
      SC.Clear

      'check for alarm dates
      Rtc.readDate(@day,@month,@year,@dow)
      CL.CheckForDate(day,month,year)

      SC.SetByteAddr(Config.Wallpaper(0),Config.Wallpaper(1),Config.Wallpaper(2),Config.Wallpaper(3))
      SC.DisplayImage
      ShowScreen(day,month,year,hour,minute,second,dow)
      SC.FadeOut
  '    Sen.StandBy
      TC.KillLED
   ' if TC.isPressed == true
      timer:=0
    '  go:=true


pri ShowScreen(day,month,year,hour,minute,second,dow)| exitCode
  SC.FadeIn
  SC.ShowFrame(1) 'cant display wallpaper unless this is access first.  Odd
  SC.Clear
  SC.SetByteAddr(Config.Wallpaper(0),Config.Wallpaper(1),Config.Wallpaper(2),Config.Wallpaper(3))
  SC.DisplayImage
  Sen.Resume
  repeat until timer =>50
    SC.TxtBackColor($D3,$C4)
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
    SC.TxtBackColor($00,$00)
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


pri DSTConfig| DST
  SC.TxtColor($FF,$E0)
  SC.Position(0,7)
  SC.Print(string("is DST?"))
  SC.Position(7,4)
  SC.FontSize(2)
  SC.Print(string("Yes  No"))
  SC.FontSize(1)
 TC.LEDOn
  SC.DrawRec(75,75,25,50,$F8,$00)
  DST:=true
  repeat
    TC.Run
    if TC.isPressed==true
      repeat until TC.isPressed==false
        TC.Run
      SC.Clear
      gps.init
      SC.Clear
      gps.ProcessLocalDateTime(DST)
      waitcnt(clkfreq+cnt)
      SC.FadeOut
      gps.kill
      quit

    if TC.isRight == true
      SC.DrawRec(75,75,25,50,$00,$00)
      SC.DrawRec(90,75,130,50,$F8,$00)
      SC.Click
      DST:=false

    if TC.isLeft == true
      SC.DrawRec(75,75,25,50,$F8,$00)
      SC.DrawRec(90,75,130,50,$00,$00)
      SC.Click
      DST:=true
