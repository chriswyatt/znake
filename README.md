# znake
Snake clone written in Z80 assembly for the ZX Spectrum

## How to play
You will need to download znake.tap and you will need an emulator, e.g. [Speccy](http://fms.komkon.org/Speccy/). The Kempston joystick interface must be enabled, as keyboard controls are not currently supported.

## Compile
Znake was compiled using Pasmo:
`pasmo --name znake --tapbas znake.z8a znake.tap`

## Todo
* High score
* Title screen

## Known issues
* Food placement is not particularly random, and due to a quirk in the design,
  food tends to be placed close to the snake
* Food placement algorithm is slow, which can cause the game to momentarily
  freeze, and also controls become unresponsive

## License
See LICENSE
