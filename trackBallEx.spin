CON
  ledpin=0
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

PUB main  :upSig | isUp
'upSig is for IDing when track ball pulses for up
'isUp is to indicate to screen move cursor up
dira[ledpin]:=1
dira[7]:=1
dira[8]:=1
dira[15]:=1
outa[15]:=1

outa[8]:=1
outa[7]:=1

upSig:=ina[10]
'if btn launch cog, timer 1 minute?
repeat
  waitcnt(clkfreq/150+cnt)
  if ina[10]<>upSig
    outa[ledpin]:=1
    upSig:=ina[10]
    isUp:=1
  else
    outa[ledpin]:=0
    isUp:=0

  if ina[14]==0
    outa[ledpin]:=1

