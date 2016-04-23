# znake
Snake clone written in Z80 assembly for the ZX Spectrum

## Under Development
Currently this is just an early demo, but feel free to send feedback to me at
the World of Spectrum forums

## Compile
Znake was compiled using Pasmo:
`pasmo --name znake --tapbas znake.z8a znake.tap`

## Controls
Currently, only the Kempston interface is supported

## Todo
* High score
* Title screen

## Known issues
* Game can occasionally restart unexpectedly (i.e. snake seems to collide with
  itself, when it shouldn't)
* Timing is jerky, especially when the snake eats food

## License
See LICENSE