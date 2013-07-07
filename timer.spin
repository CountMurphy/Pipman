CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  run=0
  mode=1
  reset=2
  menu=3
  'mode options
  sw=4 'stop watch
  cd=5 'countdown

obj
  Rtc : "DS1302"
  SC : "Screen"
  SN : "Simple_Numbers"
  TC : "trackBallEx"

var
  long hour
  long minute
  long second
  long lastSec
  long curMode
  long isFaded
  long tickCounter 'to be used to trigger fadeout
  long isSetupMode 'seperate mode for countdown setup.
pub main | curPOS, runSw,runCd
  repeat until TC.isPressed == false
    TC.Run
  init
  isFaded:=false
  lastSec:=0
  curPOS:=0
  runSw:=false
  runCd:=false
  curMode:=sw
  isSetupMode:=false
  repeat
    TC.Run

    if tickCounter == 15 and isFaded == false
        isFaded:=true
        SC.FadeOut

    if runSw ==true
      swRun
    if runCd ==true
      if cdRun == 1
        runCd:=false
    if TC.isRight == true
      clearSetMenu
      case curPOS
        run:
          SC.DrawRec(65,120,31,108,$F8,$00)
          SC.DrawRec(23,120,00,108,$00,$00)
          curPOS:=mode
        mode:
          SC.DrawRec(65,120,31,108,$00,$00)
          SC.DrawRec(115,120,75,108,$F8,$00)
          curPOS:=reset
        reset:
          SC.DrawRec(115,120,75,108,$00,$00)
          SC.DrawRec(155,120,124,108,$F8,$00)
          curPOS:=menu
    if TC.isLeft == true
      clearSetMenu
      case curPOS
        mode:
          SC.DrawRec(23,120,00,108,$F8,$00)
          SC.DrawRec(65,120,31,108,$00,$00)
          curPOS:=run
        reset:
          SC.DrawRec(65,120,31,108,$F8,$00)
          SC.DrawRec(115,120,75,108,$00,$00)
          curPOS:=mode
        menu:
          SC.DrawRec(115,120,75,108,$F8,$00)
          SC.DrawRec(155,120,124,108,$00,$00)
          curPOS:=reset

    if TC.isUp == true
      'ensure we are in the right mode
      if curMode == cd
          isSetupMode:=true
          SC.DrawRec(95,85,65,100,$F8,$00)
          case curPOS
            mode:SC.DrawRec(65,120,31,108,$00,$00)
            reset: SC.DrawRec(115,120,75,108,$00,$00)
            menu: SC.DrawRec(155,120,124,108,$00,$00)
            run: SC.DrawRec(23,120,00,108,$00,$00)


    if TC.isPressed == true
      if isFaded == true
        tickCounter:=0
        isFaded:=false
        SC.FadeIn
      else
        if isSetupMode == true
          SetTimer
          curPOS:=run
          isSetupMode:=false
        else
          case curPOS
            run:
              if curMode ==sw
                if runSw ==true
                  runSw:=false
                  tickCounter:=0
                else
                  runSw:=true
              else
                if runCd == true
                  runCd:=false
                  tickCounter:=0
                else
                  runCd:=true
            mode:
              runSw:=false
              runCd:=false
              curPOS:=run
              if curMode == sw
                'to countdown
                hour:=1
                minute:=0
                second:=0
                CDInit
                curMode:=cd
              else
                init
                curMode:=sw
            reset:
              if curMode == sw
                init
              else
                hour:=1
                minute:=0
                CDInit
              curPOS:=run
            menu:
              return
      repeat until TC.isPressed==false
        TC.Run

pri clearSetMenu
  if curMode == cd
    SC.DrawRec(95,85,65,100,$00,$00)
    isSetupMode:=false

