CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  clock = 0
  nav = 1
  timer = 2
  cal = 3
  comm=4
  edit=5

obj
  SC : "Screen"
  TC : "trackBallEx"
  GPMenu : "gpsMenu"
  'CP : "ClockPage"
  Sen : "Sensors"

var
  long  currentItem

pub main: canExit
  SC.Init
  SC.On
  SC.Clear
  SC.TxtColor($FF,$E0)
  SC.TxtBackColor($00,$00)
  SC.Position(4,4)
  SC.Print(string("Clock"))
  SC.Position(4,14)
  SC.Print(string("Nav"))
  SC.Position(8,4)
  SC.Print(string("Timer"))
  SC.Position(8,14)
  SC.Print(string("Calendar"))
  SC.Position(12,4)
  SC.print(string("Comm"))
  SC.Position(12,14)
  SC.print(string("Edit"))
  Sen.StandBy

  SC.DrawRec(70,45,25,25,$F8,$00)
  currentItem:=clock
  canExit:=false

  'begin the polling
  repeat until canExit==true
    TC.Run

    if TC.isRight ==true
      ClearCurrent
      case currentItem
        clock: currentItem:=nav
        timer: currentItem:=cal
        comm: currentItem:=edit
      'draw currentItem
      DrawItem

    if TC.isLeft == true
      ClearCurrent
      case currentItem
        nav: currentItem:=clock
        cal: currentItem:=timer
        edit: currentItem:=comm
      DrawItem

    if TC.isDown ==true
      ClearCurrent
      case currentItem
        clock: currentItem:=timer
        timer: currentItem:=comm
        nav: currentItem:=cal
        cal: currentItem:=edit
      'draw currentItem
      DrawItem


    if TC.isUp ==true
      ClearCurrent
      case currentItem
        timer: currentItem:=clock
        comm: currentItem:=timer
        cal: currentItem:=nav
        edit: currentItem:=cal
      'draw currentItem
      DrawItem


    if TC.isPressed == true
      canExit:=true


  case currentItem
    nav:GPMenu.main
    clock:return 1

  'SC.FadeOut
  'SC.Off 'the double tap

pri DrawItem
  case currentItem
    clock: SC.DrawRec(70,45,25,25,$F8,$00)
    nav: SC.DrawRec(140,45,90,25,$F8,$00)
    timer: SC.DrawRec(70,80,25,60,$F8,$00)
    cal: SC.DrawRec(157,77,90,55,$F8,$00)
    comm: SC.DrawRec(70,110,25,90,$F8,$00)
    edit: SC.DrawRec(135,110,90,85,$F8,$00)

pri ClearCurrent
  case currentItem
    clock:  SC.DrawRec(70,45,25,25,$00,$00)
    nav: SC.DrawRec(140,45,90,25,$00,$00)
    timer: SC.DrawRec(70,80,25,60,$00,$00)
    cal: SC.DrawRec(157,77,90,55,$00,$00)
    comm: SC.DrawRec(70,110,25,90,$00,$00)
    edit: SC.DrawRec(135,110,90,85,$00,$00)


