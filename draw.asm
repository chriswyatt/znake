; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; draw.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

draw_char:

; Takes column/row (bc) and pointer (hl) and draws a character to the display
; buffer. Set iy to either draw_line or draw_line_xor before calling.

    ; Get the memory location of the first line of a character

    ; Calculate high byte of display location

    ; The high byte represents the display section and line number (which is
    ; added later on)

    ld a,e

    ; Discard all but bits 3 and 4. Taken in isolation, these are the offsets
    ; for the display section, specifically 0x00, 0x08 and 0x10
    and 0x18 ;

    ; The high byte for the first line of each character is either 0x40, 0x48
    ; or 0x50, depending on which section it recides in
    add a,0x40

    ld b,a

    ; Calculate low byte of display location

    ; The low byte represents row and column numbers

    ld a,e

    ; This calculates the row number grouped by display section, i.e.:
    ; row 0 = 0x00, row 1 = 0x20, row 7 = 0xE0, row 8 = 0x00, etc.
    rrca
    rrca
    rrca
    and 0xf0

    ; The first line of each column is offset by a byte
    add a,d

    ld d,b
    ld e,a

    ; A character has 8 lines
    ld b,8

    jp (iy)

macro _draw_line, xor_, djnz_addr

    if xor_
        ld a,(de)
        xor (hl)
    else
        ld a,(hl)
    endif
    ld (de),a
    inc l

    ; The high byte is incremented to get the destination of the next line
    inc d

    djnz djnz_addr

    ret

endm

draw_line:

; Draw a character line by line

    _draw_line 0, draw_line

draw_line_xor:

; Draw a character line by line and xor with existing line

    _draw_line 1, draw_line_xor
