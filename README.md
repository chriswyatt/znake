# znake
Snake clone written in Z80 assembly for the ZX Spectrum

## Why?
Mainly as a programming exercise. I have always programmed using high-level languages and had always wanted to try my hand at something lower-level. I picked Snake, because it's a (relatively) simple game, and I have fond memories of it on Microsoft QBASIC and old Nokia handsets.

I decided to code for the ZX Spectrum as I had started learning BASIC on a ZX Spectrum as a child. Unfortunately the ZX Spectrum died before I had got very far with learning it.

If anyone would like to help me improve the game (even if only the graphics), please contact me. If you would like to help with the look of the game, coding skills are not required.

This is my first attempt at assembly so the code is probably not a fantastic example. I am open to suggestions/improvements; however as I work on this project in my spare time, it could take me a while to address them.

## How to play
You will need to download [znake.tap](znake.tap) and you will need an emulator, e.g. [Speccy](http://fms.komkon.org/Speccy/). The Kempston joystick interface must be enabled, as keyboard controls are not currently supported.

## ZX Vega
The game will 'just work' on the ZX Vega; a keymap is not required.

## Assemble
Znake was assembled using Pasmo:
`pasmo --name znake --tapbas znake.asm znake.tap`

## License
See LICENSE

## Contact
If you would like to contact me, please email chris ~.d0t.~ wyatt ~.at.~ zoho.com
