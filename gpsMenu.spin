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

pub main| canExit,frame
  frame:=0
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
  TC.Run
    if TC.isPressed == true
      repeat until TC.isPressed==false
        TC.Run
  repeat until canExit==true
    TC.Run

    if TC.isRight ==true
      SC.Click
      ClearCurrent
      case currentItem
        single: currentItem:=track
        save: currentItem:=google
      'draw currentItem
      DrawItem

    if TC.isLeft == true
      SC.Click
      ClearCurrent
      case currentItem
        track: currentItem:=single
        google: currentItem:=save

      DrawItem

    if TC.isDown ==true
      SC.Click
      ClearCurrent
      case currentItem
        single: currentItem:=save
        track: currentItem:=google
      'draw currentItem
      DrawItem


    if TC.isUp ==true
      SC.Click
      ClearCurrent
      case currentItem
        save: currentItem:=single
        google: currentItem:=track
      'draw currentItem
      DrawItem


    if TC.isPressed == true
      TC.Run
      repeat until TC.isPressed==false
        'do nothing
        TC.Run
      case currentItem
        single:
         GPS.Init
         SC.SetByteAddr($00,$00,$00,$00)
         GPS.PlaySpinnerWhileLocking(500)
         SC.FadeIn
         SC.Clear
         'SC.Print(SN.dec(GPS.SatCount))
         Print
         GPS.Kill
         TC.WaitForBtnPress
         return
        save:
          GPS.Init
          SC.FadeOut
          repeat until GPS.SatCount=>3
            'Do nothing
            TC.Run
            if TC.isPressed ==true
              GPS.Kill
              quit
          SC.FadeIn
          SC.Clear
          'prepare card
          SC.MediaInit
          SC.SetByteAddr($00,$00,$00,$00)
          SC.ShowFrame(15)
          SC.Clear
          SC.SetSectorGPS
          Print
          'Save that mother
          SaveData
          SC.Flush
          GPS.Kill
        track:
          SC.MediaInit
          SC.SetByteAddr($00,$00,$00,$00)
          GPS.Init

          'wait for connection
          GPS.PlaySpinnerWhileLocking(250)
            TC.Run
            if TC.isPressed==true
              SC.On
              SC.Clear
              SC.Print(string("Aborted"))
              GPS.Kill
              repeat 2
                waitcnt(clkfreq+cnt)
              return
          SC.SetSectorGPSMap
          SC.FadeOut

          'save coords
          TC.Run
          repeat until TC.isPressed==true
            repeat until GPS.SatCount => 3
               TC.Run
               if TC.isPressed==true
                 quit
            SaveData
            GPS.Kill
            repeat 60
              TC.Run
              if TC.isPressed==true
                quit
              waitcnt(clkfreq+cnt)
            TC.Run
            if TC.isPressed==true
              quit
            GPS.Init
            waitcnt(clkfreq+cnt)
            waitcnt(clkfreq+cnt)'ensure that pulled data is current

          SC.Flush
          GPS.Kill
          SC.FadeIn
          SC.Clear
          SC.Print(string("Coordinates Saved"))
          repeat 2
            waitcnt(clkfreq+cnt)
        google:
          GPS.Init
         'SC.Print(SN.dec(GPS.SatCount))
          SC.Clear
          SC.Print(string("Warning, not accurate"))
          SC.Position(1,0)
          SC.Print(string("up to 50 meters"))
          SC.Position(0,0)
          waitcnt(clkfreq+cnt)
          waitcnt(clkfreq+cnt)
          SC.Clear
          SC.SetByteAddr($00,$00,$00,$00)
          repeat until GPS.SatCount => 3
            'SC.Print(SN.dec(GPS.SatCount))
            TC.Run
             if TC.isPressed ==true
               quit
             else
               if frame < 500
                 SC.ShowFrame(frame)
                 frame++
               else
                 SC.FadeOut

         SC.FadeIn
         SC.Clear
         GPS.PrintStdLat
         SC.Position(1,0)
         GPS.PrintStdLong
         GPS.Kill
         TC.WaitForBtnPress
      canExit:=true

pri SaveData
  SC.SaveStr(string("$Lat:"))
  SC.SaveStr(GPS.Latitude)
  SC.SaveStr(GPS.NS)
  SC.SaveStr(string("$Lon:"))
  SC.SaveStr(GPS.Longitude)
  SC.SaveStr(GPS.EW)
  SC.SaveStr(string("$Alt:"))
  SC.SaveStr(GPS.PrintAlt)
pri Print
  SC.Print(GPS.Latitude)
  SC.Print(GPS.NS)
  SC.Position(1,0)
  SC.Print(GPS.Longitude)
  SC.Print(GPS.EW)
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

