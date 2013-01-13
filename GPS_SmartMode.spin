{{ ***********************************
   *  GPS Smart Mode Object          *
   *  (C) 2007 Gary Noel Boone, PhD  *
   ***********************************

   This object provides access to the Smart Mode of the Parallax GPS module. It provides
   accessors for each Smart Mode function. For the time and date functions, GPS Smart Mode
   Object will automatically convert the UTC times returned by the GPS module into local
   times, accounting for both the time zone and Daylight Saving Time.
   

   Hardware Connections:

   The GPS Module can be connected to the Propeller Chip's P0 pin through a 1k resistor.
   For the demo board, the connections to the labelled header are as follows:
     
            ┌──────────────────┐          ┌──────────────────┐ 
            │                  │          │                  │ 
            │             VSS ┼──────────┤ GND              │ 
            │ Propeller        │          │        GPS       │ 
            │ Demo        VDD ┼──────────┤ VCC    Receiver  │
            │ Board            │    1k    │        Module    │ 
            │              P0 ┼────────┤ SIO              │  
            │                  │          │                  │ 
            │                  │         ┤ /RAW             │  
            └──────────────────┘          └──────────────────┘ 

                                                                            
   Software Use:

   The GPS Smart Mode Object can automatically localize the UTC times returned from the
   GPS module. To use it, you need to initialize two variables:
      - the desired time zone
      - whether or not to allow the use of Daylight Saving Time

   Example:
      OBJ
        GPS   : "GPS_SmartMode"

      PUB start | x, y
        GPS.start(GPS#PACIFIC_TIME, TRUE)                   ' Start the GPS object with localization

   See the included demo for complete usage samples.
    
}}


CON
        ' US time zones. Pass these into the start function to set the time zone.         
        EASTERN_TIME            = -5                    ' Eastern Standard Time
        CENTRAL_TIME            = -6                    ' Central Standard Time 
        MOUNTAIN_TIME           = -7                    ' Mountain Standard Time
        PACIFIC_TIME            = -8                    ' Pacific Standard Time
        ALASKAN_TIME            = -9                    ' Alaskan Standard Time
        HAWAIIAN_TIME           = -10                   ' Hawaii-Aleutian Standard Time

        ' GPS unit commands
        GPS_GetInfo             = 0                     ' (2 bytes) Hardware, Firmware
        GPS_GetValid            = 1                     ' (1 byte)  0 = Not Valid, 1 = Valid
        GPS_GetSats             = 2                     ' (1 byte)
        GPS_GetTime             = 3                     ' (3 bytes) UTC, Hours, Minutes, Seconds
        GPS_GetDate             = 4                     ' (3 bytes) UTC, Day, Month, Year
        GPS_GetLat              = 5                     ' (5 bytes) Degrees, Minutes, Fractional Minutes (Word), Direction (0 = N, 1 = S)
        GPS_GetLong             = 6                     ' (5 bytes) Degrees, Minutes, Fractional Minutes (Word), Direction (0 = E, 1 = W) 
        GPS_GetAlt              = 7                     ' (word) in tenths of meters                                             
        GPS_GetSpeed            = 8                     ' (word) in tenths of knots
        GPS_GetHead             = 9                     ' (word) in tenths of degrees

        
OBJ

  Ser   : "FullDuplexSerial"
  F     : "FloatMath"
 ' Cal   : "Calendar"

  
VAR

  long  rx, tx, baud                                    ' for the serial object
  long  _time_offset, _allow_DST

  
DAT

  HardwareStr byte      "x.x", 0
  FirmwareStr byte      "x.x", 0

  
PUB start(offset, allowDST)
'' Initialize the GPS Smart Mode Object
  _time_offset := offset
  _allow_DST := allowDST
  
  ' Start the serial object
  tx := rx := 7                                        ' Set tx & rx to P0
  baud := 4800                                         ' Set baud to 4800 bps
  Ser.start(rx, tx, %1100, baud)                       ' Start Full Duplex Serial Object


PUB GetInfo(hwStr, fwStr) | hw, fw  
''Retrieve the hardware and firmware versions, storing them as strings.
''This function must be called before the strings can be read using GetHardware and GetFirmware. 
  Ser.str(string("!GPS"))                              ' Send GPS Command Header
  Ser.tx(GPS_GetInfo)                                  ' Send GPS Command

  hw := Ser.rx                                         ' Receive first byte
  fw := Ser.rx                                         ' Receive second byte
  
  ' write and pass out the result strings
  LONG[hwStr] := WriteHardwareStr(hw)
  LONG[fwStr] := WriteFirmwareStr(fw) 


PRI WriteHardwareStr(hw)
  '' format the string and return it
  HardWareStr[0] := "0" + $0F & (hw >> 4)              ' Add high nibble to 0 character
  HardWareStr[1] := "."
  HardWareStr[2] := "0" + $0F & hw                     ' Add low nibble to 0 character
  HardWareStr[3] := 0
  return @HardWareStr

  
PRI WriteFirmwareStr(fw)
  '' format the string and return it
  FirmWareStr[0] := "0" + $0F & (fw >> 4)              ' Add high nibble to 0 character
  FirmWareStr[1] := "."
  FirmWareStr[2] := "0" + $0F & fw                     ' Add low nibble to 0 character
  FirmWareStr[3] := 0
  return @FirmWareStr


PUB GetHardware
'' Return the hardware version of the GPS module
'' GetInfo must be called first to set the string.
  return @HardwareStr


PUB GetFirmware
'' Return the firmware version of the GPS module
'' GetInfo must be called first to set the string.
  return @FirmwareStr


PUB GetValid
'' Is the GPS module returning valid data?
  return GetGPSByte(GPS_GetValid)


PUB GetSats
'' Return the number of satellites received by the GPS module
  return GetGPSByte(GPS_GetSats)


PUB GetDateAndTime(dateStr, timeStr) | yy, mon, day, hrs, mns, sec
{{ The GPS module returns the time in UTC time. GetTimeAndDate reads the time from
   the module, then adjusts it to local time.
   Returns the time as a string formatted hh:mm:ss.
   Returns the date as a string formatted mm/dd/yy.

   Note: The GPS module provides separate time and date functions. However, localizing
   the time may change the date. Because the time and date are therefore dependent
   on each other, the GPS Smart Mode Object provides only one function for date and time.

   This function returns formatted data and time strings by setting two string pointers
   passed into the function. Another way to  return the values would be to set two internal
   string variables, then provide accessors to them. However, those accessors could be called
   long after the last call to GetDateAndTime and be considerably stale. Therefore, the GPS
   Smart Mode Object retains no state and returns the strings only when GetDateAndTime is called.
   
}}

  Ser.str(string("!GPS"))                              ' Send GPS Command Header
  Ser.tx(GPS_GetTime)                                  ' Send GPS Command (GetTime)
  hrs := Ser.rx                                        ' Receive 1st byte
  mns := Ser.rx                                        ' Receive 2nd byte
  sec := Ser.rx                                        ' Receive 3rd byte

  Ser.str(string("!GPS"))                              ' Send GPS Command Header
  Ser.tx(GPS_GetDate)                                  ' Send GPS Command (GetDate)
  day := Ser.rx                                        ' Receive 1st byte
  mon := Ser.rx                                        ' Receive 2nd byte
  yy := Ser.rx                                         ' Receive 3rd byte, 2 digit year

  'Cal.ConvertUTCtoLocaltime( _time_offset, 2000 + yy, mon, day, hrs, mns, sec, _allow_DST, dateStr, timeStr)


PUB GetLatitude
'' Return the latitude from the GPS modules as a single floating point value
  return GetXitude(GPS_GetLat)


PUB GetLongitude
'' Return the longitude from the GPS modules as a single floating point value
  return GetXitude(GPS_GetLong)

    
PRI GetXitude(cmd) | deg, mn, minFrac, negate
'' Get the lat/long-itude from the GPS unit
'' Return as a single floating point value
  Ser.str(string("!GPS"))                              ' Send GPS Command Header
  Ser.tx(cmd)                                          ' Send GPS Command (GetLat)
  deg := Ser.rx                                        ' Receive 1st byte
  mn := Ser.rx                                         ' Receive 2nd byte
  minFrac := ReadWord                                  ' Receive 3rd, 4th bytes as word
  negate := Ser.rx==1                                  ' Receive 5th byte 
  return GetGPSFloat(deg, mn, minFrac, negate)

  
PUB GetGPSFloat(deg, mn, minFrac, negate) : single | minsF, ang
'' convert the given degrees, mins, and fractional minutes to a single floating point value
'' The negate flag converts from W to E or from N to S
  minsF := F.FAdd(F.FFloat(mn), F.FDiv(F.FFloat(minFrac), 10000.0)) 
  ang := F.FAdd(F.FFloat(deg), F.FDiv(minsF, 60.0))
  if negate
    ang := F.FNeg(ang)
  return ang


PUB GetGPSFixed(deg, mn, minFrac, negate) : integer | minsFx, ang
'' convert the given degrees, mins, and fractional minutes to a single fixed point value
'' The negate flag converts from W to E or from N to S
  minsFx := mn*10000 + minFrac
  ang := deg*10000 + minsFx / 60
  if negate
    -ang 
  return ang 


PUB GetAltitude
'' Altitude is returned from the GPS module in meters; convert to feet
'' 1 meter = 3.2808399 feet
  return ReadTenthsAndScale(GPS_GetAlt, 3.2808399) 


PUB GetSpeed
'' Speed is returned from the GPS module in knots; convert to MPH
'' 1 knot = 1.1507771555 MPH  
  return ReadTenthsAndScale(GPS_GetSpeed, 1.1507771555) 


PUB GetHeading
'' Read the heading from the GPS module in degrees. No conversion needed.
  return ReadTenthsAndScale(GPS_GetHead, -1.0) 


PRI ReadTenthsAndScale(cmd, cfact) | val
'' read the given cmd value as a word in tenths. Convert to a floating point value.
'' Then apply the conversion factor, if greater than zero, and return.
  val := F.FDiv(F.FFloat(GetGPSWord(cmd)), 10.0)
  if cfact > 0.0
    val := F.FMul(val, cfact)
  return val
  



PUB GetGPSByte(cmd)  
'' Send a command to the GPS module and read a byte back
  Ser.str(string("!GPS"))                              ' Send GPS Command Header
  Ser.tx(cmd)                                          ' Send GPS Command
  return Ser.rx                                        ' Receive byte


PUB GetGPSWord(cmd)  
'' Send a command to the GPS module and read a word back
  Ser.str(string("!GPS"))                              ' Send GPS Command Header
  Ser.tx(cmd)                                          ' Send GPS Command
  return ReadWord                                      ' Receive word


PRI ReadWord : aword
'' Read a word from the GPS module. Put the first value read into the high byte of the word
  aword.byte[1]  := Ser.rx                            'high byte transmitted first
  aword.byte[0]  := Ser.rx                            'then low byte into rightmost byte                                                                                                    
    
