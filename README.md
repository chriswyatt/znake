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
* Timing is jerky, especially when the snake eats food
* Food placement is not particularly random, and due to a quirk in the design,
  food tends to be placed close to the snake
* ZX Spectrum eventually resets if left unattended (with the game
  continually restarting)
* Snake head can pass through the tip of its tail

## License
See LICENSE
