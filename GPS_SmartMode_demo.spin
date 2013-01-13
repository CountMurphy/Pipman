{{ ************************************
   *  GPS Module Smart Mode Demo      *
   *  (C) 2007 Gary Noel Boone, PhD   *
   ************************************

   Demonstrate the use of the GPS Smart Mode Object by printing to the Tv terminal
   each of the values available from the GPS Module. See the GPS_SmartMode.spin
   comments for additional documentation.
}}   

CON

        _clkmode        = xtal1 + pll16x
        _xinfreq        = 5_000_000


  
OBJ

  Term  : "tv_terminal"
  FS    : "FloatString"
  GPS   : "GPS_SmartMode"



PUB start | x, y

  GPS.start(GPS#PACIFIC_TIME, TRUE)                     ' Start the GPS object with localization
  Term.start(12)                                        ' Start TV Terminal Object
  SetScreenWhiteOnDarkBlue
                                      
  repeat
    Term.Out(0)                                         ' Clear screen                                                                                                                              

    Term.str(string("__GPS Smart Mode Data__"))
    Term.out(13)                                        ' Carriage Return
    Term.out(13)                                        ' Carriage Return

    WriteInfo
    WriteValid
    WriteSatellites
    WriteTimeAndDate
    WriteLatitude  
    WriteLongitude  
    WriteAltitude  
    WriteSpeed
    WriteHeading
    waitcnt(500_000_000 + cnt)


     
PRI SetScreenWhiteOnDarkBlue                 
  Term.Out(3)                       
  Term.Out(5)


PRI  WriteInfo | hwStr, fwStr
  GPS.GetInfo(@hwStr, @fwStr)
  Term.str(string("Hardware : "))
  Term.str(hwStr)
  Term.out(13)                                          ' Carriage Return
  Term.str(string("Firmware : "))
  Term.str(fwStr)
  Term.out(13)                                          ' Carriage Return


PRI  WriteValid
  Term.str(string("Valid  : "))
  Term.dec(GPS.GetValid)
  Term.out(13)                                          ' Carriage Return

                              
PRI  WriteSatellites
  Term.str(string("Satellites : "))
  Term.dec(GPS.GetSats)
  Term.out(13)                                          ' Carriage Return


PRI WriteTimeAndDate | date_str, time_str
  GPS.GetDateAndTime(@date_str, @time_str)

  Term.str(string("Time   : "))
  Term.str(time_str)
  Term.out(13)                                          ' Carriage Return

  Term.str(string("Date   : "))
  Term.str(date_str)
  Term.out(13)                                          ' Carriage Return


PRI WriteLatitude | lat 
  Term.str(string("Latitude  : "))
  ' retrieve and write the longitude as a floating point value
  lat := GPS.GetLatitude
  Term.str(FS.FloatToString(lat))
  Term.str(string(" degrees"))
  Term.out(13)                                          ' Carriage Return

  
PRI WriteLongitude | lon
  Term.str(string("Longitude : "))
  ' retrieve and write the longitude as a floating point value
  lon := GPS.GetLongitude
  Term.str(FS.FloatToString(lon))
  Term.str(string(" degrees"))
  Term.out(13)                                          ' Carriage Return


PRI WriteAltitude | alt
  Term.str(string("Altitude : "))
  alt := GPS.GetAltitude
  Term.str(FS.FloatToString(alt))
  Term.str(string(" feet"))
  Term.out(13)                                          ' Carriage Return


PRI WriteSpeed | speed
  Term.str(string("Speed : "))
  speed := GPS.GetSpeed
  Term.str(FS.FloatToString(speed))
  Term.str(string(" mph"))
  Term.out(13)                                          ' Carriage Return


PRI WriteHeading | hdg
  Term.str(string("Heading : "))
  hdg := GPS.GetHeading
  Term.str(FS.FloatToString(hdg))
  Term.str(string(" degrees"))
  Term.out(13)                                          ' Carriage Return
  
