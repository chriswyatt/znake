# znake
Snake clone written in Z80 assembly for the ZX Spectrum

## How to play
You will need to download [znake.tap](znake.tap) and you will need an emulator, e.g. [Speccy](http://fms.komkon.org/Speccy/). The Kempston joystick interface must be enabled, as keyboard controls are not currently supported.

## Compile
Znake was compiled using Pasmo:
`pasmo --name znake --tapbas znake.z8a znake.tap`

## Todo
* High score
* Title screen

## Known issues
* Food tends to be placed at bottom-left or close to snake.
* When snake has almost filled screen, food may be placed at the furthermost
  bottom-left square, even if the snake is occupying that square.

## License
See LICENSE
