CON
  ledpin=0
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

PUB main  :up
dira[ledpin]:=1
dira[7]:=1
dira[8]:=1
dira[15]:=1
outa[15]:=1

outa[8]:=1
outa[7]:=1

up:=ina[10]
'if btn launch cog, timer 1 minute?
repeat
  waitcnt(clkfreq/150+cnt)
  if ina[10]<>up
    outa[ledpin]:=1
    up:=ina[10]
  else
    outa[ledpin]:=0

  if ina[14]==0
    outa[ledpin]:=1

