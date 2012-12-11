'' *****************************
'' *  Simple_Numbers           *
'' *  (c) 2006 Parallax, Inc.  *
'' *****************************
''
'' Provides simple numeric conversion methods; all methods return a pointer to
'' a string.
''
'' Authors... Chip Gracey, Jon Williams
'' Updated... 29 APR 2006


CON

  MAX_LEN = 64                                          ' 63 chars + zero terminator

  
VAR

  long  idx                                             ' pointer into string
  byte  nstr[MAX_LEN]                                   ' string for numeric data


PUB dec(value)

'' Returns pointer to signed-decimal string

  clrstr(@nstr, MAX_LEN)                                ' clear output string  
  return decstr(value)                                  ' return pointer to numeric string
    

PUB decf(value, width) | t_val, field

'' Returns pointer to signed-decimal, fixed-width (space padded) string

  clrstr(@nstr, MAX_LEN)
  width := 1 #> width <# constant(MAX_LEN - 1)          ' qualify field width 

  t_val := ||value                                      ' work with absolute
  field~                                                ' clear field

  repeat while t_val > 0                                ' count number of digits
    field++
    t_val /= 10

  field #>= 1                                           ' min field width is 1
  if value < 0                                          ' if value is negative
    field++                                             '   bump field for neg sign indicator
  
  if field < width                                      ' need padding?
    repeat (width - field)                              ' yes
      nstr[idx++] := " "                                '   pad with space(s)

  return decstr(value)


PUB decx(value, digits) | div

'' Returns pointer to zero-padded, signed-decimal string
'' -- if value is negative, field width is digits+1

  clrstr(@nstr, MAX_LEN)  
  digits := 1 #> digits <# 10

  if (value < 0)                                        ' negative value?   
    -value                                              '   yes, make positive
    nstr[idx++] := "-"                                  '   and print sign indicator

  div := 1_000_000_000                                  ' initialize divisor
  if digits < 10                                        ' less than 10 digits?
    repeat (10 - digits)                                '   yes, adjust divisor
      div /= 10
  
  value //= (div * 10)                                  ' truncate unused digits
  
  repeat digits
    nstr[idx++] := (value / div + "0")                  ' convert digit to ASCII
    value //= div                                       ' update value
    div /= 10                                           ' update divisor

  return @nstr


PUB hex(value, digits)

'' Returns pointer to a digits-wide hexadecimal string

  clrstr(@nstr, MAX_LEN) 
  return hexstr(value, digits)


PUB ihex(value, digits)

'' Returns pointer to a digits-wide, indicated (with $) hexadecimal string

  clrstr(@nstr, MAX_LEN)
  nstr[idx++] := "$"
  return hexstr(value, digits)


PUB bin(value, digits)

'' Returns pointer to a digits-wide binary string      

  clrstr(@nstr, MAX_LEN)
  return binstr(value, digits)   


PUB ibin(value, digits)

'' Returns pointer to a digits-wide, indicated (with %) binary string

  clrstr(@nstr, MAX_LEN)
  nstr[idx++] := "%"                                    ' preface with binary indicator
  return binstr(value, digits)


PRI clrstr(strAddr, size)

' Clears string at strAddr
' -- also resets global character pointer (idx)

  bytefill(strAddr, 0, size)                            ' clear string to zeros
  idx~                                                  ' reset index

  
PRI decstr(value) | div, z_pad   

' Converts value to signed-decimal string equivalent
' -- characters written to current position of idx
' -- returns pointer to nstr

  if (value < 0)                                        ' negative value? 
    -value                                              '   yes, make positive
    nstr[idx++] := "-"                                  '   and print sign indicator

  div := 1_000_000_000                                  ' initialize divisor
  z_pad~                                                ' clear zero-pad flag

  repeat 10
    if (value => div)                                   ' printable character?
      nstr[idx++] := (value / div + "0")                '   yes, print ASCII digit
      value //= div                                     '   update value
      z_pad~~                                           '   set zflag
    elseif z_pad or (div == 1)                          ' printing or last column?
      nstr[idx++] := "0"
    div /= 10 

  return @nstr


PRI hexstr(value, digits)

' Converts value to digits-wide hexadecimal string equivalent
' -- characters written to current position of idx
' -- returns pointer to nstr

  digits := 1 #> digits <# 8                            ' qualify digits
  value <<= (8 - digits) << 2                           ' prep most significant digit
  repeat digits
    nstr[idx++] := lookupz((value <-= 4) & $F : "0".."9", "A".."F")

  return @nstr
  

PRI binstr(value, digits)

' Converts value to digits-wide binary string equivalent
' -- characters written to current position of idx
' -- returns pointer to nstr

  digits := 1 #> digits <# 32                           ' qualify digits 
  value <<= 32 - digits                                 ' prep MSB
  repeat digits
    nstr[idx++] := (value <-= 1) & 1 + "0"              ' move digits (ASCII) to string

  return @nstr

  