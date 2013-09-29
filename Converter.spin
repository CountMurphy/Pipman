obj
  fm : "FloatMath"
var
  long fp_number

DAT

divisors      long      1.0, 10.0, 100.0, 1_000.0, 10_000.0, 100_000.0
              long      1_000_000.0, 10_000_000.0



pub StrToDec(stringptr) : value | char, index, multiply

    '' Converts a zero terminated string representation of a decimal number to a value

    value := index := 0
    repeat until ((char := byte[stringptr][index++]) == 0)
       if char => "0" and char =< "9"
          value := value * 10 + (char - "0")
    if byte[stringptr] == "-"
       value := - value

pub Convert_ascii_string_to_fp(address) | c, d, dp, pos_sign, neg_sign
''
'' Convert number in printable ascii string format to a floating point format
'' if/elseif could have been used rather than case statement in the repeat loop
''
  d        := false
  dp       := 0
  pos_sign := false
  neg_sign := false

'' Parse the ascii string
''
  repeat while c := byte[address++]
    case c
      $30..$39:                   ' if numeral then add to result value
        result := result * 10 + (c - "0")
          if d                    ' if decimal point is true then...
            dp := dp + 1          ' count the number of decimal places
      $2E: ' decimal point        ' set true if decimal point encountered
        d := true
      $2B: ' positive sign        ' set true if positive sign encountered
        pos_sign := true
      $2D: ' negative sign        ' set true if negative sign encountered
        neg_sign := true

  fp_number := fm.fdiv(fm.ffloat(result),divisors[dp])

  if neg_sign                     ' if neg_sign true then negate the number
    fp_number := fm.fneg(fp_number)

pub DateToDOW(month,day,year)| dow,modMonth
  'convert month to table data
  case month
    1,10: modMonth:=0
    2,3,11: modMonth:=3
    4,7: modMonth:=6
    5: modMonth:=1
    8: modMonth:=2
    6: modMonth:=4
    12,9: modMonth:=5
  if isLeapYear(year)
    'modify if jan or feb
    case month
      1: modMonth:=-1
      2: modMonth:=2
  dow:=day+modMonth+year+(year/4)+6
  dow:=dow//7
  return dow

pub isLeapYear(year)
  if year//4 ==0
    return true
  else
    return false

