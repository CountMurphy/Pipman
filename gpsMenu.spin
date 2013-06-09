CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
  single = 0
  track = 1
  save = 2
  google = 3

obj
  SC : "Screen"
  TC : "trackBallEx"
  GPS : "gps"
  SN : "Simple_Numbers"
var
  long  currentItem

pub main| canExit
  SC.Init
  SC.Clear
  SC.TxtColor($FF,$E0)
  SC.Position(4,4)
  SC.Print(string("Single"))
  SC.Position(4,14)
  SC.Print(string("Track"))
  SC.Position(8,4)
  SC.Print(string("Save"))
  SC.Position(8,14)
  SC.Print(string("Google"))

  SC.DrawRec(70,45,25,25,$F8,$00)
  currentItem:=single
  canExit:=false

  repeat until canExit==true
    TC.Run

    if TC.isRight ==true
      ClearCurrent
      case currentItem
        single: currentItem:=track
        save: currentItem:=google
      'draw currentItem
      DrawItem

    if TC.isLeft == true
      ClearCurrent
      case currentItem
        track: currentItem:=single
        google: currentItem:=save

      DrawItem

    if TC.isDown ==true
      ClearCurrent
      case currentItem
        single: currentItem:=save
        track: currentItem:=google
      'draw currentItem
      DrawItem


    if TC.isUp ==true
      ClearCurrent
      case currentItem
        save: currentItem:=single
        google: currentItem:=track
      'draw currentItem
      DrawItem


    if TC.isPressed == true
      case currentItem
        single:
         GPS.Init
         'SC.Print(SN.dec(GPS.SatCount))
         SC.FadeOut
         repeat until GPS.SatCount => 3
          'SC.Print(SN.dec(GPS.SatCount))
         SC.FadeIn
         SC.Clear
         'SC.Print(SN.dec(GPS.SatCount))
         SC.Print(GPS.Latitude)
         SC.Print(GPS.NS)
         SC.Position(1,0)
         SC.Print(GPS.Longitude)
         SC.Print(GPS.EW)
         GPS.Kill
        google:
          GPS.Init
         'SC.Print(SN.dec(GPS.SatCount))
          SC.FadeOut
          repeat until GPS.SatCount => 3
            'SC.Print(SN.dec(GPS.SatCount))
         SC.FadeIn
         SC.Clear
         GPS.PrintStdLat
         SC.Position(1,0)
         GPS.PrintStdLong
         GPS.Kill
      canExit:=true

pri DrawItem
  case currentItem
    single: SC.DrawRec(70,45,25,25,$F8,$00)
    track: SC.DrawRec(140,45,90,25,$F8,$00)
    save: SC.DrawRec(70,80,25,60,$F8,$00)
    google: SC.DrawRec(157,77,90,55,$F8,$00)

pri ClearCurrent
  case currentItem
    single:  SC.DrawRec(70,45,25,25,$00,$00)
    track: SC.DrawRec(140,45,90,25,$00,$00)
    save: SC.DrawRec(70,80,25,60,$00,$00)
    google: SC.DrawRec(157,77,90,55,$00,$00)

