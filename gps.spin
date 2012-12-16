CON
  ledpin=0
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000
pub main
  dira[20]:=1
  outa[20]:=1

  waitcnt(clkfreq+cnt*3)
