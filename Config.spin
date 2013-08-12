CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

  _wallpaper0 = $00
  _wallpaper1 = $73
  _wallpaper2 = $02
  _wallpaper3 = $00



pub Wallpaper(num)
  case num
    0: return _wallpaper0
    1: return _wallpaper1
    2: return _wallpaper2
    3: return _wallpaper3
