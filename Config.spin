CON
  _clkmode=xtal1+pll16x
  _xinfreq=5_000_000

  _wallpaper0 = $00
  _wallpaper1 = $73
  _wallpaper2 = $02
  _wallpaper3 = $00

  _Cal00=$13
  _Cal01=$86
  _Cal02=$A8
  _Cal03=$00

  _Cal10=$13
  _Cal11=$86
  _Cal12=$AA
  _Cal13=$00

  _Cal20=$13
  _Cal21=$86
  _Cal22=$AC
  _Cal23=$00

  _Cal30=$13
  _Cal31=$86
  _Cal32=$AE
  _Cal33=$00

  _Cal40=$13
  _Cal41=$86
  _Cal42=$B0
  _Cal43=$00

  _GPS0=$0C
  _GPS1=$80
  _GPS2=$00
  _GPS3=$00

  _MAP0=$0C
  _MAP1=$80
  _MAP2=$02
  _MAP3=$00


pub Wallpaper(num)
  case num
    0: return _wallpaper0
    1: return _wallpaper1
    2: return _wallpaper2
    3: return _wallpaper3

pub Cal0(num)
  case num
    0: return _Cal00
    1: return _Cal01
    2: return _Cal02
    3: return _Cal03

pub Cal1(num)
  case num
    0: return _Cal10
    1: return _Cal11
    2: return _Cal12
    3: return _Cal13

pub Cal2(num)
  case num
    0: return _Cal20
    1: return _Cal21
    2: return _Cal22
    3: return _Cal23

pub Cal3(num)
  case num
    0: return _Cal30
    1: return _Cal31
    2: return _Cal32
    3: return _Cal33


pub Cal4(num)
  case num
    0: return _Cal40
    1: return _Cal41
    2: return _Cal42
    3: return _Cal43

pub GPS(num)
  case num
    0: return _GPS0
    1: return _GPS1
    2: return _GPS2
    3: return _GPS3

pub GPSMap(num)
  case num
    0: return _MAP0
    1: return _MAP1
    2: return _MAP2
    3: return _MAP3