pri init
  hour:=0
  minute:=0
  second:=0
  SC.Init
  SC.Clear
  SC.FontSize(0)
  SC.TxtColor($FF,$E0)
  SC.Position(7,4)
  SC.FontSize(2)
  SC.Print(SN.decx(hour,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(minute,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(second,2))
  'Draw menu items
  SC.FontSize(1)
  SC.Position(0,7)
  SC.Print(string("Stopwatch"))
  SC.Position(14,0)
  SC.Print(string("Run  Mode  Reset  Menu"))
  SC.DrawRec(23,120,00,108,$F8,$00)

'Countdown init
pri CDInit

  SC.Clear
  SC.FontSize(0)
  SC.Position(7,4)
  SC.FontSize(2)
  SC.Print(SN.decx(hour,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(minute,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(second,2))
  'Draw menu items
  SC.FontSize(1)
  SC.Position(0,7)
  SC.Print(string("Count Down"))
  SC.Position(14,0)
  SC.Print(string("Run  Mode  Reset  Menu"))
  SC.Position(11,10)
  SC.Print(string("Set"))
  SC.DrawRec(23,120,00,108,$F8,$00)



pri swRun| curHour,curMinute,curSecond
  Rtc.init(17,16,18)
  Rtc.readTime(@curHour,@curMinute,@curSecond)
  if curSecond <> lastSec
    second:=second+1
  if second > 59
    second:=0
    minute:=minute+1
  if minute > 59
    minute:=0
    hour:=hour+1

  if curSecond <> lastSec
    if isFaded == false
      UpdateDisplay
    tickCounter:=tickCounter+1
  lastSec:=curSecond

pri cdRun| curHour,curMinute,curSecond
  Rtc.init(17,16,18)
  Rtc.readTime(@curHour,@curMinute,@curSecond)
  if curSecond <> lastSec
    second:=second-1
    if second ==0 and hour == 0 and minute==0
      UpdateDisplay
      SC.Beep
      return 1
  if second < 0
    second:=59
    minute:=minute-1
  if minute < 0
    minute:=59
    hour:=hour-1

  if curSecond <> lastSec
    if isFaded == false
      UpdateDisplay
    tickCounter:=tickCounter+1
  lastSec:=curSecond
pri UpdateDisplay
  SC.FontSize(0)
  SC.Position(7,4)
  SC.FontSize(2)
  SC.Print(SN.decx(hour,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(minute,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(second,2))

pri SetTimer| canExit,setPos
  repeat until TC.isPressed == false
    TC.Run
    'do nothing
  canExit:=false
  setPos:=0
  SC.Clear
  SC.FontSize(0)
  SC.Position(7,4)
  SC.FontSize(2)
  SC.Print(SN.decx(hour,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(minute,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(second,2))
  SC.DrawTri($28,$5A,$18,$66,$38,$66,$F8,$00)'hour
  repeat until canExit==true
    TC.Run
    if TC.isRight==true
      case setPos
        0:
          SC.DrawTri($28,$5A,$18,$66,$38,$66,$00,$00)'hour
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$F8,$00)'minute
          setPos:=1
        1:
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$00,$00)'minute
          SC.DrawTri($7D,$5A,$6D,$66,$8D,$66,$F8,$00)'second
          setPos:=2

    if TC.isLeft == true
      case setPos
        2:
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$F8,$00)'minute
          SC.DrawTri($7D,$5A,$6D,$66,$8D,$66,$00,$00)'second
          setPos:=1
        1:
          SC.DrawTri($28,$5A,$18,$66,$38,$66,$F8,$00)'hour
          SC.DrawTri($50,$5A,$40,$66,$60,$66,$00,$00)'minute
          setPos:=0

    if TC.isUp == true
      case setPos
        0:
          hour:=hour+1
          if hour > 24
            hour:=0
        1:
          minute:=minute+1
          if minute > 59
            minute:=0
        2:
          second:=second+1
          if second > 59
            second:=0
      DrawTime

    if TC.isDown == true
      case setPos
        0:
          hour:=hour-1
          if hour < 0
            hour:=59
        1:
          minute:=minute-1
          if minute < 0
            minute:=59
        2:
          second:=second-1
          if second < 0
            second:=59
      DrawTime

    if TC.isPressed == true
      repeat until TC.isPressed == false
        TC.Run
        'do nothing
      canExit:=true
  'exit loop
  cdInit

pri DrawTime
  SC.FontSize(0)
 ' SC.TxtColor($FF,$E0)
  SC.Position(7,4)
  SC.FontSize(2)
  SC.Print(SN.decx(hour,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(minute,2))
  SC.Print(string(":"))
  SC.Print(SN.decx(second,2))
