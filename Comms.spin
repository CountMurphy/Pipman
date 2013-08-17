CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
obj
  serial : "Simple_Serial"
  TC     : "trackBallEx"
  SC     : "Screen"

pub Init
  serial.init(31,30,9600)
  SC.Init
  SC.MediaInit

pub ExportGPSSingle| dataByte
  SC.SetSectorGPS
  Transmit
  DisplayMsg
pub ExportGPSTrack
  SC.SetSectorGPS'change when working
  Transmit
  DisplayMsg
pub ImportCal

pri Transmit | dataByte
  dataByte:=0
  repeat until strcomp(dataByte,string("FF")) ==-1
    dataByte:=SC.ReadByte
    serial.str(dataByte)

pri DisplayMsg
  SC.Clear
  SC.Position(0,0)
  SC.Print(string("Export Complete"))
  waitcnt(clkfreq+cnt)
  waitcnt(clkfreq+cnt)

