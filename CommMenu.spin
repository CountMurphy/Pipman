CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

obj
  SC : "Screen"
  TC : "trackBallEx"
  CM : "Comms"

pub main |currentItem
  CM.Init
  SC.Init
  SC.Clear
  SC.TxtColor($FF,$E0)
  SC.Position(4,4)
  SC.Print(string("Ex Cord"))
  SC.Position(4,14)
  SC.Print(string("Ex Map"))
  SC.Position(8,4)
  SC.Print(string("Im Cal"))
  SC.Position(8,14)
  SC.Print(string("Del Cal"))

  SC.DrawRec(80,45,25,25,$F8,$00)
  currentItem:=0

  TC.Run



  repeat until TC.isPressed==true
    TC.Run
    if TC.isRight==true
      case currentItem
        0:
          SC.DrawRec(95,45,145,25,$F8,$00)'map
          SC.DrawRec(80,45,25,25,$00,$00)
          currentItem:=1
        2:
          SC.DrawRec(75,75,25,55,$00,$00)
          SC.DrawRec(150,75,95,55,$F8,$00)'del
          currentItem:=3

    if TC.isLeft==true
      case currentItem
        1:
          SC.DrawRec(95,45,145,25,$00,$00)'map
          SC.DrawRec(80,45,25,25,$F8,$00)
          currentItem:=0
        3:
          SC.DrawRec(75,75,25,55,$F8,$00)
          SC.DrawRec(150,75,95,55,$00,$00)'del
          currentItem:=2

    if TC.isDown==true
      case currentItem
        0:
          SC.DrawRec(80,45,25,25,$00,$00)
          SC.DrawRec(75,75,25,55,$F8,$00)'cal
          currentItem:=2
        1:
          SC.DrawRec(95,45,145,25,$00,$00)
          SC.DrawRec(150,75,95,55,$F8,$00)'del
          currentItem:=3

    if TC.isUp==true
      case currentItem
        2:
          SC.DrawRec(75,75,25,55,$00,$00)'cal
          SC.DrawRec(80,45,25,25,$F8,$00)
          currentItem:=0
        3:
          SC.DrawRec(95,45,145,25,$F8,$00)'map
          SC.DrawRec(150,75,95,55,$00,$00)'del
          currentItem:=1

  repeat until TC.isPressed==false
    TC.Run

  'out of menu, launch action

  case currentItem
    0:
      CM.ExportGPSSingle
    1:
      CM.ExportGPSTrack
    2:
      CM.ImportCal
    3:
      CM.DelCal
